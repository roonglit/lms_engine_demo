module Lms
  class Section < ApplicationRecord
    belongs_to :course
  end
end
