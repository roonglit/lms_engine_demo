module Lms
  class Content < ApplicationRecord
    has_many :category_contents, dependent: :destroy
    has_many :categories, through: :category_contents

    has_one_attached :cover
    belongs_to :contentable, polymorphic: true
    belongs_to :user
  end
end
