'use strict'

{PI} = Math
require '../helpers'
$ = require 'jquery'
_ = require 'underscore'
chroma = require 'chroma-js'
Point = require '../geom/point'
Rect = require '../geom/rect'
Graphics = require './graphics'
ToolMover = require './mover'
ToolIntersectionMover = require './intersection-mover'
ToolIntersectionBuilder = require './intersection-builder'
ToolRoadBuilder = require './road-builder'
ToolHighlighter = require './highlighter'
Zoomer = require './zoomer'
settings = require '../settings'
{abs} = Math
Segment = require '../geom/segment'

class Visualizer
    constructor: (@world) ->
        @$canvas = $('#canvas')
        @canvas = @$canvas[0]
        @ctx = @canvas.getContext('2d')

        @carImage = new Image()
        @carImage.src = 'images/car.png'

        @updateCanvasSize()
        @zoomer = new Zoomer settings.defaultZoomLevel, this, true
        @graphics = new Graphics @ctx
        @toolRoadbuilder = new ToolRoadBuilder this, true
        @toolIntersectionBuilder = new ToolIntersectionBuilder this, true
        @toolHighlighter = new ToolHighlighter this, true
        @toolIntersectionMover = new ToolIntersectionMover this, true
        @toolMover = new ToolMover this, true
        @_running = false
        @previousTime = 0
        @timeFactor = settings.defaultTimeFactor

    drawIntersection: (intersection, alpha) ->
        color = intersection.color or settings.colors.intersection
        @graphics.drawRect intersection.rect
        @ctx.lineWidth = 0.4
        @graphics.stroke settings.colors.roadMarking
        @graphics.fillRect intersection.rect, color, alpha

        if settings.debug
            @ctx.save()
            @ctx.fillStyle = 'black'
            @ctx.font = '1.0px Arial'
            center = intersection.rect.center()
            @ctx.fillText intersection.id, center.x - 2.0, center.y - 1.0
            @ctx.restore()

    fixSignal: (road) ->
        sideId = road.targetSideId

        lights = [true, true, true]

        # lights index: 2 (left) <- 0 (up) -> 1 (right)
        switch (sideId)

            when 0 # South
                lights[1] = false # block south-center signal
                for r in road.target.inRoads
                    if r.sourceSideId == 0
                        lights[1] = true

                lights[0] = false # block south-right signal
                for r in road.target.inRoads
                    if r.sourceSideId == 3 # and settings.triangles
                        lights[0] = true

                lights[2] = false # block south-left signal
                for r in road.target.inRoads
                    if r.sourceSideId == 1 # and settings.triangles
                        lights[2] = true

            when 1 # East
                lights[0] = false # block east-left signal
                for r in road.target.inRoads
                    if r.sourceSideId == 0 # and settings.triangles
                        lights[0] = true

                lights[2] = false # block east-right signal
                for r in road.target.inRoads
                    if r.sourceSideId == 2 # and settings.triangles
                        lights[2] = true

                lights[1] = false # block east-center signal
                for r in road.target.inRoads
                    if r.sourceSideId == 1
                        lights[1] = true

            when 2 # North      OK
                lights[1] = false # block north-center signal
                for r in road.target.inRoads
                    if r.sourceSideId == 2
                        lights[1] = true

                lights[0] = false # block north-left signal
                for r in road.target.inRoads
                    if r.sourceSideId == 1 # and settings.triangles
                        lights[0] = true

                lights[2] = false # block north-right signal
                for r in road.target.inRoads
                    if r.sourceSideId == 3 # and settings.triangles
                        lights[2] = true

            when 3 # West

                lights[2] = false # block west-right signal
                for r in road.target.inRoads
                    if r.sourceSideId == 0 # and settings.triangles
                        lights[2] = true

                lights[0] = false # block west-left
                for r in road.target.inRoads
                    if r.sourceSideId == 2 # and settings.triangles
                        lights[0] = true

                lights[1] = false # block west-center
                for r in road.target.inRoads
                    if r.sourceSideId == 3
                        lights[1] = true

        return lights


    drawSignals: (road) ->
        lightsColors = [settings.colors.redLight, settings.colors.greenLight]
        intersection = road.target

        # sideId = 1 if East, 2 if North, 3 if West, 4 if South

        segment = road.targetSide
        sideId = road.targetSideId
        lights = intersection.controlSignals.state[sideId]

        @ctx.save()
        @ctx.translate segment.center.x, segment.center.y
        @ctx.rotate (sideId + 1) * PI / 2
        @ctx.scale 1 * segment.length, 1 * segment.length
        # map lane ending to [(0, -0.5), (0, 0.5)]

        # Remove signals for dead ends or 2-way intersections
        if intersection.inRoads.length == 1 or intersection.inRoads.length == 2
            @ctx.restore()
            return

        else if intersection.inRoads.length == 3    # T-intersection
            newLight = @fixSignal(road) # This function check if the signal is not necessary and could be hidden
            c = 0
            for l in newLight
                if l == false
                    lights[c] = -1
                c += 1


        # Draw signals 1 is Green, 0 is Red, -1 is Hidden
        if lights[0] == 1
            if settings.triangles
                @graphics.drawTriangle(
                        new Point(0.1, -0.2),
                        new Point(0.2, -0.4),
                        new Point(0.3, -0.2)
                )
            else
                @graphics.drawCircle(new Point(0.2, -0.3), 0.1)

            @graphics.fill settings.colors.greenLight
        else if lights[0] == -1
            {}
        else if lights[0] == 0 and settings.showRedLights
            if settings.triangles
                @graphics.drawTriangle(
                        new Point(0.1, -0.2),
                        new Point(0.2, -0.4),
                        new Point(0.3, -0.2)
                )
            else
                @graphics.drawCircle(new Point(0.2, -0.3), 0.1)
            @graphics.fill settings.colors.redLight

        if lights[1] == 1
            if settings.triangles
                @graphics.drawTriangle(
                        new Point(0.3, -0.1),
                        new Point(0.5, 0),
                        new Point(0.3, 0.1)
                )
            else
                @graphics.drawCircle(new Point(0.4, 0), 0.1)

            @graphics.fill settings.colors.greenLight
        else if lights[1] == -1
            {}
        else if lights[1] == 0 and settings.showRedLights
            if settings.triangles
                @graphics.drawTriangle(
                        new Point(0.3, -0.1),
                        new Point(0.5, 0),
                        new Point(0.3, 0.1)
                )
            else
                @graphics.drawCircle(new Point(0.4, 0), 0.1)
            @graphics.fill settings.colors.redLight

        if lights[2] == 1
            if settings.triangles
                @graphics.drawTriangle(
                        new Point(0.1, 0.2),
                        new Point(0.2, 0.4),
                        new Point(0.3, 0.2)
                )
            else
                @graphics.drawCircle(new Point(0.2, 0.3), 0.1)
            @graphics.fill settings.colors.greenLight
        else if lights[2] == -1
            {}
        else if lights[2] == 0 and settings.showRedLights
            if settings.triangles
                @graphics.drawTriangle(
                        new Point(0.1, 0.2),
                        new Point(0.2, 0.4),
                        new Point(0.3, 0.2)
                )
            else
                @graphics.drawCircle(new Point(0.2, 0.3), 0.1)
            @graphics.fill settings.colors.redLight

        @ctx.restore()
        if settings.debug
            @ctx.save()
            @ctx.fillStyle = "black"
            @ctx.font = "1px Arial"
            center = intersection.rect.center()
            flipInterval = Math.round(intersection.controlSignals.flipInterval * 100) / 100
            phaseOffset = Math.round(intersection.controlSignals.phaseOffset * 100) / 100
            @ctx.fillText flipInterval + ' - ' + phaseOffset, center.x - 2.0, center.y
            @ctx.restore()

    drawRoad: (road, alpha) ->
        throw Error 'invalid road' if not road.source? or not road.target?
        sourceSide = road.sourceSide
        targetSide = road.targetSide

        @ctx.save()
        @ctx.lineWidth = 0.4
        leftLine = road.leftmostLane.leftBorder
        @graphics.drawSegment leftLine
        @graphics.stroke settings.colors.roadMarking

        rightLine = road.rightmostLane.rightBorder
        @graphics.drawSegment rightLine
        @graphics.stroke settings.colors.roadMarking
        @ctx.restore()

        @graphics.polyline sourceSide.source, sourceSide.target,
                targetSide.source, targetSide.target
        @graphics.fill settings.colors.road, alpha

        @ctx.save()
        for lane in road.lanes[1..]
            line = lane.rightBorder
            dashSize = 1
            @graphics.drawSegment line
            @ctx.lineWidth = 0.2
            @ctx.lineDashOffset = 1.5 * dashSize
            @ctx.setLineDash [dashSize]
            @graphics.stroke settings.colors.roadMarking
        @ctx.restore()

        if settings.debug
            @ctx.save()
            @ctx.fillStyle = "black"
            @ctx.font = "1px Arial"
            center1 = road.lanes[0].middleLine.center
            center2 = road.lanes[1].middleLine.center
            center = new Point (center1.x + center2.x) / 2, (center1.y + center2.y) / 2
            @ctx.fillText road.id, center.x, center.y
            @ctx.restore()

    drawCar: (car) ->
        angle = car.direction
        center = car.coords
        rect = new Rect 0, 0, 1.1 * car.length, 1.7 * car.width
        rect.center new Point 0, 0
        boundRect = new Rect 0, 0, car.length, car.width
        boundRect.center new Point 0, 0

        @graphics.save()
        @ctx.translate center.x, center.y
        @ctx.rotate angle
        if car.id == settings.myCar.id
            style = settings.myCar.color
        else
            l = 0.90 - 0.30 * car.speed / car.maxSpeed
            style = chroma(car.color, 0.8, l, 'hsl').hex()

        # @graphics.drawImage @carImage, rect
        @graphics.fillRect boundRect, style
        @graphics.restore()
        if settings.debug
            @ctx.save()
            @ctx.fillStyle = "black"
            @ctx.font = "1px Arial"
            @ctx.fillText car.id, center.x, center.y

            if car.id == settings.myCar.id
