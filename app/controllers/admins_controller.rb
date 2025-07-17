class AdminsController < ApplicationController
    before_action :authenticate_user!


  def home

  end

  def import_teachers_form
    @teachers = current_user.school.teachers
  end

  def import_teachers
    if params[:file].blank?
      redirect_to admins_import_teachers_path, alert: "Please upload a CSV file."
      return
    end

    result = ::Importers::TeacherImporter.new(file: params[:file], school: current_user.school).import

    if result[:failed].zero?
      redirect_to admin_home_path, notice: "#{result[:success]} teachers imported successfully."
    else
      error_msgs = result[:errors].map { |e| e[:messages].join(", ") }.join(" | ")
      redirect_to admins_import_teachers_path, alert: "#{result[:success]} imported, #{result[:failed]} failed. Errors: #{error_msgs}"
    end
  end

  def import_students_form
    @students = current_user.school.students
  end

  def import_students
    if params[:file].blank?
      redirect_to admins_import_students_path, alert: "Please upload a CSV file."
      return
    end

    result = ::Importers::StudentImporter.new(file: params[:file], school: current_user.school).import

    if result[:failed].zero?
      redirect_to admin_home_path, notice: "#{result[:success]} students imported successfully."
    else
      error_msgs = result[:errors].map { |e| e[:messages].join(", ") }.join(" | ")
      redirect_to admins_import_students_path, alert: "#{result[:success]} imported, #{result[:failed]} failed. Errors: #{error_msgs}"
    end
  end
end