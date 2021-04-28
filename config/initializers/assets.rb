# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( home.css )
Rails.application.config.assets.precompile += %w( imprimir.css )
Rails.application.config.assets.precompile += %w( home.js )
Rails.application.config.assets.precompile += %w( *.gif )
Rails.application.config.assets.precompile += %w( icheck/square/blue.png )
Rails.application.config.assets.precompile += %w( icheck/square/blue@2x.png )
Rails.application.config.assets.precompile += %w( icheck/futurico/futurico.png )
Rails.application.config.assets.precompile += %w( icheck/futurico/futurico@2x.png )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( lightbox/* )