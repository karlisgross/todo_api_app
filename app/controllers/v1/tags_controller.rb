module V1
  class TagsController < ApplicationController

    before_action :set_tag, only: [:show, :update, :destroy]

    # GET /tags
    def index
      @tags = Tag.all

      render json: @tags
    end

    # GET /tags/1
    def show
      render json: @tag, include: :tasks
    end

    # POST /tags
    def create
      @tag = Tag.new(tag_params)
      @tag.save!
      render json: @tag, status: :created
    end

    # PATCH/PUT /tags/1
    def update
      @tag.update!(tag_params)
      render json: @tag
    end

    # DELETE /tags/1
    def destroy
      @tag.destroy
    end

    private
    def set_tag
      @tag = Tag.includes(:tasks).find(tag_params[:id])
    end

    def tag_params
      JsonApiRequestParams.new(params).permit(:id, :title)
    end
  end
end




