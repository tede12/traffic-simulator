'use strict'

require '../helpers.coffee'
$ = require 'jquery'
_ = require 'underscore'
Point = require '../geom/point.coffee'
Rect = require '../geom/rect.coffee'
require('jquery-mousewheel')

METHODS = ['click', 'mousedown', 'mouseup', 'mousemove', 'mouseout', 'mousewheel', 'contextmenu']

class Tool
    constructor: (visualizer, autobind) ->
        @visualizer = visualizer
        @ctx = @visualizer.ctx
        @canvas = @ctx.canvas
        @isBound = false
        @bind = @bind.bind @
        @unbind = @unbind.bind @
        @click = @click.bind @
        @mousedown = @mousedown.bind @
        @mouseup = @mouseup.bind @
        @mousemove = @mousemove.bind @
        @mouseout = @mouseout.bind @
        @mousewheel = @mousewheel.bind @
        @contextmenu = @contextmenu.bind @
        @bind() if autobind

    bind: ->
        @isBound = true
        for method in METHODS when @[method]?
            $(@canvas).on method, @[method]

    unbind: ->
        @isBound = false
        for method in METHODS when @[method]?
            $(@canvas).off method, @[method]

    toggleState: ->
        if @isBound then @unbind() else @bind()

    draw: =>

    getPoint: (e) =>
        new Point e.pageX - @canvas.offsetLeft, e.pageY - @canvas.offsetTop

    getCell: (e) =>
        @visualizer.zoomer.toCellCoords @getPoint e

    getHoveredIntersection: (cell) =>
        intersections = @visualizer.world.intersections.all()
        for id, intersection of intersections
            return intersection if intersection.rect.containsRect cell

# TODO could be needed for adding car in road-builder in the right lane and not in intersection
#    getHoveredLane: (cell) =>
#        goodLanes = []
#        roads = @visualizer.world.roads.all()
#        for id, road of roads
#            for roadLane in road.lanes
#                if roadLane.middleLine.center
#                    {}
#
#        return goodLanes[0] if goodLanes.length > 0


    click: (e) ->
# Method code here

    mousedown: (e) ->
# Method code here

    mouseup: (e) ->
# Method code here

    mousemove: (e) ->
# Method code here

    mouseout: (e) ->
# Method code here

    mousewheel: (e) ->
# Method code here

    contextmenu: (e) ->
# Method code here

module.exports = Tool
