'use strict'
#_ = require 'underscore'
#id = _.uniqueId 'car'      # old code

#module.exports = {}
mapsIdCounter = require './mapsIdCounter'
Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc


# Generate a unique integer id (unique within the entire client session).
# Useful for temporary DOM ids.
uniqueId = (prefix) ->
    id = ++mapsIdCounter[prefix] || (mapsIdCounter[prefix] = 1);
    return prefix + id;

#for key, value of mapsIdCounter
#    mapsIdCounter[key] = 0

module.exports = uniqueId