var path = require('path');
var MiniCssExtractPlugin = require('mini-css-extract-plugin');

// Build modes
const production = 'production';
const development = 'development';

const cssRule = function (mode) {
    return {
        test: /\.s[ac]ss$/i,
        use: [
            mode == development
                ? { loader: 'style-loader' }
                : {
                    loader: MiniCssExtractPlugin.loader,
                    options: {
                        publicPath: '/',
                    },
                },
            {
                loader: 'css-loader',
                options: { importLoaders: 1 }
            },
            { 
                loader: 'sass-loader',
                options: { implementation: require('sass') }
            },
        ],
    };
};


module.exports = (env, argv) => {
    console.log('argv.mode', argv.mode);

    return {
        mode: argv.mode == production ? 'production' : 'development',
        entry: {
            app: [
                './src/index.js'
            ]
        },

        output: {
            path: path.resolve(__dirname + '/dist'),
            filename: '[name].js',
        },

        module: {
            rules: [
                cssRule(argv.mode),
                {
                    test: /\.html$/,
                    exclude: /node_modules/,
                    loader: 'file-loader?name=[name].[ext]',
                },
                {
                    test: /\.elm$/,
                    exclude: [/elm-stuff/, /node_modules/],
                    loader: 'elm-webpack-loader?verbose=true&debug=true',
                },
            ],
            noParse: /\.elm$/,
        },
        plugins: [
            new MiniCssExtractPlugin({
                filename: `css/[name]${argv.mode == development ? `` : `.[hash]`}.css`,
                chunkFilename: `css/[id]${argv.mode == development ? `` : `.[hash]`}.css`
            }),
        ],
        devServer: {
            inline: true,
            stats: {
                colors: true,
                // errors: false // hide webpack errors
            },
            historyApiFallback: {
                index: 'index.html'
            }
        },
    }
};