module Lms
  class CategoryContent < ApplicationRecord
    belongs_to :category
    belongs_to :content
  end
end
