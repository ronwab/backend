# frozen_string_literal: true

class GardenActivitiesController < ApplicationController
  respond_to :json

  def search
    # binding.pry


    respond_with json: { message: "SEARCH" , status: 200 }
  end
  def index
    respond_with GardenActivity.all
  rescue ActiveRecord::RecordNotFound => e
    handle_errors(e)
  end

  def show
    respond_with(my_garden_activity, status: 200)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.info "Error rescued in show method #{e.message}"
    render json: { error: e.message }, status: :not_found
  end

  def create
    new_garden_activity = GardenActivity.create!(garden_activities_params)
    respond_with new_garden_activity
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.info "Error rescued in create method #{e.message}"
    handle_errors(e)
  end

  def destroy
    my_garden_activity.destroy
    respond_with json: { message: ' Record is destroyed' }
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.info "Error rescued in destroy method #{e.message}"
    handle_errors(e)
  end

  def handle_errors(e)
    render json: { error: e.message }, status: :unprocessable_entry
  end

  private

  def activity_search
    activity || GardenActivity.find_by()
  end

  def activity_search_params
    params.permit(:activity )
  end

  def garden_activity_present?
    my_garden_activity.present?
  end

  def my_garden_activity
    @my_garden_activity ||= GardenActivity.find(params[:id])
  end

  def garden_activities_params
    params.permit(:garden_id, :date_performed, :time, :activity, :weather, :notes, :activity, :time)
  end
end
