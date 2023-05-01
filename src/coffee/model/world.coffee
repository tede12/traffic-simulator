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

class World
    constructor: ->
        @set {}
        @createDynamicMapMethods()
        @trackPath = []
        @bestPath = []
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
        @trackPath = []
        trackPathElement = document.getElementById('trackPath');
        trackPathElement.innerHTML = '';
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

        # clear trackPath
        @trackPath = []
        trackPathElement = document.getElementById('trackPath');
        trackPathElement.innerHTML = '';

        # set to 0 all property of mapsIdCounter
        for key, value of mapsIdCounter
            mapsIdCounter[key] = 0
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

    setNewPath: (data) ->
        @carObject.lastTimeSpawn = @time

        path = data['path']
        console.log "Best Path: #{path}"

        visualizer.drawTrackPath path, 'yellow' # draw the best path on the map
        source_int = @getIntersection(path[0])
        source_road = null

        for road in source_int.roads
            if road.target.id == path[1]
                source_road = road
                break
        @addMyCar(source_road, 0)
        return data

    newRequest: (url, method = 'GET', params = null, data = null) ->
        """xmlHttpRequest with CORS prevention"""
        console.log method
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


    addMyCarAPI: () ->
#       add track path to MyCar Object with only source and target intersection and make an api request to retrieve the best path
        sourceId_prefix = @trackPath[0]['intersection'].id
        targetId_prefix = @trackPath[@trackPath.length - 1]['intersection'].id # get the last intersection in the track path (allow to repeat the command more than once)
        sourceId = sourceId_prefix.slice 'intersection'.length
        targetId = targetId_prefix.slice 'intersection'.length

        params = {
            'fromIntersection': sourceId,
            'mapId': @mapId,
            'toIntersection': targetId
        }
        data = @newRequest settings.pathFinderUrl, 'GET', params, null
        if data
#           Parse response to json
            data = JSON.parse data
            if data['status'] == 'ok'
                @setNewPath data
            else
                console.log "Error: #{data['message']}"
        else
            console.log 'Error: No data received from server'

    clear: ->
        @set {}

    onTick: (delta) =>
        throw Error 'delta > 1' if delta > 1
        @time += delta
#       When myCar is spawned, stop spawning of other cars for settings.waitCarSpawn secs
        if @carObject?.lastTimeSpawn and @time - @carObject.lastTimeSpawn > settings.waitCarSpawn    # todo check time
            @refreshCars()
        else if @carObject?.lastTimeSpawn is null
            @refreshCars()

        for id, intersection of @intersections.all()
            intersection.controlSignals.onTick delta
        for id, car of @cars.all()
            car.move delta
            @removeCar car unless car.alive

        #reset carsNumber of each road and update it
        for id, road of @roads.all()
            road.carsNumber = 0
        for id, car of @cars.all()
            road = car.trajectory.current.lane.road
            road.carsNumber += 1

        #send api post request to update carsNumber of each road
        if @roadsUpdateCounterInterval == settings.updateRoadsInterval
            @newRequest(settings.roadsUrl, 'PATCH', null, {mapId: @mapId, roads: @roads.all()})
            @roadsUpdateCounterInterval = 0
        @roadsUpdateCounterInterval++

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