require ::File.expand_path('../config/environment', __FILE__)

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :delete, :put, :patch, :options, :head]
  end
end

run Rails.application
