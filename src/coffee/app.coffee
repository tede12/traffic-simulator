'use strict'

require './helpers'
$ = require 'jquery'
_ = require 'underscore'
Visualizer = require './visualizer/visualizer'
DAT = require 'dat-gui'
World = require './model/world'
settings = require './settings'
savedMaps = require './maps'


waitForElements = (ids, callback) ->
    remaining = ids.length
    observer = new MutationObserver (mutationsList, observer) ->
        mutationsList.forEach (mutation) ->
            if mutation.type is 'childList' and mutation.addedNodes.length > 0
# Check if the added nodes include any of the target elements
                for id in ids
                    if document.getElementById(id)
                        remaining -= 1
                if remaining is 0
                    callback()
                    observer.disconnect()
    observer.observe document.body,
        childList: true,
        subtree: true


waitForElements ['canvas', 'gui'], ->

# Created in the React component
#  canvas = $('<canvas />', {id: 'canvas'})
#  $(document.body).append(canvas)

    # App code
    console.log 'App started --> ' + new Date().toLocaleTimeString()
    window.settings = settings
    window.world = new World()

    # load default map if it exists
    if settings.defaultMap and savedMaps[settings.defaultMap]
        mapData = savedMaps[settings.defaultMap]
        mapData.carsNumber = settings.carsNumber
        world.load mapData, settings.defaultMap, false
    else
        world.generateMap()
        world.carsNumber = settings.carsNumber

    window.visualizer = new Visualizer world
    visualizer.start()

    #  -------------------------------------------------------------------------------------------------------------------
    # create the GUI with custom configuration
    gui = new DAT.GUI({autoPlace: false})
    gui.domElement.id = 'dat_gui'
    targetElement = document.getElementById('gui')
    targetElement.appendChild(gui.domElement)

    ## style the GUI using CSS
    #  style = document.createElement('style')
    #  style.innerHTML = "#dat_gui { border: red;}"
    #  document.head.appendChild(style)
    # --------------------------------------------------------------------------------------------------------------------

    guiWorld = gui.addFolder 'world'
    guiWorld.open()
    guiWorld.add world, 'save'
    guiWorld.add world, 'load'
    guiWorld.add world, 'clear'
    guiWorld.add world, 'generateMap'
    guiVisualizer = gui.addFolder 'visualizer'
    guiVisualizer.open()
    guiVisualizer.add(visualizer, 'running').listen()
    gui.add(settings, 'debug').listen()
    gui.add(settings, 'showRedLights').listen()
    gui.add(settings, 'triangles').listen()
    gui.add(settings, 'trafficHighlight').listen()
    guiVisualizer.add(visualizer.zoomer, 'scale', 0.1, 2).listen()
    guiVisualizer.add(visualizer, 'timeFactor', 0.1, 10).listen()
    guiWorld.add(world, 'carsNumber').min(0).max(1000).step(1).listen()
    guiWorld.add(world, 'instantSpeed').step(0.00001).listen()
    guiWorld.add(world, 'time').listen()
    guiWorld.add(world, 'activeCars').listen()
    gui.add(settings, 'lightsFlipInterval', 0, 400, 0.01).listen()
    guiSavedMaps = gui.addFolder('saved maps')
    for mapName, mapData of savedMaps
        guiSavedMaps.add(world, mapName)
#    guiSavedMaps.open()


