module Lms
  class Course < ApplicationRecord
    has_rich_text :content
  end
end
