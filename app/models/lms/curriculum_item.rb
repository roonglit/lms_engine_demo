module Lms
  class CurriculumItem < ApplicationRecord
    belongs_to :section
  end
end
