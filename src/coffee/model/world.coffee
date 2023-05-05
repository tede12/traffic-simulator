'use strict'

{random} = Math
require '../helpers'
_ = require 'underscore'
Car = require './car'
Intersection = require './intersection'
Road = require './road'
Pool = require './pool'
Rect = require '../geom/rect'
settings = require '../settings'
savedMaps = require '../maps'
uuid = require 'uuid'
mapsIdCounter = require '../mapsIdCounter'
clearCounters = require '../helpers'

class World
    constructor: ->
        @set {}
        @createDynamicMapMethods()
        @trackPath = []
        @bestPath = []
        @lengthOnlyPath = []
        @carObject = {
            lastTimeSpawn: null     # time when last car was spawned
        }
        @activeCars = 0
        @roadsUpdateCounterInterval = 0

    @property 'instantSpeed',
        get: ->
            speeds = _.map @cars.all(), (car) -> car.speed
            return 0 if speeds.length is 0
            return (_.reduce speeds, (a, b) -> a + b) / speeds.length

    createDynamicMapMethods: ->
#       create method with name mapName as function name and call @load
        constructor = @constructor
        for mapName, mapData of savedMaps
#           do prevents mapName and mapData from being overwritten in the loop with the last values
            do (mapName, mapData) ->
                constructor::[mapName] = (-> @load mapData, mapName, false)

    set: (obj) ->
        obj ?= {}
        @intersections = new Pool Intersection, obj.intersections
        @roads = new Pool Road, obj.roads
        @cars = new Pool Car, obj.cars
        @carsNumber = 0
        @time = 0
        @mapId = null


    save: (forRequest = false) ->
        data = _.extend {}, this
        delete data.cars

        if forRequest
#           get only intersections, roads
            return JSON.stringify {
                mapId: data.mapId
                intersections: data.intersections
                roads: data.roads
                carsNumber: data.carsNumber
                time: data.time
#                controlSignals: data.controlSignals
            }

        localStorage.world = JSON.stringify data

    load: (data, mapName, parse = true) ->
        data = data or localStorage.world
        if data and parse
            data = JSON.parse data
        return unless data?
        @clear()


        @carsNumber = data.carsNumber or 0
        for id, intersection of data.intersections
            @addIntersection Intersection.copy intersection
        for id, road of data.roads
            road = Road.copy road
            road.source = @getIntersection road.source
            road.target = @getIntersection road.target
            road.carsNumber = 0
            @addRoad road

        @mapId = mapName
        @newRequest settings.mapUrl, 'POST', null, {map: @save(true)}

    generateMap: (minX = -settings.mapSize, maxX = settings.mapSize, minY = -settings.mapSize, maxY = settings.mapSize) ->
        @clear()


        intersectionsNumber = (0.8 * (maxX - minX + 1) * (maxY - minY + 1)) | 0
        map = {}
        gridSize = settings.gridSize
        step = 5 * gridSize
        @carsNumber = settings.carsNumber
        while intersectionsNumber > 0
            x = _.random minX, maxX
            y = _.random minY, maxY
            unless map[[x, y]]?
                rect = new Rect step * x, step * y, gridSize, gridSize
                intersection = new Intersection rect
                @addIntersection map[[x, y]] = intersection
                intersectionsNumber -= 1
        for x in [minX..maxX]
            previous = null
            for y in [minY..maxY]
                intersection = map[[x, y]]
                if intersection?
                    if random() < 0.9
                        @addRoad new Road intersection, previous if previous?
                        @addRoad new Road previous, intersection if previous?
                    previous = intersection
        for y in [minY..maxY]
            previous = null
            for x in [minX..maxX]
                intersection = map[[x, y]]
                if intersection?
                    if random() < 0.9
                        @addRoad new Road intersection, previous if previous?
                        @addRoad new Road previous, intersection if previous?
                    previous = intersection

        # Check if maps is OK (all intersections are connected)
        if settings.connectedMap
            for id, intersection of @intersections.all()
                if intersection.roads.length < 2
                    return @generateMap minX, maxX, minY, maxY

        @mapId = uuid.v4() # generate new map id
        console.log 'Map generated'
        # Send new map to server
        @newRequest(settings.mapUrl, 'POST', null, {map: @save(true)})

    addMyCar: (road, laneId = 0) ->
        if road instanceof Road
            roadId = road.id
        else
            roadId = road
            road = @getRoad(road)

        if road
#           Stop spawning of car for settings.waitCarSpawn secs
            @carObject.lastTimeSpawn = @time

            lane = road.lanes[laneId]
            @removeCarById(settings.myCar.id)
            @carsNumber = @carsNumber + 1
            car = new Car lane
            car.speed = 1.0
            car.id = settings.myCar.id
            car.color = settings.myCar.color
            for obj in @trackPath
                intersection = obj['intersection']
                @addIntersectionToMyCarPath(intersection.id, car)
            @addCar car
            car.path.shift()
            car.path.shift()


    addIntersectionToMyCarPath: (intersectionId, car) ->
        intersection = @getIntersection(intersectionId)
        if intersection
            car.path.push(intersection)
        return


    newRequest: (url, method = 'GET', params = null, data = null) ->
        """xmlHttpRequest with CORS prevention"""
        # add params to url as query string parameters
        if params
            url = url + '?' + new URLSearchParams(params).toString()

        xhr = new XMLHttpRequest()
        xhr.open(method, url, false) # Change async to false
        if data
            xhr.setRequestHeader('Content-Type', 'application/json')
            data = JSON.stringify data

        xhr.cors = true

        try
