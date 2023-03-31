'use strict'

{PI} = Math
require '../helpers'
$ = require 'jquery'
_ = require 'underscore'
chroma = require 'chroma-js'
Point = require '../geom/point'
Rect = require '../geom/rect'
Segment = require '../geom/segment'
Intersection = require '../model/intersection'

Graphics = require './graphics'
ToolMover = require './mover'
ToolIntersectionMover = require './intersection-mover'
ToolIntersectionBuilder = require './intersection-builder'
ToolRoadBuilder = require './road-builder'
ToolHighlighter = require './highlighter'
Zoomer = require './zoomer'
settings = require '../settings'

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

        @trackPath = world.trackPath

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
#        sourceSide = road.sourceSide
#        targetSide = road.targetSide

        @ctx.save()
        @ctx.lineWidth = 0.4
        leftLine = road.leftmostLane.leftBorder
        @graphics.drawSegment leftLine
        @graphics.stroke settings.colors.roadMarking

        rightLine = road.rightmostLane.rightBorder
        @graphics.drawSegment rightLine
        @graphics.stroke settings.colors.roadMarking
        @ctx.restore()

        # Draw entire road (works perfectly)
        # @graphics.polyline sourceSide.source, sourceSide.target, targetSide.source, targetSide.target
        # @graphics.fill settings.colors.road, alpha

        # Draw single road lanes (this permits to draw the lanes with different colors)
        for lane in road.lanes
            @graphics.drawRect lane.rect
            color = lane.color or settings.colors.road
            @graphics.fill color, alpha


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

        @ctx.save()
        if settings.debug
#           Draw lane ids
            for lane in road.lanes
                @ctx.fillStyle = "black"
                @ctx.font = "1px Arial"
                center = lane.rightBorder.center
                if lane.stringDirection in ['left', 'right']
#                   todo fix with middle line position
                    @ctx.fillText lane.id, center.x, center.y + 2.0
                else
                    @ctx.fillText lane.id, center.x, center.y - 2.0

        @ctx.restore()

        if settings.debug
#           Draw road ids
            @ctx.save()
            @ctx.fillStyle = "black"
            @ctx.font = "1px Arial"
            center1 = road.lanes[0].middleLine.center
            center2 = road.lanes[1].middleLine.center
            newCenter = new Point (center1.x + center2.x) / 2, (center1.y + center2.y) / 2
            @ctx.fillText road.id, newCenter.x, newCenter.y
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
# center, radius, width = 0.1, color, fill = false
            @graphics.drawCircle p, 0.2, 0.1, settings.colors.carLine, true
            @graphics.fill settings.colors.carLine
        #            @graphics.stroke settings.colors.carLine

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
            @graphics.save()
            @drawCarLines car for id, car of @world.cars.all()
            # ------------------------------------------------------------------------
            @drawTrackPath()
            # ------------------------------------------------------------------------
            @graphics.restore()
        window.requestAnimationFrame @draw if @running

    checkIfPointOrIntersection: (obj) ->
        if obj instanceof Point
#           check in all intersections and find the one that contains the point
            _rect = new Rect obj.x, obj.y, 0.1, 0.1
            for id, intersection of @world.intersections.all()
                if intersection.rect.containsRect _rect
                    obj = intersection
                    break
        else if obj instanceof Intersection
            {}
        else
            obj = @world.intersections.objects[obj]
        return obj


    getDirectionGivenIntersections: (intersection1, intersection2) ->
        intersection1 = @checkIfPointOrIntersection(intersection1)
        intersection2 = @checkIfPointOrIntersection(intersection2)
        if intersection1 is undefined or intersection2 is undefined
            console.log 'Intersection not found'
            return

        if intersection1.rect.center().x < intersection2.rect.center().x
            return 'right'
        else if intersection1.rect.center().x > intersection2.rect.center().x
            return 'left'
        else if intersection1.rect.center().y < intersection2.rect.center().y
            return 'down'
        else if intersection1.rect.center().y > intersection2.rect.center().y
            return 'up'

    checkBeforeAndNextPath: (trackPath, currIdx) ->
        nextPath = trackPath[currIdx + 1]
        if nextPath is undefined
            nextPath = trackPath[currIdx]
        currPath = @checkIfPointOrIntersection(trackPath[currIdx])
        if nextPath
            nextPath = @checkIfPointOrIntersection(nextPath)

        if currPath and nextPath
            return @getDirectionGivenIntersections(currPath, nextPath)
        else
            throw new Error 'Something went wrong in checkBeforeAndNextPath'

    getIntersectionLaneByDirection: (intersection, direction) ->
        roads = intersection.roads # roads are going out of the intersection
        for road in roads
            for lane in road.lanes
                if lane.stringDirection == direction
                    return lane

    drawTrackPath: ->
#       TODO: add curve when needed
        if @world.trackPath.length < 2
            return

        getIntersections = []
        for i in @world.trackPath
            getIntersections.push(i['intersection'])

        firstIntersection = @checkIfPointOrIntersection(getIntersections[0])
        startPoint = firstIntersection.rect.center() # first intersection
        endPoint = getIntersections[getIntersections.length - 1].rect.center() # last last intersection

        newTrackPath = {'startPoint': startPoint}
        lastPoint = startPoint

        dir = @checkBeforeAndNextPath(getIntersections, 0)
        lane = @getIntersectionLaneByDirection(firstIntersection, dir)

        for i in [1..getIntersections.length - 2]
            intersect = @checkIfPointOrIntersection(getIntersections[i])
            newPoint = intersect?.rect.center()
            if newPoint is undefined
                console.log 'Intersection ' + intersect.id + ' not found'
                return

            dir = @checkBeforeAndNextPath(getIntersections, i)
            lane = @getIntersectionLaneByDirection(intersect, dir)

            # good version
            segment = new Segment lastPoint, newPoint
            newTrackPath[intersect.id] = segment
            lastPoint = newPoint

            # if the last point add last segment and endPoint
            if i == getIntersections.length - 2
                segment = new Segment lastPoint, endPoint
                newTrackPath['lastSegment'] = segment
                newTrackPath['endPoint'] = endPoint

        @graphics.drawPolylineFeatures newTrackPath, 0.3, 'blue'
        @graphics.restore()


    _testDrawTrackPath: ->
#       TODO: add curve when needed
        startPoint = @world.intersections.objects['intersection1']?.rect.center()
        endPoint = @world.intersections.objects['intersection9']?.rect.center()
        if startPoint is undefined or endPoint is undefined
            return

        trackPath = [startPoint, 'intersection2', 'intersection3', 'intersection4', 'intersection5', 'intersection6',
            endPoint]
        newTrackPath = {'startPoint': startPoint}
        lastPoint = startPoint

        dir = @checkBeforeAndNextPath(trackPath, 0)
        lane = @getIntersectionLaneByDirection(@world.intersections.objects['intersection1'], dir)

        for i in [1..trackPath.length - 2]
            intersect = @world.intersections.objects[trackPath[i]]
            newPoint = intersect?.rect.center()
            if newPoint is undefined
                console.log 'Intersection ' + trackPath[i] + ' not found'
                return

            dir = @checkBeforeAndNextPath(trackPath, i)
            lane = @getIntersectionLaneByDirection(intersect, dir)

            # good version
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
