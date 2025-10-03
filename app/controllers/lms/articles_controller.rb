module Lms
  class ArticlesController < ApplicationController
    before_action :set_article, only: %i[ show edit update destroy ]

    def show
    end

    def new
      @article = Article.new(content: Content.new)
    end

    def edit
    end

    def create
      @article = Article.new(article_params)

      if @article.save
        redirect_to @article, notice: "Article was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
    end

    def destroy
    end

    private
      def set_article
        @article = Article.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def article_params
        params_with_user = params.expect(article: [ 
          content_attributes: [:id, :title, :subtitle, :description, :cover, :user_id, :_destroy],
        ])
        p "<<<<<<<< DBBUG"
        p params_with_user
        params_with_user[:content_attributes][:user_id] = current_user.id
        params_with_user
      end
  end
end
