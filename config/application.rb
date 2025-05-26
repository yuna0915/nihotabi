require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Nihotabi
  class Application < Rails::Application
    config.load_defaults 6.1

    config.i18n.default_locale = :ja

    # タイムゾーンを東京に設定（日本時間）
    config.time_zone = 'Tokyo'
    # DBから読み込んだ日時をローカルタイム（Tokyo）として扱う
    config.active_record.default_timezone = :local

    # 404や500などのエラーをルーティングで処理するための設定
    config.exceptions_app = self.routes
  end
end
