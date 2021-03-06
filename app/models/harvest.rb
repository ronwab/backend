# frozen_string_literal: true

class Harvest < ApplicationRecord
  belongs_to :garden

  validates :date, :quantity, :harvest_number, presence: true
end
