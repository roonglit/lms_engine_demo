module Lms
  class CurriculumItem < ApplicationRecord
    belongs_to :section

    has_one_attached :video
  end
end
