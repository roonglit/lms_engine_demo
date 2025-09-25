module Lms
  class Section < ApplicationRecord
    belongs_to :course

    has_many :curriculum_items 
  end
end
