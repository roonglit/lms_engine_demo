module Lms
  class Event < ApplicationRecord
    has_one :content, as: :contentable, dependent: :destroy

    accepts_nested_attributes_for :content, allow_destroy: true
    delegate :title, :subtitle, :description, :cover, to: :content, allow_nil: true
  end
end
