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
ItasApi = require 'itas_api'
class World
    constructor: ->
        @set {}
        @createDynamicMapMethods()
        @trackPath = []
        @bestPath = []

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
                constructor::[mapName] = (-> @load mapData, false)

    set: (obj) ->
        obj ?= {}
        @intersections = new Pool Intersection, obj.intersections
        @roads = new Pool Road, obj.roads
        @cars = new Pool Car, obj.cars
        @carsNumber = 0
        @time = 0

    save: ->
        data = _.extend {}, this
        delete data.cars
        localStorage.world = JSON.stringify data

    load: (data, parse = true) ->
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
            @addRoad road

    generateMap: (minX = -2, maxX = 2, minY = -2, maxY = 2) ->
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
        null

    addMyCar: (road, laneId = 0) ->
        if road instanceof Road
            roadId = road.id
        else
            roadId = road
            road = @getRoad(road)

        if road
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
            @addCar(car)

    addIntersectionToMyCarPath: (intersectionId, car) ->
        intersection = @getIntersection(intersectionId)
        if intersection
            car.path.push(intersection)
        return

    addMyCarAPI: () ->
        # add track path to MyCar Object with only source and target intersection and make an api request to retrieve the best path
        sourceId_prefix = @trackPath[0]['intersection'].id
        targetId_prefix = @trackPath[1]['intersection'].id
        sourceId = sourceId_prefix.slice 'intersection'.length
        targetId = targetId_prefix.slice 'intersection'.length

        api = new ItasApi.PathFinderApi(new ItasApi.ApiClient('http://localhost:8000'))
        cb = (err, data, res) ->
            if err
                console.log err
                return
            else
                path = data['path']
                console.log "Best Path: #{path}"
                source_int = @getIntersection(path[0])
                source_lane = null
                source_road = null

                for road in source_int.roads
                    if road.target.id == path[1]
                        source_road = road
                        break

                source_lane = source_road.lanes[0]

                car = new Car source_lane
                car.speed = 1.0
                car.id = settings.myCar.id
                car.color = settings.myCar.color

                for intersection in path
                    @addIntersectionToMyCarPath(intersection, car)

                @addCar car
                return data

        api.pathFinderRetrieve sourceId, 0, targetId, cb.bind(this)

    clear: ->
        @set {}

    onTick: (delta) =>
        throw Error 'delta > 1' if delta > 1
        @time += delta
        @refreshCars()
        for id, intersection of @intersections.all()
            intersection.controlSignals.onTick delta
        for id, car of @cars.all()
            car.move delta
            @removeCar car unless car.alive

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
            lane = _.sample road.lanes
            @addCar new Car lane if lane?

    removeRandomCar: ->
        car = _.sample @cars.all()
        if car?
            @removeCar car

module.exports = World
