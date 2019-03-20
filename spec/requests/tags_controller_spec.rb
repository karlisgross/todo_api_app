require 'rails_helper'


RSpec.describe V1::TagsController, type: :controller do

  let(:attributes) {
    {title: "Tag"}
  }

  describe "GET #index and #show" do
    context "with valid params" do
      it "returns a success #index response" do
        tag = Tag.create! attributes
        get :index, params: {}

        expect_json_api_response(attributes, as_array: true)
      end

      it "returns a success #show response" do
        tag = Tag.create! attributes
        task = Task.create!({title: "Task", tags: [tag]})
        get :show, params: {id: tag.to_param}

        included = [{title: "Task"}]
        expect_json_api_response(attributes.except(:tasks), relationships: "tasks", included: included)
      end
    end

    context "with invalid params" do
      it "returns a 404" do
        get :show, params: {id: 9001}

        expect_json_api_error("Couldn't find Tag with 'id'=9001", code: :not_found)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Tag and returns it" do
        expect {
          post :create, params: build_json_api_request(attributes)

          expect_json_api_response(attributes, code: :created)

        }.to change(Tag, :count).by(1)
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

      it "renders a JSON response with errors on duplicate title" do
        post :create, params: build_json_api_request(attributes)
        post :create, params: build_json_api_request(attributes)

        expect_json_api_error("Validation failed: Title has already been taken", code: :unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested Tag and returns it" do
        tag = Tag.create! attributes

        attributes[:id] = tag.id
        attributes[:title] = "New title"
        put :update, params: build_json_api_request(attributes)

        tag.reload
        expect_json_api_response({title: "New title"}, id: tag.id.to_s)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        tag = Tag.create! attributes

        attributes[:id] = tag.id
        attributes[:title] = "T"
        put :update, params: build_json_api_request(attributes)

        tag.reload
        expect_json_api_error("Validation failed: Title is too short (minimum is 3 characters)", code: :unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested tag" do
      tag = Tag.create! attributes
      expect {
        delete :destroy, params: {id: tag.to_param}

        expect(response).to have_http_status(:no_content)

      }.to change(Tag, :count).by(-1)
    end
  end

end
