module V1
  class TasksController < ApplicationController
    before_action :set_task, only: [:show, :update, :destroy]

    # GET /tasks
    def index
      @tasks = Task.all
      render json: @tasks
    end

    # GET /tasks/1
    def show
      render json: @task, include: :tags
    end

    # POST /tasks
    def create
      @task = Task.new(task_params)
      @task.save!
      render json: @task, status: :created, include: :tags
    end

    # PATCH/PUT /tasks/1
    def update
      @task.update!(task_params)
      render json: @task, include: :tags
    end

    # DELETE /tasks/1
    def destroy
      @task.destroy
    end

    private
      def set_task
        @task = Task.includes(:tags).find(task_params[:id])
      end

      def task_params
        JsonApiRequestParams.new(params).permit(:id, :title, tags: [])
      end
  end
end

