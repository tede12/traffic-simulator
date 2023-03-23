'use strict'

require '../helpers.coffee'
_ = require 'underscore'
Tool = require './tool.coffee'
Car = require '../model/car.coffee'
Road = require '../model/road.coffee'
settings = require("../settings.coffee")

class ToolRoadBuilder extends Tool
    constructor: ->
        super arguments...
        @sourceIntersection = null
        @road = null
        @dualRoad = null

    mousedown: (e) =>
        cell = @getCell e
        hoveredIntersection = @getHoveredIntersection cell
        if e.shiftKey and hoveredIntersection?
            @sourceIntersection = hoveredIntersection
            e.stopImmediatePropagation()

        # Add car with specs in the middle of a lane
        #        hoveredLane = @getHoveredLane cell
        hoveredLane = @getHoveredIntersection cell
        if e.ctrlKey and hoveredLane?
            intersection = @getHoveredIntersection cell
            road = _.sample intersection.roads
            lane = _.sample road.lanes

            car = new Car lane
            car.speed = 0.0
            car.id = settings.myCar.id
            car.color = settings.myCar.color

            @visualizer.world.addCar car
            e.stopImmediatePropagation()


    mouseup: (e) =>
        @visualizer.world.addRoad @road if @road?
        @visualizer.world.addRoad @dualRoad if @dualRoad?
        @road = @dualRoad = @sourceIntersection = null

    mousemove: (e) =>
        cell = @getCell e
        hoveredIntersection = @getHoveredIntersection cell
        if (@sourceIntersection and hoveredIntersection and
                @sourceIntersection.id isnt hoveredIntersection.id)
            if @road?
                @road.target = hoveredIntersection
                @dualRoad.source = hoveredIntersection
            else
                @road = new Road @sourceIntersection, hoveredIntersection
                @dualRoad = new Road hoveredIntersection, @sourceIntersection
        else
            @road = @dualRoad = null

    mouseout: (e) =>
        @road = @dualRoad = @sourceIntersection = null

    draw: =>
        @visualizer.drawRoad @road, 0.4 if @road?
        @visualizer.drawRoad @dualRoad, 0.4 if @dualRoad?

module.exports = ToolRoadBuilder
