class SuperAdminsController < ApplicationController
    before_action :authenticate_user!

    def home
        @schools = School.all
    end
end
