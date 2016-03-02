# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Styles
Rails.application.config.assets.precompile += %w( ie.css )
Rails.application.config.assets.precompile += %w( ie6-7.css )
Rails.application.config.assets.precompile += %w( index.css )
Rails.application.config.assets.precompile += %w( neighborhoods.css )
Rails.application.config.assets.precompile += %w( pages/community.css )
Rails.application.config.assets.precompile += %w( mobile.css )

# Scripts
Rails.application.config.assets.precompile += %w( ie6.js )
Rails.application.config.assets.precompile += %w( index.js )
Rails.application.config.assets.precompile += %w( neighborhoods.js )
Rails.application.config.assets.precompile += %w( redesign.js )
Rails.application.config.assets.precompile += %w( mobile.js )
