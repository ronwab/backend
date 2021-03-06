# frozen_string_literal: true

class FertilizersController < ApplicationController
  respond_to :json

  def page
    params.fetch(:page, 1)
  end

  def per_page
    params.fetch(:page_size, 5)
  end

  def search_fertilizer
    @search_results = Fertilizer.search(search_params)

    if @search_results.present?
      respond_with(@search_results, status: 200)
    else
      render json: { "message": 'No results found Please enter another value' }, status: 404
    end
  end

  def gardens_with_fertilizer
    @search_results = Fertilizer.search(params[:search_params].downcase).gardens
    if @search_results.present?
      respond_with @search_results, status: 200
    else
      render json: { "message": 'No results found Please enter another value' }, status: 404
    end
  end

  def pagination_page_and_size
    NumericParamsChecker.perform(params['page'], params['per_page'])
    # binding.pry
    @all_fertilizers = Fertilizer.page(params['page']).per(params['per_page'])
  end

  def index
    pagination_page_and_size

    respond_with(@all_fertilizers)
  rescue NumericParamsChecker::NumericParamError => e
    handle_errors(e)
  end

  def fertilized_gardens
    # Display fertilizers based by gardens
    respond_with @fertilizer = Fertilizer.find(fertilizer_params).fertilizers
  end

  def create
    new_fertilizer = Fertilizer.create!(fertilizer_params)
    respond_with(new_fertilizer, status: :created)
  rescue ActiveRecord::RecordInvalid => e
    handle_errors(e)
  rescue ExistanceChecker::ExistanceError => e
    handle_errors(e)
  end

  def update
    fertilizer.update(fertilizer_params)
    # Look at show below
    show
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.info "Error rescued in show method  #{e.message}"
    handle_errors(e)
  end

  def show
    respond_with fertilizer
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.info "Error rescued in show method  #{e.message}"
    handle_errors(e)
  end

  def destroy
    fertilizer.destroy
    render json: { "message": "Record with id #{fertilizer_params[:id]} destroyed" }
    Rails.logger.info "Deleted record with #{fertilizer}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.info "Error rescued in Delete method #{e.message}"
    handle_errors(e)
  end

  def fertilizer
    @fertilizer ||= Fertilizer.find(params[:id])
  end

  def handle_errors(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def handle_myerror(f)
    render json: { error: f.message }, status: :unprocessable_entity
  end

  private

  def garden_id
    params[:garden_id]
  end

  # searh val is coming from client
  def search_params
    params[:search_val].downcase
  end

  def fertilizer_params
    params.permit(:id, :fertilizer_name, :date_bought, :quantity)
  end
end
