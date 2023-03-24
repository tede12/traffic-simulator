'use strict'

{max, min, random, sqrt} = Math
require '../helpers'
_ = require 'underscore'
Trajectory = require './trajectory'
uniqueId = require '../helpers'
settings = require '../settings'

myCarID = "MACCHINA"
class Car
    constructor: (lane, position) ->
        @id = uniqueId 'car' # @id = _.uniqueId 'car'
        @color = (300 + 240 * random() | 0) % 360
        @_speed = 0
        @width = 1.7
        @length = 3 + 2 * random()
        @maxSpeed = 30
        @s0 = 2
        @timeHeadway = 1.5
        @maxAcceleration = 1
        @maxDeceleration = 3
        @trajectory = new Trajectory this, lane, position
        @alive = true
        @preferedLane = null
        @tooLongStop = 0
        @trackPoints = []

    @property 'coords',
        get: ->
            if @id == settings.myCar.id
                if @alive and settings.myCar.maxFollowPoints > 0
                    @trackPoints.push @trajectory.coords
                    if @trackPoints.length > settings.myCar.maxFollowPoints
#                       keep only last n points
                        @trackPoints = @trackPoints.slice(@trackPoints.length - settings.myCar.maxFollowPoints)
                else
                    @trackPoints = []

            return @trajectory.coords


    @property 'speed',
        get: -> @_speed
        set: (speed) ->
            speed = 0 if speed < 0
            speed = @maxSpeed if speed > @maxSpeed
            @_speed = speed

    @property 'direction',
        get: -> @trajectory.direction

    release: ->
        @trajectory.release()

    getAcceleration: ->
        nextCarDistance = @trajectory.nextCarDistance
        distanceToNextCar = max nextCarDistance.distance, 0
        a = @maxAcceleration
        b = @maxDeceleration
        deltaSpeed = (@speed - nextCarDistance.car?.speed) || 0
        freeRoadCoeff = (@speed / @maxSpeed) ** 4
        distanceGap = @s0
        timeGap = @speed * @timeHeadway
        breakGap = @speed * deltaSpeed / (2 * sqrt a * b)
        safeDistance = distanceGap + timeGap + breakGap
        busyRoadCoeff = (safeDistance / distanceToNextCar) ** 2
        safeIntersectionDistance = 1 + timeGap + @speed ** 2 / (2 * b)
        intersectionCoeff =
            (safeIntersectionDistance / @trajectory.distanceToStopLine) ** 2
        coeff = 1 - freeRoadCoeff - busyRoadCoeff - intersectionCoeff
        return @maxAcceleration * coeff

    move: (delta) ->
        if (@id == myCarID)
            @moveMACCHINA(delta)
        else
            acceleration = @getAcceleration()
            @speed += acceleration * delta

            if not @trajectory.isChangingLanes and @nextLane
                currentLane = @trajectory.current.lane
                turnNumber = currentLane.getTurnDirection @nextLane
                preferedLane = switch turnNumber
                    when 0 then currentLane.leftmostAdjacent
                    when 2 then currentLane.rightmostAdjacent
                    else
                        currentLane
                if preferedLane isnt currentLane
                    @trajectory.changeLane preferedLane

            step = @speed * delta + 0.5 * acceleration * delta ** 2
            # Added by me
            if step <= 0
                @tooLongStop += 1
                if @tooLongStop > 1000
                    @alive = false
            # TODO: hacks, should have changed speed
            if @trajectory.nextCarDistance.distance < step
                console.log 'bad IDM'

            if @trajectory.timeToMakeTurn(step)
                return @alive = false if not @nextLane?
            @trajectory.moveForward step

    moveMACCHINA: (delta) ->
        acceleration = @getAcceleration()
        @speed += acceleration * delta

        if not @trajectory.isChangingLanes and @nextLane
            currentLane = @trajectory.current.lane
            turnNumber = currentLane.getTurnDirection @nextLane
            preferedLane = switch turnNumber
                when 0 then currentLane.leftmostAdjacent
                when 2 then currentLane.rightmostAdjacent
                else
                    currentLane
            if preferedLane isnt currentLane
                @trajectory.changeLane preferedLane

        step = @speed * delta + 0.5 * acceleration * delta ** 2

        if @trajectory.nextCarDistance.distance < step
            @speed == @speed/10
            step = @speed * delta + 0.5 * acceleration * delta ** 2

        if @trajectory.timeToMakeTurn(step)
            return @alive = false if not @nextLane?
        @trajectory.moveForward step

    pickNextRoad: ->
        intersection = @trajectory.nextIntersection
        currentLane = @trajectory.current.lane
        possibleRoads = intersection.roads.filter (x) ->
            x.target isnt currentLane.road.source
        return null if possibleRoads.length is 0
        nextRoad = _.sample possibleRoads

    pickNextLane: ->
        throw Error 'next lane is already chosen' if @nextLane
        @nextLane = null
        nextRoad = @pickNextRoad()
        return null if not nextRoad
        # throw Error 'can not pick next road' if not nextRoad
        turnNumber = @trajectory.current.lane.road.getTurnDirection nextRoad
        laneNumber = switch turnNumber
            when 0 then nextRoad.lanesNumber - 1
            when 1 then _.random 0, nextRoad.lanesNumber - 1
            when 2 then 0
        @nextLane = nextRoad.lanes[laneNumber]
        throw Error 'can not pick next lane' if not @nextLane
        return @nextLane

    popNextLane: ->
        nextLane = @nextLane
        @nextLane = null
        @preferedLane = null
        return nextLane

module.exports = Car
