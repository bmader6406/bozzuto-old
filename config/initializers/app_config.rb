APP_CONFIG = YAML.load_file(File.expand_path("config/app_config.yml", Rails.root))[Rails.env].symbolize_keys
