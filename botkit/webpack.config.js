const webpack = require('webpack')

module.exports = {
  target: 'node',
  externals: [
    'botkit'
  ],
  entry: {
    'index.js': ['babel-polyfill', './src/index.js']
  },
  output: {
    path: __dirname,
    filename: '[name]',
    libraryTarget: 'commonjs'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: ['babel-loader']
      }
    ]
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compress: {warnings: true}
    })
  ]
}
