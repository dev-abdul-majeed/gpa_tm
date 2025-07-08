class TeachersController < ApplicationController
    before_action :authenticate_user!

    def home

    end

    private

    def ensure_teacher!
        redirect_to root_path, alert: "Access denied" unless current_user.is_a?(Teacher)
    end

end