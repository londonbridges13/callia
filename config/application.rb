require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Callia
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile += [ 'sections.css','tutorials.css','phone_numbers.css','application.css','services.css','agency_details.css','reports.css','landing.css','settings.css',
      'shifts.css','schedule.css','reminders.css','recurring_shifts.css','offices.css','contacts.css','clients.css','caregivers.css','dashboard.css','calls.css','appviews.css', 'cssanimations.css', 'dashboards.css', 'forms.css', 'gallery.css',
       'digital_signature.css','graphs.css', 'mailbox.css', 'miscellaneous.css', 'pages.css', 'tables.css', 'uielements.css', 'widgets.css', 'commerce.css' ]
    config.assets.precompile += [ 'sections.js','tutorials.js','phone_numbers.js','application.js','services.js','agency_details.js','reports.js','landing.js','settings.js',
      'shifts.js','schedule.js','reminders.js','recurring_shifts.js','offices.js','contacts.js','clients.js','caregivers.js','dashboard.js','calls.js','appviews.js', 'cssanimations.js', 'dashboards.js', 'forms.js', 'gallery.js',
       'digital_signature.js','graphs.js', 'mailbox.js', 'miscellaneous.js', 'pages.js', 'tables.js', 'uielements.js', 'widgets.js', 'commerce.js', 'metrics.js', 'landing.js' ]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.serve_static_assets = true
    # config.serve_static_files = true # same as serve_static_assets

  end
end
