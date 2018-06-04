# https://www.tntware.com/donorhub/groups/developers/wiki/how-can-my-fundraising-app-use-the-donorhub-api.aspx
# PROFILES QUERY

require_dependency "api/v1_controller"

module Api
  module V1
    class DesignationProfilesController < V1Controller

      def create
        load_designation_profiles
      end

      protected

      def load_designation_profiles
        @designation_profiles ||= designation_profile_scope.all
      end

      def designation_profile_scope
        current_user.designation_profiles
      end
    end
  end
end
