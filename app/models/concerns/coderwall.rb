module Concerns
  module Coderwall
    extend ActiveSupport::Concern

    included do
      include InstanceMethods
    end

    module InstanceMethods

      def coderwall_username
        coderwall_user_name || nickname
      end

      def change_coderwall_username!(username)
        update_attributes!(coderwall_user_name: username)
      end

      def award_coderwall_badges
        return unless coderwall.configured?

        if pull_requests.year(CURRENT_YEAR).any?
          coderwall.award_badge(coderwall_username, ::Coderwall::PARTICIPANT)
        end

        if pull_requests.year(CURRENT_YEAR).length > 23
          coderwall.award_badge(coderwall_username, ::Coderwall::CONTINUOUS)
        end
      end

      private

      def coderwall
        @coderwall ||= Coderwall.new
      end
    end
  end
end

