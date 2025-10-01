module Lms
  class Course < ApplicationRecord
    has_one :content, as: :contentable, dependent: :destroy

    has_rich_text :text_content
    has_one_attached :cover

    has_many :sections, dependent: :destroy
    accepts_nested_attributes_for :sections, allow_destroy: true
    accepts_nested_attributes_for :content, allow_destroy: true

    delegate :title, :subtitle, :description, to: :content, allow_nil: true
  end
end
