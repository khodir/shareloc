const mix = require('laravel-mix')

mix
  .setPublicPath('public')
  .js('./resources/app.js', 'public/dist/')
  .sass('./resources/app.scss', 'public/dist/');