const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
  entry: './index.js', // Your entry point, adjust if necessary
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        use: ['file-loader'],
      },
      {
        test: /\.html$/,
        use: ['html-loader'],
      },
    ],
  },
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({ filename: 'styles.css' }),
    ...generateHtmlPlugins([
      'about',
      'faq',
      'home',
      'team',
      // Add more directories if needed
    ]),
  ],
};

function generateHtmlPlugins(pages) {
    return pages.map(page => new HtmlWebpackPlugin({
      filename: `${page}/index.html`,
      template: `./${page}/index.html`,
      chunks: ['bundle.js']
    }));
  }