#           Send request synchronously
            xhr.send(data)

            if xhr.readyState == XMLHttpRequest.DONE
                if xhr.status == 200
                    return xhr.responseText
                else
                    console.log "[Request Error]: #{xhr.status}"
                    return false
        catch error
            console.log "[Request Error]: #{error}"
            return false

    getShortestPathAPI: (lengthOnly = "false") ->
        """lengthOnly: compute shortest path only based on length of roads, otherwise based on number of cars on roads and length of roads"""

        # send api post request to update carsNumber of each road
        if lengthOnly == "false"
            @newRequest(settings.roadsUrl, 'PATCH', null, {mapId: @mapId, roads: @roads.all()})

        sourceId_prefix = @trackPath[0]['intersection'].id
        targetId_prefix = @trackPath[@trackPath.length - 1]['intersection'].id # get the last intersection in the track path (allow to repeat the command more than once)
        sourceId = sourceId_prefix.slice 'intersection'.length
        targetId = targetId_prefix.slice 'intersection'.length

        params = {
            'fromIntersection': sourceId,
            'mapId': @mapId,
            'toIntersection': targetId,
            'lengthOnly': lengthOnly
        }
        data = @newRequest settings.pathFinderUrl, 'GET', params, null
        if data
            data = JSON.parse data
            if data['status'] == 'ok'
                return data['path']
            else
                console.log "Error: #{data['message']}"
        else
            console.log 'Error: No data received from server'


    addMyCarAPI: () ->
        path = @getShortestPathAPI()
        @carObject.lastTimeSpawn = @time
        console.log "Best Path: #{path}"
        visualizer.drawTrackPath path, 'yellow' # draw the best path on the map
        source_int = @getIntersection(path[0])
        source_road = null
        for road in source_int.roads
            if road.target.id == path[1]
                source_road = road
                break
        @addMyCar(source_road, 0)

    clear: ->
        @set {}
        @carObject.lastTimeSpawn = null
        # set to 0 all property of mapsIdCounter
        for key, value of mapsIdCounter
            mapsIdCounter[key] = 0

        # clear trackPath
        @trackPath = []
        # clear lengthOnlyPath
        @lengthOnlyPath = []

        if settings.debugTestHtml
            document.getElementById('trackPath').innerHTML = '';
            document.getElementById('lengthOnlyPath').innerHTML = '';


    onTick: (delta) =>
        throw Error 'delta > 1' if delta > 1
        @time += delta
        #       When myCar is spawned, stop spawning of other cars for settings.waitCarSpawn secs
        if @carObject?.lastTimeSpawn and @time - @carObject.lastTimeSpawn > settings.waitCarSpawn
            @refreshCars()
            @carObject.lastTimeSpawn = null
        else if @carObject?.lastTimeSpawn is null
            @refreshCars()

        for id, intersection of @intersections.all()
            intersection.controlSignals.onTick delta

        for id, car of @cars.all()
            car.move delta
            @removeCar car unless car.alive

        # Assign a color to the road in base of the number of cars / road length ratio (for showing traffic)
        for id, road of @roads.all()
            if settings.trafficHighlight
                roadCarsNumber = 0
                for lane in road.lanes
                    ratio = lane.carsNumber / (road.length / settings.averageCarLength)
                    if 0 <= ratio <= 0.5
                        lane.color = settings.colors.road  # should be the 'green' version of traffic
                    else if 0.5 < ratio <= 0.8
                        lane.color = 'orange'  # '#FFD580' more light
                    else if ratio > 0.8
                        lane.color = 'red'
                    roadCarsNumber += lane.carsNumber

                # update road carsNumber
                road.carsNumber = roadCarsNumber
            else
                [lane.color = settings.colors.road for lane in road.lanes]

    refreshCars: ->
        @addRandomCar() if @cars.length < @carsNumber
        @removeRandomCar() if @cars.length > @carsNumber

    addRoad: (road) ->
        @roads.put road
        road.source.roads.push road
        road.target.inRoads.push road
        road.update()

    getRoad: (id) ->
        @roads.get id

    addCar: (car) ->
        @cars.put car

    getCar: (id) ->
        @cars.get(id)

    removeCarById: (id) ->
        car = @getCar(id)
        if car
            @removeCar(car)

    removeCar: (car) ->
        @cars.pop car
        car.release()

    addIntersection: (intersection) ->
        @intersections.put intersection

    getIntersection: (id) ->
        @intersections.get id

    addRandomCar: ->
        road = _.sample @roads.all()
        if road?
#           lane = _.sample road.lanes  # original code
#           takes only the first lane -> this prevents to have during generation of the map more cars spawned on the same lane
            lane = road.lanes[0]
            @addCar new Car lane if lane?

    removeRandomCar: ->
        car = _.sample @cars.all()
        if car?
            @removeCar car

module.exports = World