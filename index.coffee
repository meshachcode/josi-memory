fs = require 'fs'
path = require 'path'

loadScripts = (list, robot) ->
  for dir in list
    scriptsPath = path.resolve(__dirname, dir)
    fs.exists scriptsPath, (exists) ->
      if exists
        for script in fs.readdirSync(scriptsPath)
          if scripts? and '*' not in scripts
            robot.loadFile(scriptsPath, script) if script in scripts
          else
            robot.loadFile(scriptsPath, script)

module.exports = (robot, scripts) ->
  try
    loadScripts ["src"], robot
  catch e
    robot.logger.error e
  
  