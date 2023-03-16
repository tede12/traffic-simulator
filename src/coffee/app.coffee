'use strict'

require './helpers'
$ = require 'jquery'
_ = require 'underscore'
Visualizer = require './visualizer/visualizer'
DAT = require 'dat-gui'
World = require './model/world'
settings = require './settings'

$ ->
# Created in the React component
#  canvas = $('<canvas />', {id: 'canvas'})
#  $(document.body).append(canvas)

# Wait for the canvas element to be added to the DOM
# Id = 'canvas'
    waitForCanvas = ->
        canvasElements = document.getElementById('canvas') && document.getElementById('gui')
        if not canvasElements
# Canvas element not found, wait and try again
            setTimeout waitForCanvas, 100
            return
    # Canvas element found, continue with code here
    waitForCanvas()

    # App code
    window.world = new World()
    world.load()
    if world.intersections.length is 0
        world.generateMap()
        world.carsNumber = 100
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
    guiVisualizer.add(visualizer, 'debug').listen()
    guiVisualizer.add(visualizer.zoomer, 'scale', 0.1, 2).listen()
    guiVisualizer.add(visualizer, 'timeFactor', 0.1, 10).listen()
    guiWorld.add(world, 'carsNumber').min(0).max(200).step(1).listen()
    guiWorld.add(world, 'instantSpeed').step(0.00001).listen()
    gui.add(settings, 'lightsFlipInterval', 0, 400, 0.01).listen()