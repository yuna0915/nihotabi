require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Nihotabi
  class Application < Rails::Application
    config.load_defaults 6.1

    config.i18n.default_locale = :ja

    # 404や500などのエラーをルーティングで処理するための設定
    config.exceptions_app = self.routes

  end
end
