const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CopyWebpackPlugin = require ('copy-webpack-plugin')

const pages = [
  {
    input: {
      template: 'html/index.ejs',
      entryScript: 'index',
    },

    options: {
      title: 'App'
    },

    output: {
      html: 'index.html',
      bundle: 'elm/index'
    }
  }
]

const config = {
  entry: {},
  output: {},

  plugins: [
    new CopyWebpackPlugin([{
      from: 'public', to: 'build', ignore: 'index.html'
    }])
  ],

  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/,
  },

  devServer: {
    contentBase: './public',
    historyApiFallback: true,
    inline: true,
    stats: {
      colors: true
    }
  }
}

const generateConfig = (baseConfig, pagesToAdd) => {
  baseConfig.entry = pagesToAdd.reduce(
    (accumulator, page) => (Object.assign(accumulator, {
      [page.output.bundle]: './src/' + page.input.entryScript,
    })),
    {}
  )

  baseConfig.output = {
    path: path.resolve('./build/'),
    filename: '[name].js'
  }

  baseConfig.plugins = baseConfig.plugins.concat(pagesToAdd.map(page => (
    new HtmlWebpackPlugin({
      title: page.options.title,
      filename: page.output.html,
      template: 'src/' + page.input.template,
      chunks: [page.output.bundle]
    })
  )))

  return baseConfig
}

module.exports = generateConfig(config, pages)
