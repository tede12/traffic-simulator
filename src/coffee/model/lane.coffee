'use strict'

require '../helpers'
_ = require 'underscore'
Segment = require '../geom/segment'
uniqueId = require '../helpers'

class Lane
    constructor: (@sourceSegment, @targetSegment, @road) ->
        @id = uniqueId 'lane' # @id = _.uniqueId 'lane'
        @leftAdjacent = null
        @rightAdjacent = null
        @leftmostAdjacent = null
        @rightmostAdjacent = null
        @carsPositions = {}
        @update()

    toJSON: ->
        obj = _.extend {}, this
        delete obj.carsPositions
        obj

    @property 'sourceSideId',
        get: -> @road.sourceSideId

    @property 'targetSideId',
        get: -> @road.targetSideId

    @property 'isRightmost',
        get: -> this is @.rightmostAdjacent

    @property 'isLeftmost',
        get: -> this is @.leftmostAdjacent

    @property 'leftBorder',
        get: ->
            new Segment @sourceSegment.source, @targetSegment.target

    @property 'rightBorder',
        get: ->
            new Segment @sourceSegment.target, @targetSegment.source

    @property 'stringDirection',
        get: ->
            if @direction is undefined then throw Error 'direction is undefined'

            if Math.round(@direction) == 0  # 0.00
                return 'right'
            else if Math.round(@direction) == 3  # 3.14
                return 'left'
            else if Math.round(@direction) == 2  # 1.57
                return 'down'
            else if Math.round(@direction) == -2  # -1.57
                return 'up'
            else
                throw Error 'invalid direction'

    update: ->
        @middleLine = new Segment @sourceSegment.center, @targetSegment.center
        @length = @middleLine.length
        @direction = @middleLine.direction

    getTurnDirection: (other) ->
        return @road.getTurnDirection other.road

    getDirection: ->
        @direction

    getPoint: (a) ->
        @middleLine.getPoint a

    addCarPosition: (carPosition) ->
        throw Error 'car is already here' if carPosition.id of @carsPositions
        @carsPositions[carPosition.id] = carPosition

    removeCar: (carPosition) ->
        throw Error 'removing unknown car' unless carPosition.id of @carsPositions
        delete @carsPositions[carPosition.id]

    getNext: (carPosition) ->
        throw Error 'car is on other lane' if carPosition.lane isnt this
        next = null
        bestDistance = Infinity
        for id, o of @carsPositions
            distance = o.position - carPosition.position
            if not o.free and 0 < distance < bestDistance
                bestDistance = distance
                next = o
        next

module.exports = Lane
