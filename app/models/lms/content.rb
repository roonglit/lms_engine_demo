module Lms
  class Content < ApplicationRecord
    has_one_attached :cover
    belongs_to :contentable, polymorphic: true
    belongs_to :user
  end
end