#                draw trajectory curve
                if (curve = car.trajectory.temp?.lane)?
                    @graphics.drawCurve curve, 0.1, 'blue'
                @ctx.restore()
                return

            if (curve = car.trajectory.temp?.lane)?
                @graphics.drawCurve curve, 0.1, 'red'
            @ctx.restore()

    drawGrid: ->
        gridSize = settings.gridSize
        box = @zoomer.getBoundingBox()
        return if box.area() >= 2000 * gridSize * gridSize
        sz = 0.4

        for i in [box.left()..box.right()] by gridSize
            for j in [box.top()..box.bottom()] by gridSize
                rect = new Rect i - sz / 2, j - sz / 2, sz, sz
                @graphics.fillRect rect, settings.colors.gridPoint


    drawCarLines: (car) ->
        if car.id != settings.myCar.id
            return

        @ctx.beginPath()
        @ctx.moveTo car.trackPoints[0].x, car.trackPoints[0].y # move to first point

        for p in car.trackPoints
            @graphics.drawCircle p, 0.2
            @graphics.fill 'black'

        @ctx.stroke()
        @ctx.restore()

    updateCanvasSize: ->
#       Check settings.fullScreen
        if settings.fullScreen is true
            canvasWidth = $(window).width()
            canvasHeight = $(window).height()
        else
            canvasWidth = settings.canvasWidth
            canvasHeight = settings.canvasHeight

        if @$canvas.attr('width') isnt canvasWidth or @$canvas.attr('height') isnt canvasHeight
            @$canvas.attr
                width: canvasWidth
                height: canvasHeight

    draw: (time) =>
        delta = (time - @previousTime) || 0
        if delta > 30
            delta = 100 if delta > 100
            @previousTime = time
            @world.onTick @timeFactor * delta / 1000
            @updateCanvasSize()
            @graphics.clear settings.colors.background
            @graphics.save()
            @zoomer.transform()
            @drawGrid()
            for id, intersection of @world.intersections.all()
                @drawIntersection intersection, 0.9
            @drawRoad road, 0.9 for id, road of @world.roads.all()
            @drawSignals road for id, road of @world.roads.all()
            @drawCar car for id, car of @world.cars.all()
            @toolIntersectionBuilder.draw() # TODO: all tools
            @toolRoadbuilder.draw()
            @toolHighlighter.draw()
            # ------------------------------------------------------------------------
            # ADDING LINES THAT FOLLOW THE CARS
            @drawCarLines car for id, car of @world.cars.all()
            # ------------------------------------------------------------------------
            #            @drawTrackPath()
            # ------------------------------------------------------------------------
            @graphics.restore()
        window.requestAnimationFrame @draw if @running

    drawTrackPath: ->
