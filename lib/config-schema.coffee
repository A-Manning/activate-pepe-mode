path = require 'path'

module.exports =
  frogPath:
    title: "Path to Pepes"
    description: "The path to your rare pepes"
    type: "string"
    default: ''
  opacity:
    title: 'Opacity'
    description: 'Opacity of pepes'
    type: 'number'
    default: 0.02
  timing:
    title: 'Timing (ms)'
    description: 'Pepes will fade in and out over this period'
    type: 'integer'
    default: 15000
