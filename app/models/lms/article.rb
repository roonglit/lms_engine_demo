module Lms
  class Article < ApplicationRecord
    has_one :content, as: :contentable, dependent: :destroy
    accepts_nested_attributes_for :content, allow_destroy: true

    delegate :title, :subtitle, :description, :cover, to: :content, allow_nil: true

    after_create :notify_article_created

    private

    def notify_article_created
      ActiveSupport::Notifications.instrument("lms.article.created", article_id: id)
    end
  end
end