#       TODO: add curve when needed
        startPoint = @world.intersections.objects['intersection1']?.rect.center()
        endPoint = @world.intersections.objects['intersection6']?.rect.center()

        trackPath = [startPoint, 'intersection2', 'intersection3', 'intersection4', 'intersection5', endPoint]
        newTrackPath = {'startPoint': startPoint}
        lastPoint = startPoint

        for i in [1..trackPath.length - 2]
            newPoint = @world.intersections.objects[trackPath[i]]?.rect.center()
            if newPoint is undefined
                console.log 'Intersection ' + trackPath[i] + ' not found'
                return

            segment = new Segment lastPoint, newPoint
            newTrackPath[trackPath[i]] = segment
            lastPoint = newPoint

            # if the last point add last segment and endPoint
            if i == trackPath.length - 2
                segment = new Segment lastPoint, endPoint
                newTrackPath['lastSegment'] = segment
                newTrackPath['endPoint'] = endPoint

        @graphics.drawPolylineFeatures newTrackPath, 0.3, 'blue'
        @graphics.restore()

    @property 'running',
        get: -> @_running
        set: (running) ->
            if running then @start() else @stop()

    start: ->
        unless @_running
            @_running = true
            @draw()

    stop: ->
        @_running = false

module.exports = Visualizer
