unless Rails.root.join('config','keys.yml').exist?
  raise "Could not find config/keys.yml see config/keys.yml.sample for details"
end
KEYS = YAML.load_file Rails.root.join('config','keys.yml')