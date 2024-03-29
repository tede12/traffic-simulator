'use strict'

{min, max} = Math
require '../helpers.coffee'
Point = require '../geom/point.coffee'
Rect = require '../geom/rect.coffee'
Tool = require './tool.coffee'
settings = require '../settings'
Point = require '../geom/point.coffee'


class Zoomer extends Tool
    constructor: (@defaultZoom, visualizer, args) ->
        super visualizer, args
        @ctx = visualizer.ctx
        @canvas = @ctx.canvas
        @_scale = 1
        @screenCenter = new Point settings.myWidth / 2, settings.myHeight / 2
        @center = new Point settings.myWidth / 2, settings.myHeight / 2

    @property 'scale',
        get: ->
            if @_scale > settings.maxZoomLevel
                @_scale = settings.maxZoomLevel
            else if @_scale < settings.minZoomLevel
                @_scale = settings.minZoomLevel
            else
                @_scale

        set: (scale) ->
            if scale > settings.maxZoomLevel
                scale = settings.maxZoomLevel
            else if scale < settings.minZoomLevel
                scale = settings.minZoomLevel

            @zoom scale, @screenCenter

    toCellCoords: (point) ->
        """Cell coordinates of a point on the canvas."""
        gridSize = settings.gridSize
        centerOffset = point.subtract(@center).divide(@scale)
        x = centerOffset.x // (@defaultZoom * gridSize) * gridSize
        y = centerOffset.y // (@defaultZoom * gridSize) * gridSize
        new Rect x, y, gridSize, gridSize

    toPointCoords: (point) ->
        """Real coordinates of a point on the canvas."""
        centerOffset = point.subtract(@center).divide(@scale)
        x = centerOffset.x // (@defaultZoom)
        y = centerOffset.y // (@defaultZoom)
        new Point x, y

    getBoundingBox: (cell1, cell2) ->
        cell1 ?= @toCellCoords new Point 0, 0
        cell2 ?= @toCellCoords new Point settings.myWidth, settings.myHeight
        x1 = cell1.x
        y1 = cell1.y
        x2 = cell2.x
        y2 = cell2.y
        xMin = min cell1.left(), cell2.left()
        xMax = max cell1.right(), cell2.right()
        yMin = min cell1.top(), cell2.top()
        yMax = max cell1.bottom(), cell2.bottom()
        new Rect xMin, yMin, xMax - xMin, yMax - yMin

    transform: ->
        @ctx.translate @center.x, @center.y
        k = @scale * @defaultZoom
        @ctx.scale k, k

    zoom: (k, zoomCenter) ->
        if k > settings.maxZoomLevel
            k = settings.maxZoomLevel
        else if k < settings.minZoomLevel
            k = settings.minZoomLevel

        k ?= 1
        offset = @center.subtract zoomCenter
        @center = zoomCenter.add offset.mult k / @_scale
        @_scale = k

    moveCenter: (offset) ->
        @center = @center.add offset

    mousewheel: (e) ->
#       Original code: e.deltaY * - e.deltaFactor. These values are not available anymore.
        offset = e.originalEvent.deltaY * -e.originalEvent.eventPhase
        zoomFactor = 2 ** (0.001 * offset)
        @zoom @scale * zoomFactor, @getPoint e
        e.preventDefault()

module.exports = Zoomer
