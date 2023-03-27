'use strict'

{PI} = Math
require '../helpers.coffee'
Point = require '../geom/point'
Rect = require '../geom/rect'
Curve = require '../geom/curve'
Segment = require '../geom/segment'
settings = require '../settings'

class Graphics
    constructor: (@ctx) ->

    fillRect: (rect, style, alpha) ->
        @ctx.fillStyle = style if style?
        _alpha = @ctx.globalAlpha
        @ctx.globalAlpha = alpha if alpha?
        @ctx.fillRect rect.left(), rect.top(), rect.width(), rect.height()
        @ctx.globalAlpha = _alpha

    drawRect: (rect) ->
        @ctx.beginPath
        vertices = rect.getVertices()
        @ctx.beginPath()
        @moveTo vertices[0]
        @lineTo point for point in vertices[1..]
        @ctx.closePath()

    drawImage: (image, rect) ->
        @ctx.drawImage image, rect.left(), rect.top(), rect.width(), rect.height()

    clear: (color) ->
        @ctx.fillStyle = color
        @ctx.fillRect 0, 0, @ctx.canvas.width, @ctx.canvas.height

    moveTo: (point) ->
        @ctx.moveTo point.x, point.y

    lineTo: (point) ->
        @ctx.lineTo point.x, point.y

    drawLine: (source, target) ->       # when is called need to be called stroke or fill
        @ctx.beginPath()
        @moveTo source
        @lineTo target

    drawSegment: (segment, width = null, color = null) ->
        if width
            @ctx.lineWidth = width
        @drawLine segment.source, segment.target
        if color                # Added by me
            @stroke color

    drawCurve: (curve, width, color) ->
        pointsNumber = 10
        @ctx.lineWidth = width
        @ctx.beginPath()
        @moveTo curve.getPoint 0
        for i in [0..pointsNumber]
            point = curve.getPoint i / pointsNumber
            @lineTo point
        if curve.O
            @moveTo curve.O
            @ctx.arc curve.O.x, curve.O.y, width, 0, 2 * PI
        if curve.Q
            @moveTo curve.Q
            @ctx.arc curve.Q.x, curve.Q.y, width, 0, 2 * PI
        @stroke color if color

    drawTriangle: (p1, p2, p3) ->
        @ctx.beginPath()
        @moveTo p1
        @lineTo p2
        @lineTo p3

    drawCircle: (center, radius, width, color) ->   # Added by me
        @ctx.beginPath()
        @ctx.arc center.x, center.y, radius, 0, 2 * PI
        @ctx.lineWidth = width
        @stroke color if color

    fill: (style, alpha) ->
        @ctx.fillStyle = style
        _alpha = @ctx.globalAlpha
        @ctx.globalAlpha = alpha if alpha?
        @ctx.fill()
        @ctx.globalAlpha = _alpha

    stroke: (style) ->
        @ctx.strokeStyle = style
        @ctx.stroke()

    polyline: (points...) ->
        if points.length >= 1
            @ctx.beginPath()
            @moveTo points[0]
            for point in points[1..]
                @lineTo point
            @ctx.closePath()

    drawPolylineFeatures: (featureList, width, color) ->
        @ctx.moveTo(featureList[0].x, featureList[0].y) if featureList[0] instanceof Point # Not necessary

        text = ''
        middlePoint = new Point 0, 0

        for featureName, featureType of featureList
            if featureName.startsWith '_'
                text = featureName + ' '
            else
                text = 'Coords: '

            if featureType instanceof Point
                @drawCircle featureType, width, color
                text += "at #{featureType.x}, #{featureType.y}"
                middlePoint = featureType
            else if featureType instanceof Segment
                @drawSegment featureType, width, color
                middlePoint = new Point (featureType.source.x + featureType.target.x) / 2, (featureType.source.y + featureType.target.y) / 2
                text += "from #{featureType.source.x}, #{featureType.source.y} to #{featureType.target.x}, #{featureType.target.y}"
                @stroke color
            else if featureType instanceof Curve
                @drawCurve featureType, width, color
#               TODO: add debug info
            else
                throw Error 'Unknown feature type ->' + featureType

            if settings.debug
                @ctx.fillStyle = "yellow"
                @ctx.font = "1px Arial"
                @ctx.fillText text, middlePoint.x, middlePoint.y + 2.0

        @ctx.stroke()

    save: ->
        @ctx.save()

    restore: ->
        @ctx.restore()

module.exports = Graphics
