module Concerns
  module Twitter
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
    end

    module InstanceMethods
      def twitter
        @twitter ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_KEY']
          config.consumer_secret     = ENV['TWITTER_SECRET']
          config.access_token        = twitter_token
          config.access_token_secret = twitter_secret
        end
      end

      def authorize_twitter!(nickname, token, secret)
        self.twitter_nickname = nickname
        self.twitter_token    = token
        self.twitter_secret   = secret
        self.save!
      end

      def remove_twitter!
        self.twitter_nickname = nil
        self.twitter_token    = nil
        self.twitter_secret   = nil
        self.save!
      end

      def twitter_linked?
        twitter_token.present? && twitter_secret.present?
      end

      def twitter_profile
        "https://twitter.com/#{twitter_nickname}" if twitter_nickname.present?
      end
    end
  end
end
