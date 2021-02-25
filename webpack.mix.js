const mix = require('laravel-mix')

mix
  .setPublicPath('public')
  .js('./resources/app.js', 'public/dist/').vue({ version: 2 })
  .sass('./resources/app.scss', 'public/dist/');