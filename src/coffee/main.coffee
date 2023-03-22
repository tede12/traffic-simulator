# node file for running the server and calling the app.coffee file
$ = require 'jquery'

$ ->
# create canvas and gui elements
    canvas = $('<canvas />', {id: 'canvas'})
    gui = $('<div />', {id: 'gui'})

    # add styles to the canvas and gui elements
    canvas.css
        position: 'absolute'
        top: 0
        left: 0
        width: '100%'
        height: '100%'

    gui.css
        position: 'absolute'
        top: 0
        right: 0
        width: '100%'
        height: '100%'

    # add canvas and gui elements to the body
    $(document.body).append(canvas)
    $(document.body).append(gui)

    # require the app.coffee file
    require './app'

