'use strict'

require '../helpers.coffee'
Tool = require './tool.coffee'
settings = require '../settings.coffee'
Point = require '../geom/point.coffee'

class ToolHighlighter extends Tool
    constructor: ->
        super arguments...
        @hoveredCell = null
        @hoveredLane = null
        @isTracking = false

    mousemove: (e) =>
        cell = @getCell e
        #        hoveredIntersection = @getHoveredIntersection cell
        hoveredLane = @getHoveredLane @getScaledPoint e

        if e.ctrlKey
            @hoveredLane = hoveredLane
            @hoveredCell = null
            @isTracking = false
        else if e.altKey
            @hoveredCell = cell
            @hoveredLane = null
            @isTracking = true
            return
        else
            @hoveredCell = cell
            @hoveredLane = null
            @isTracking = false

        for id, intersection of @visualizer.world.intersections.all()
            intersection.color = null
            for road of intersection.roads
                for lane of road.lanes
                    lane.color = null

    mouseout: =>
        @hoveredCell = null
        @hoveredLane = null

    draw: =>
        if @hoveredCell and not @isTracking
            color = settings.colors.hoveredGrid
            @visualizer.graphics.fillRect @hoveredCell, color, 0.5
        else if @hoveredCell and @isTracking
            color = settings.colors.hoveredLane
            @visualizer.graphics.fillRect @hoveredCell, 'red', 0.5

        if @hoveredLane
            color = settings.colors.hoveredLane
            @visualizer.graphics.fillRect @hoveredLane.rect, color, 0.5

module.exports = ToolHighlighter
