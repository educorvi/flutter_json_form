# Generate rita bundle

To generate the rita bundle, clone the rita repository, change to the rita-core directory and change the webpack config to:

```js
const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');
const webpack = require('webpack');
const fs = require('fs');

const pjson = JSON.parse(fs.readFileSync('package.json'));

module.exports = {
    entry: './src/index.ts',
    output: {
        path: __dirname + '/dist',
        filename: 'bundle.quickjs.js',
        library: 'rita',
        libraryTarget: 'umd',
        globalObject: 'globalThis',
    },
    target: 'web', // <--- IMPORTANT
    resolve: {
        extensions: ['.ts', '.js'],
    },
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
        ],
    },
    optimization: {
        minimize: true,
        minimizer: [new TerserPlugin()],
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env.VERSION': JSON.stringify(pjson.version),
        }),
    ],
    mode: 'production',
};
```

Then run:

```bash
npx webpack --config webpack.config.js
```

Then put the compiled java script bundle in the `assets/js` folder and the `RitaRuleEvaluator` can use the bundled JavaScript file with the `flutteR_js` package (which internally uses `quickjs`).