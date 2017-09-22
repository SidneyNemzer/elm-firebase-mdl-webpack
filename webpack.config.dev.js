const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

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

// This is the base config, you probably don't need to modify it
const config = {
  entry: {},
  output: {},

  plugins: [],

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
    contentBase: './build',
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

  baseConfig.plugins = pagesToAdd.map(page => (
    new HtmlWebpackPlugin({
      title: page.options.title,
      filename: page.output.html,
      template: 'src/' + page.input.template,
      chunks: [page.output.bundle]
    })
  ))

  return baseConfig
}

module.exports = generateConfig(config, pages);

/* This is a backup config, you can use this if the config generation fails
module.exports = {
  entry: {
    'elm/index': [
      './src/index.js'
    ]
  },
  output: {
    path: path.resolve('./build/'),
    filename: '[name].js'
  },

  plugins: [
    new HtmlWebpackPlugin({
      title: 'Home',
      template: 'src/html/index.ejs'
    })
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

  // Setup webpack-dev-server
  devServer: {
    contentBase: './build',
    inline: true,
    stats: {
      colors: true
    }
  }
}
*/
