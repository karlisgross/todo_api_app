require "rails_helper"

RSpec.describe V1::TasksController, type: :routing do
  url = "/api/v1/tasks"

  describe "routing" do
    it "routes to #index" do
      expect(:get => url).to route_to("v1/tasks#index")
    end

    it "routes to #show" do
      expect(:get => "#{url}/1").to route_to("v1/tasks#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => url).to route_to("v1/tasks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "#{url}/1").to route_to("v1/tasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "#{url}/1").to route_to("v1/tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "#{url}/1").to route_to("v1/tasks#destroy", :id => "1")
    end
  end
end
