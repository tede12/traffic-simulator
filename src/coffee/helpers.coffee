'use strict'
#_ = require 'underscore'
#id = _.uniqueId 'car'      # old code

#module.exports = {}

Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc


# Generate a unique integer id (unique within the entire client session).
# Useful for temporary DOM ids.
idCounter = {};
uniqueId = (prefix) ->
    id = ++idCounter[prefix] || (idCounter[prefix] = 1);
    return prefix + id;

module.exports = uniqueId