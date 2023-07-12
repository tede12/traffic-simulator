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

    #  -----------------------------------------------------------------------------------------------------------------
    # create the GUI with custom configuration
    gui = new DAT.GUI({autoPlace: false, closeOnTop: false})
    gui.domElement.id = 'dat_gui'
    targetElement = document.getElementById('gui')
    targetElement.appendChild(gui.domElement)

    # remove class="close-button" from the GUI  -> "Close Controls"
    document.getElementsByClassName('close-button')[0].remove()

    ## style the GUI using CSS
    #  style = document.createElement('style')
    #  style.innerHTML = "#dat_gui { border: red;}"
    #  document.head.appendChild(style)
    # ------------------------------------------------------------------------------------------------------------------

    changeSetup = (setup) ->
        """
        LightFlipInterval > is more time between lights flip, < is less time between lights flip
        TimeFactor > car goes faster, < car goes slower
        """
        switch parseInt(setup)
            when 0
                # Normal
                visualizer.timeFactor = settings.defaultTimeFactor
                settings.lightsFlipInterval = 260
            when 1
                # Slow
                visualizer.timeFactor = 2
                settings.lightsFlipInterval = 170
            when 2
                # Fast
                visualizer.timeFactor = 5
                settings.lightsFlipInterval = 130
            else
                # Normal
                visualizer.timeFactor = 5
                settings.lightsFlipInterval = 260

    qs = {
        QuickSetup: 0
    }

    guiWorld = gui.addFolder 'Map'
    guiWorld.open()
    guiWorld.add world, 'save'
    guiWorld.add world, 'load'
    guiWorld.add world, 'clear'
    guiWorld.add world, 'generateMap'
    # mapSize is integer, but the slider is float (settings.mapSize)
    guiWorld.add(settings, 'mapSize', 1, 8, 1).listen().onChange (value) ->
        settings.mapSize = parseInt(value)
    guiVisualizer = gui.addFolder 'Visualizer'
    guiVisualizer.open()
    guiVisualizer.add(visualizer, 'running').listen()
    gui.add(qs, 'QuickSetup', { Normal: 0, Slow: 1, Fast: 2 }).onChange(changeSetup)
    gui.add(settings, 'debug').listen()
    gui.add(settings, 'showRedLights').listen()
    gui.add(settings, 'triangles').listen()
    gui.add(settings, 'trafficHighlight').listen()
    guiVisualizer.add(visualizer.zoomer, 'scale', settings.minZoomLevel, settings.maxZoomLevel).listen()
    guiVisualizer.add(visualizer, 'timeFactor', 0.1, 10).listen()
    guiWorld.add(world, 'carsNumber').min(0).max(1000).step(1).listen()
    guiWorld.add(world, 'instantSpeed').step(0.00001).listen()
    guiWorld.add(world, 'time').listen()
    guiWorld.add(world, 'activeCars').listen()
    gui.add(settings, 'lightsFlipInterval', 0, 400, 0.01).listen()
    guiSavedMaps = gui.addFolder('Saved maps')
    for mapName, mapData of savedMaps
        guiSavedMaps.add(world, mapName)
#    guiSavedMaps.open()


