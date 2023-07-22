require 'rails_helper'

RSpec.describe RealEstateTypesController, type: :controller do
  before(:each) do
    RealEstateType.delete_all
    @real_estate_type1 = RealEstateType.create!(typeName: "Type A", description: "Type A description")
  end

  describe "GET #index" do
    it "returns a success response with all real estate types" do
      get :index

      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)
      expect(json_response[0]["typeName"]).to eq(@real_estate_type1.typeName)
      expect(json_response[0]["description"]).to eq(@real_estate_type1.description)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new real estate type" do
        expect {
          post :create, params: { real_estate_type: { typeName: "Apartment", description: "Residential unit" } } 
        }.to change(RealEstateType, :count).by(1)

        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        expect(json_response["typeName"]).to eq("Apartment")
        expect(json_response["description"]).to eq("Residential unit")
      end
    end

    context "with invalid parameters" do
      it "returns an error response" do
        post :create, params: { real_estate_type: { typeName: "Type A" } }
        
        expect(JSON.parse(response.body)["error"]).to eq("Creating error...")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when valid parameters are provided" do
      it "destroys the real estate type and returns a success message" do
        expect {
          delete :destroy, params: { id: @real_estate_type1.id }
        }.to change(RealEstateType, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Real estate type deleted!")
      end
    end

    context "when invalid parameters are provided" do
      it "returns an error message when real estate type is not found" do
        delete :destroy, params: { id: 999 }

        expect(JSON.parse(response.body)["error"]).to eq("Real estate type not found!")
      end
    end
  end


  describe "PUT #update" do

    context "with valid parameters" do
      it "updates the real estate type and returns a success response" do
        put :update, params: { id: @real_estate_type1.id, real_estate_type: { typeName: "New Type", description: "Updated description" } }

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Real estate type updated successfully!")

        @real_estate_type1.reload
        expect(@real_estate_type1.typeName).to eq("New Type")
        expect(@real_estate_type1.description).to eq("Updated description")
      end
    end

    context "with invalid parameters" do
      it "returns an error response" do
        put :update, params: { id: @real_estate_type1.id, real_estate_type: { typeName: "" } }

        expect(JSON.parse(response.body)["error"]).to eq("Update error...")

        @real_estate_type1.reload
        expect(@real_estate_type1.typeName).not_to eq("")
      end
    end
  end
  
end

