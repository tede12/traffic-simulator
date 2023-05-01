'use strict'

settings =
    colors:
        background: '#FFFFFF'  # 97a1a1'
        redLight: 'hsl(0, 100%, 50%)'
        greenLight: '#85ee00'
        intersection: '#586970'
        road: '#586970'
        roadMarking: '#bbb'
        hoveredIntersection: '#3d4c53'
        tempRoad: '#aaa'
        gridPoint: '#586970'
        grid1: 'rgba(255, 255, 255, 0.5)'
        grid2: 'rgba(220, 220, 220, 0.5)'
        hoveredGrid: '#f4e8e1'
        hoveredLane: '#dbd0ca'
    fps: 30
    lightsFlipInterval: 160
    gridSize: 14
    mapSize: 4  # default is 2
    defaultTimeFactor: 5
    defaultZoomLevel: 6  # Change this value to change the default zoom level (default is 3)
    defaultMap: 'mappa_1'   # null to disable or 'mappa_1' to enable
    connectedMap: true  # enable to generate only connected maps (all intersections are connected)
    debug: true

#   See updateCanvasSize() in visualizer.coffee
    canvasWidth: 1400    # fullscreen == true -> $(window).width
    canvasHeight: 1100   # fullscreen == true -> $(window).height
    fullScreen: true

#   signals settings
    showRedLights: true
    triangles: true  # false -> circles
    carsNumber: 150
    carsGap: 5
    waitCarSpawn: 40  # time dependent to the canvas time factor, it's not seconds
    tooLongStop: 1000

#   car settings
    myCar:
        id: "MACCHINA"
        color: "#000000"
        maxFollowPoints: 1000  # 3000 is the default value, 0 to disable
        carLine: 'black'

#   roads setting
    updateRoadsInterval: 50

#   API
    pathFinderUrl: 'http://localhost:8000/pathFinder'
    mapUrl: 'http://localhost:8000/map'
    roadsUrl: 'http://localhost:8000/roads'



module.exports = settings
