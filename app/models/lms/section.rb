module Lms
  class Section < ApplicationRecord
    belongs_to :course

    has_many :curriculum_items, dependent: :destroy
    accepts_nested_attributes_for :curriculum_items, allow_destroy: true
  end
end
