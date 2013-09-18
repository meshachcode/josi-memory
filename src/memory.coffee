# Description:
#   Extends brain adding search, list, and clear methods
#
# Dependencies:
#   ../class/memory.coffee
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   meshachjackson

_ = require "underscore"
Memory = require '../class/memory'

module.exports = (robot) ->

  # now that the brain is extended...
  _.extend(robot.brain, new Memory '../memories').restore()
    .done (memories) ->
      robot.brain.emit "memories-loaded", memories
    .fail (err) ->
      robot.logger.error e, "josi-memory/src/memory"