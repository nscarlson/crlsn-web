var path = require('path');

module.exports = {
  entry: "./app/main.jsx",
  output: {
    filename: "./public/bundle.js",
    path: ".",
    publicPath: "./public"
  },
  devtool: 'source-map',
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel',
        query: {
          presets: ['react', 'es2015']
        }
      }
    ]
  },
  resolve: {
    modulesDirectories: ['node_modules']
  }
}
