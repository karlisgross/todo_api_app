require 'rails_helper'


RSpec.describe V1::TasksController, type: :controller do

  let(:attributes) {
    {title: "Task", tags: ["Tag1", "Tag2"]}
  }

  describe "GET #index and #show" do
    context "with valid params" do
      it "returns a success #index response" do
        task = Task.create! attributes
        get :index, params: {}

        expect_json_api_response(attributes.except(:tags), relationships: "tags", as_array: true)
      end

      it "returns a success #show response" do
        task = Task.create! attributes
        get :show, params: {id: task.to_param}

        expect_json_api_response(attributes.except(:tags), relationships: "tags")
      end
    end

    context "with invalid params" do
      it "returns a 404" do
        get :show, params: {id: 9001}

        expect_json_api_error("Couldn't find Task with 'id'=9001", code: :not_found)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task and returns it" do
        expect {
          post :create, params: build_json_api_request(attributes)

          included = [{title: "Tag1"}, {title: "Tag2"}]
          expect_json_api_response(attributes.except(:tags), relationships: "tags", code: :created, included: included)

        }.to change(Task, :count).by(1)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors on no title" do
        attributes[:title] = nil
        post :create, params: build_json_api_request(attributes)

        expect_json_api_error("Validation failed: Title can't be blank, Title is too short (minimum is 3 characters)", code: :unprocessable_entity)
      end

      it "renders a JSON response with errors on short title" do
        attributes[:title] = "Ti"
        post :create, params: build_json_api_request(attributes)

        expect_json_api_error("Validation failed: Title is too short (minimum is 3 characters)", code: :unprocessable_entity)
      end

      it "fails the entire transaction when one part can't be done" do
        expect {
          attributes[:tags][1] = "Ta"
          post :create, params: build_json_api_request(attributes)

          expect_json_api_error("Validation failed: Tags title is too short (minimum is 3 characters)", code: :unprocessable_entity)

        }.to change(Task, :count).by(0).and change(Tag, :count).by(0)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested Task and returns it" do
        task = Task.create! attributes

        attributes[:id] = task.id
        attributes[:title] = "New title"
        put :update, params: build_json_api_request(attributes)

        task.reload
        included = [{title: "Tag1"}, {title: "Tag2"}]
        expect_json_api_response({title: "New title"}, relationships: "tags", included: included, id: task.id.to_s)

      end

      it "updates sub-Tags and returns them in the right order" do
        task = Task.create! attributes

        attributes[:id] = task.id
        attributes[:tags][0] = "Updated"
        put :update, params: build_json_api_request(attributes)

        task.reload
        included = [{title: "Tag2"}, {title: "Updated"}]
        expect_json_api_response(attributes.except(:tags), relationships: "tags", included: included, id: task.id.to_s)

      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        task = Task.create! attributes

        attributes[:id] = task.id
        attributes[:title] = "T"
        put :update, params: build_json_api_request(attributes)

        task.reload
        expect_json_api_error("Validation failed: Title is too short (minimum is 3 characters)", code: :unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = Task.create! attributes
      expect {
        delete :destroy, params: {id: task.to_param}

        expect(response).to have_http_status(:no_content)

      }.to change(Task, :count).by(-1)
    end
  end

end
