const {environment} = require('@rails/webpacker')
const erb = require('./loaders/erb')
const {VueLoaderPlugin} = require('vue-loader')
const vue = require('./loaders/vue')
const customConfig = require('./alias')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.config.merge(customConfig)
environment.loaders.get('file').use.find(item => item.loader === 'file-loader').options.esModule = false

environment.loaders.prepend('erb', erb)
module.exports = environment
