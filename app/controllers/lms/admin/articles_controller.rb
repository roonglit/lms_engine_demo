module Lms
  module Admin
    class ArticlesController < BaseController
      before_action :set_article, only: %i[ show edit update destroy ]

      # GET /admin/articles
      def index
        @articles = Article.all
      end

      # GET /admin/articles/1
      def show
      end

      # GET /admin/articles/new
      def new
        @article = Article.new(content: Content.new)
      end

      # GET /admin/articles/1/edit
      def edit
      end

      # POST /admin/articles
      def create 
        @article = Article.new(article_params)

        if @article.save
          redirect_to @article, notice: "Article was successfully created."
        else
          Rails.logger.debug "Article errors: #{@Article.errors.full_messages}"
          render :new, status: :unprocessable_content
        end
      end

      # PATCH/PUT /admin/articles/1
      def update
        Rails.logger.debug "Raw params: #{params.inspect}"
        Rails.logger.debug "Course params: #{article_params.inspect}"
        
        if @Article.update(article_params)
          redirect_to @article, notice: "Course was successfully updated.", status: :see_other
        else
          Rails.logger.debug "Course errors: #{@Article.errors.full_messages}"
          render :edit, status: :unprocessable_content
        end
      end

      # DELETE /admin/articles/1
      def destroy
        @Article.destroy!
        redirect_to articles_path, notice: "Course was successfully destroyed.", status: :see_other
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_article
          @article = Article.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def article_params
          params_with_user = params.expect(article: [
            content_attributes: [:id, :title, :subtitle, :description, :cover, :user_id, :_destroy],
          ])
          params_with_user[:content_attributes][:user_id] = current_user.id
          params_with_user
        end
    end
  end
end
