path = require 'path'

module.exports =
  pepePath:
    title: "Path to Pepes"
    description: "The path to your rare pepes"
    type: "string"
    default: path.join(__dirname, '../pepes/').replace(/\\/g, '/')
