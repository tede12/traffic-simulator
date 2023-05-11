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
        @newTrackPath = []

    mousedown: (e) =>
        cell = @getCell e

        # Click on intersection (build intersection)
        hoveredIntersection = @getHoveredIntersection cell
        if e.shiftKey and hoveredIntersection?
            @sourceIntersection = hoveredIntersection
            e.stopImmediatePropagation()

        # Click on lane (add my car)
        hoveredLane = @getHoveredLane @getScaledPoint e
        if e.ctrlKey
            if hoveredLane?.road
                @visualizer.world.addMyCar hoveredLane.road
            e.stopImmediatePropagation()

        # Click on intersection (add intersection to track path)
        if e.altKey and hoveredIntersection?
            @newTrackPath.push {
                'cell': cell,
                'intersection': hoveredIntersection
            }
            e.stopImmediatePropagation()
        else
            @newTrackPath.pop() if @newTrackPath.length > 0

    keydown: (e) =>
        if e.altKey and e.keyCode is 83  # character 's'
            console.log 'Saving track path'
            @visualizer.world.trackPath = @newTrackPath
            # clear track path drawing
            @newTrackPath = []
            # draw track path lines
            @visualizer.drawTrackPath()
            e.stopImmediatePropagation()

        if e.altKey and e.keyCode is 67  # character 'c'
            console.log 'Add MyCar with API'
            @visualizer.world.addMyCarAPI()
            e.stopImmediatePropagation()

        if e.altKey and e.keyCode is 71  # character 'g'
            console.log 'Get Shortest Path based only on length with API'
            @visualizer.world.getShortestPathLengthOnlyAPI()
            e.stopImmediatePropagation()

    mouseup: (e) =>
        @visualizer.world.addRoad @road if @road?
        @visualizer.world.addRoad @dualRoad if @dualRoad?
        @road = @dualRoad = @sourceIntersection = null

    mousemove: (e) =>
        cell = @getCell e
        hoveredIntersection = @getHoveredIntersection cell
        if (@sourceIntersection and hoveredIntersection and @sourceIntersection.id isnt hoveredIntersection.id)
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

        # Draw selection path
        if @newTrackPath
            count = 1
            for obj in @newTrackPath
                @visualizer.graphics.fillRect obj['cell'], 'red', 0.5
                @ctx.font = '5px Arial'
                @ctx.fillStyle = '#c19020'
                @ctx.fillText count, obj['cell'].x, obj['cell'].y - 0.5
                count += 1

module.exports = ToolRoadBuilder
