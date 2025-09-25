module Lms
  class Course < ApplicationRecord
    has_rich_text :content
    has_one_attached :cover

    has_many :sections
    accepts_nested_attributes_for :sections, allow_destroy: true
  end
end
