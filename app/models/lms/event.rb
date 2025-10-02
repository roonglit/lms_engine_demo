module Lms
  class Event < ApplicationRecord
    has_one :content, as: :contentable, dependent: :destroy

    accepts_nested_attributes_for :content, allow_destroy: true
  end
end
