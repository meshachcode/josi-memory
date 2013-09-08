# Description:
#
# Dependencies:
#   ./responder.coffee
#   ./eardropping.coffee
#
# Configuration:
#   None
#
# Commands:
#   hubot when i say <key> you (say|do) <command> - Command Aliases!
# Notes:
#
# Author:
# Jolly Science

TextMessage = require('hubot').TextMessage

class Learn

  constructor: (@robot) ->
    # listen to all direct messages...
    @robot.respond /(.+)/i, (msg) ->
      robotHeard = msg.match[1]
      # check for all of the ones i know...
      for task in @robot.earDropping.all()
        if new RegExp(task.key, "i").test(robotHeard)
          # pretend i really heard something else...
          @robot.receive new TextMessage(msg.message.user, "#{@robot.name}: #{task.task}")

  say: (pattern, response) ->
    callback = "msg.send('#{response}')"
    responder = @robot.responders.add pattern, callback

# leverage earDropping for actionable patterns...
  do: (pattern, response) ->
    @robot.earDropping.add(pattern, response)

module.exports = (robot) ->

  robot.learn = new Learn robot

# Report all Josi Modules
  robot.respond /persona/i, (msg) ->
    msg.send "JoSi Memory - Loaded"

# Teachable...
  robot.respond /when i say (.+?) you (say|do) (.+?)$/i, (msg) ->
    # The coolest line of code I've ever written...
    learnt = robot.learn[msg.match[2]] msg.match[1], msg.match[3]
    if learnt
      msg.send "I'll start responding to /#{msg.match[1]}/."
    else
      msg.send "I'd like to respond to /#{msg.match[1]}/ but something went wrong."
      console.log learnt

# Testable...
  robot.respond /(say|repeat|echo|parrot) "(.+?)"$/i, (msg) ->
    msg.send "/me is clearing her throat..."
    msg.send "/quote #{msg.match[2]}"