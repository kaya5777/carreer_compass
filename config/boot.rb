ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Load .env with overwrite to ensure values are always applied
if File.exist?(File.expand_path("../.env", __dir__))
  require "dotenv"
  Dotenv.load(File.expand_path("../.env", __dir__), overwrite: true)
end
