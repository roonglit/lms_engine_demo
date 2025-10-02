module Lms
  class Video < ApplicationRecord
    has_one_attached :video
    has_one :content, as: :contentable, dependent: :destroy

    accepts_nested_attributes_for :content, allow_destroy: true
  end
end
