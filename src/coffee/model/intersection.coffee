'use strict'

require '../helpers'
_ = require 'underscore'
ControlSignals = require './control-signals'
Rect = require '../geom/rect'
uniqueId = require '../helpers'

class Intersection
    constructor: (@rect) ->
        @id = uniqueId 'intersection' # @id = _.uniqueId 'intersection'
        @roads = []
        @inRoads = []
        @controlSignals = new ControlSignals this

    @copy: (intersection) ->
        intersection.rect = Rect.copy intersection.rect
        result = Object.create Intersection::
        _.extend result, intersection
        result.roads = []
        result.inRoads = []
        result.controlSignals = ControlSignals.copy result.controlSignals, result
        result

    toJSON: ->
        obj =
            id: @id
            rect: @rect
            controlSignals: @controlSignals
            roads: @roads
            inRoads: @inRoads

    update: ->
        road.update() for road in @roads
        road.update() for road in @inRoads

module.exports = Intersection
