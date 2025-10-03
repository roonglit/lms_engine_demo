module Lms
  class Category < ApplicationRecord
    has_many :category_contents, dependent: :destroy
    has_many :contents, through: :category_contents
  end
end
