'use strict'

require '../helpers'
$ = require 'jquery'
_ = require 'underscore'
Point = require '../geom/point'
Rect = require '../geom/rect'
require('jquery-mousewheel')

METHODS = ['click', 'mousedown', 'mouseup', 'mousemove', 'mouseout', 'mousewheel', 'contextmenu']
DOCUMENT_METHODS = ['keydown'] # keydown is not a method of canvas element but of document

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
        @keydown = @keydown.bind @
        @bind() if autobind

    bind: ->
        @isBound = true
        for method in METHODS when @[method]?
            $(@canvas).on method, @[method]
        for method in DOCUMENT_METHODS when @[method]?
            $(document).on method, @[method]

    unbind: ->
        @isBound = false
        for method in METHODS when @[method]?
            $(@canvas).off method, @[method]
        for method in DOCUMENT_METHODS when @[method]?
            $(document).off method, @[method]

    toggleState: ->
        if @isBound then @unbind() else @bind()

    draw: =>

    getPoint: (e) =>
        new Point e.pageX - @canvas.offsetLeft, e.pageY - @canvas.offsetTop

    getCell: (e) =>
        @visualizer.zoomer.toCellCoords @getPoint e

    getScaledPoint: (e) =>
        @visualizer.zoomer.toPointCoords @getPoint e

    getHoveredIntersection: (cell) =>
        intersections = @visualizer.world.intersections.all()
        for id, intersection of intersections
            return intersection if intersection.rect.containsRect cell

    getHoveredLane: (currentPoint) =>
        intersections = @visualizer.world.intersections.all()
        for id, intersection of intersections
            for road in intersection.roads
                for lane in road.lanes
                    return lane if lane.rect.containsPoint currentPoint

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

    keydown: (e) ->
# Method code here

module.exports = Tool
