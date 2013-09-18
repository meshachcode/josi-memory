fs   = require 'fs'
path = require 'path'
_ = require "underscore"
RSVP = require './promises'

# The Memory Class...
class Memory

  constructor: (@dir) ->
    @data = @data or {}
    @data._private = @data._private or {}
    @

  # return the full list
  list: () ->
    @data._private

  # a "safe" delete for all private data
  clear: () ->
    @data._private = {}
    @

  # Load Memories
  restore: () ->
    p = new RSVP.Promise()
    # load a bunch of promises...
    promises = []
    # setup the path
    brainPath = path.resolve(__dirname, @dir)
    try
      self = @
      # if the directory is real
      fs.exists brainPath, (exists) ->
        if exists
          # loop through the files in the path
          for memory in fs.readdirSync(brainPath)
            # make sure it's a json file
            if /.json/.test(memory)
              # Use the name of the file as the namespace...
              namespace = memory.replace /.json/, ''
              # store the returned promise that @upload
              u = self.upload "#{brainPath}/#{memory}", namespace, self
              # add the promise to the promises array
              promises.push u

          # listen for the list of promises
          RSVP.all(promises).then (data) ->
            p.resolve self.list()
        else
          throw { msg: "The path is not real.", path: brainPath }
    catch e
      p.reject { error: e, msg: "Trying to load memories." }
    # return the promise
    return p

  # upload a JSON file to the brain
  upload: (filePath, namespace, self) ->
    # create a new promise
    u = new RSVP.Promise()
    try
      # read the file
      data = fs.readFileSync filePath, 'utf-8'
      if data
        try
          self.set(namespace, JSON.parse data)
          if self.get(namespace)
            u.resolve self.get(namespace)
        catch e
          throw e
      else
        throw e
    catch e
      # reject the promise with the error
      u.reject { error: e, msg: "Trying to load a json file" }
    u

module.exports = Memory