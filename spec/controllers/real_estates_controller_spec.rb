require 'rails_helper'

RSpec.describe RealEstatesController, type: :controller do
  before(:each) do
    RealEstate.delete_all
    RealEstateType.delete_all
    @real_estate_type = RealEstateType.create!(typeName: "House", description: "A residential property")
    @real_estate1 = RealEstate.create(realEstateName: "Estate 1", price: 100000, realEstateCountry: "Country 1", realEstateCity: "City 1", real_estate_type: @real_estate_type)
    @real_estate2 = RealEstate.create(realEstateName: "Estate 2", price: 200000, realEstateCountry: "Country 2", realEstateCity: "City 2")
    @real_estate_content1 = RealEstateContent.create(contentName: "Content 1", description: "Content 1 description", quantity: 2, real_estate: @real_estate1) 
    @real_estate_content2 = RealEstateContent.create(contentName: "Content 2", description: "Content 2 description", quantity: 2, real_estate: @real_estate1) 
  end

  describe "GET #index" do
    it "returns a JSON response with real estates" do
      get :index 

      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)

      expect(json_response[0]["id"]).to eq(@real_estate1.id)
      expect(json_response[0]["realEstateName"]).to eq(@real_estate1.realEstateName)
      expect(json_response[0]["price"]).to eq(@real_estate1.price.to_s)
      expect(json_response[0]["realEstateType"]).to eq(@real_estate1.realEstateType)

      expect(json_response[1]["id"]).to eq(@real_estate2.id)
      expect(json_response[1]["realEstateName"]).to eq(@real_estate2.realEstateName)
      expect(json_response[1]["price"]).to eq(@real_estate2.price.to_s)
    end
  end


  describe "GET #show" do
    context "when the real estate exists" do
      it "returns a JSON response with the real estate details" do

        get :show, params: { id: @real_estate1.id }

        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        
        expect(json_response["id"]).to eq(@real_estate1.id)
        expect(json_response["price"]).to eq(@real_estate1.price.to_s)
        expect(json_response["realEstateName"]).to eq(@real_estate1.realEstateName)
        expect(json_response["realEstateCountry"]).to eq(@real_estate1.realEstateCountry)
        expect(json_response["realEstateCity"]).to eq(@real_estate1.realEstateCity)

        expect(json_response["realEstateType"]["id"]).to eq(@real_estate1.real_estate_type.id)
        expect(json_response["realEstateType"]["typeName"]).to eq(@real_estate1.real_estate_type.typeName)
        expect(json_response["realEstateType"]["description"]).to eq(@real_estate1.real_estate_type.description)

        expect(json_response["content"].size).to eq(2)

        expect(json_response["content"][0]["contentId"]).to eq(@real_estate_content1.id)
        expect(json_response["content"][0]["contentName"]).to eq(@real_estate_content1.contentName)
        expect(json_response["content"][0]["quantity"]).to eq(@real_estate_content1.quantity)
        expect(json_response["content"][0]["description"]).to eq(@real_estate_content1.description)

      end

      it "returns a JSON response with the real estate details without content and type" do
        get :show, params: { id: @real_estate2.id }

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response["content"].size).to eq(0)
        expect(json_response["realEstateType"]).to eq(nil)
      end
    end

    context "when the real estate does not exist" do
      it "returns a JSON response with an error message" do
        get :show, params: { id: 999 }

        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Real estate not found!")
      end
    end

  end


  describe "POST #create" do
    context "when valid parameters are provided" do
      it "creates a new real estate with associated type and contents" do
        real_estate_params = {
            price: 100000,
            realEstateName: "Estate POST",
            realEstateCountry: "Country POST",
            realEstateCity: "City POST",
            yearBuilt: 2020,
            squareSize: 100,
            realEstateType: { id: 2, typeName: "Type A", description: "Type A Description" },
            content: [{ contentName: "Content 1", quantity: 2, description: "Content 1 Description" }]
          }

        post :create, params: real_estate_params 

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        created_real_estate = RealEstate.find(json_response["id"])
        expect(created_real_estate.price).to eq(real_estate_params[:price])
        expect(created_real_estate.realEstateName).to eq(real_estate_params[:realEstateName])
        expect(created_real_estate.realEstateCountry).to eq(real_estate_params[:realEstateCountry])
        expect(created_real_estate.realEstateCity).to eq(real_estate_params[:realEstateCity])
        expect(created_real_estate.yearBuilt).to eq(real_estate_params[:yearBuilt])
        expect(created_real_estate.squareSize).to eq(real_estate_params[:squareSize])
        expect(created_real_estate.real_estate_type).to be_present
        expect(created_real_estate.real_estate_type.typeName).to eq(real_estate_params[:realEstateType][:typeName])
        expect(created_real_estate.real_estate_type.description).to eq(real_estate_params[:realEstateType][:description])
        expect(created_real_estate.real_estate_contents.count).to eq(1)
        expect(created_real_estate.real_estate_contents.first.contentName).to eq(real_estate_params[:content][0][:contentName])
        expect(created_real_estate.real_estate_contents.first.quantity).to eq(real_estate_params[:content][0][:quantity])
        expect(created_real_estate.real_estate_contents.first.description).to eq(real_estate_params[:content][0][:description])
      end

      it "creates a new real estate without content and type" do
        real_estate_params =
          {
            price: 100000,
            realEstateName: "Estate POST 2",
            realEstateCountry: "Country POST 2",
            realEstateCity: "City POST 2",
            yearBuilt: 2020,
            squareSize: 100,
            realEstateType: {},
            content: []
          }

        post :create, params: real_estate_params 
      
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        
        created_real_estate = RealEstate.find(json_response["id"])
        expect(created_real_estate.real_estate_contents.count).to eq(0)
        expect(created_real_estate.real_estate_type).to be_nil
      end
    end

    context "when invalid parameters are provided" do
      let(:real_estate_params) { { realEstateName: nil } }

      it "returns a JSON response with an error message" do
        post :create, params: { real_estate: real_estate_params }

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Creating error...")
      end
    end
  end


  describe "PUT #update" do

    context "when valid parameters are provided" do

      let(:updated_params) do
        {
          id: @real_estate1.id,
          realEstateName: "Updated Estate",
          price: 100000,
          yearBuilt: 2020,
          squareSize: 100,
          realEstateCountry: "Updated Country",
          realEstateCity: "Updated City",
          realEstateType: { id: @real_estate_type.id },
          content: [{ id: @real_estate_content1.id, contentName: "Content 1", quantity: 2, description: "Updated Content Description" },
            { contentName: "New Content", quantity: 3, description: "New Content Description" }]
        }
      end

      it "updates the real estate and contents" do
        put :update, params: updated_params 

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Real estate updated successfuly!")

        @real_estate1.reload
        expect(@real_estate1.realEstateName).to eq(updated_params[:realEstateName])
        expect(@real_estate1.realEstateCountry).to eq(updated_params[:realEstateCountry])
        expect(@real_estate1.realEstateCity).to eq(updated_params[:realEstateCity])
        expect(@real_estate1.yearBuilt).to eq(updated_params[:yearBuilt])
        expect(@real_estate1.squareSize).to eq(updated_params[:squareSize])

        expect(@real_estate1.real_estate_contents.size).to eq(2)
        expect(@real_estate1.real_estate_contents.first.contentName).to eq(updated_params[:content][0][:contentName])
        expect(@real_estate1.real_estate_contents.first.quantity).to eq(updated_params[:content][0][:quantity])
        expect(@real_estate1.real_estate_contents.first.description).to eq(updated_params[:content][0][:description])
      end

      it "creates new content it is in response but not" do        
        put :update, params: updated_params 

        @real_estate1.reload
        expect(@real_estate1.real_estate_contents.last.contentName).to eq(updated_params[:content][1][:contentName])
        expect(@real_estate1.real_estate_contents.last.quantity).to eq(updated_params[:content][1][:quantity])
        expect(@real_estate1.real_estate_contents.last.description).to eq(updated_params[:content][1][:description])
      end

      it "deleted content if it missing in response" do
        expect(RealEstateContent.find_by(contentName: "Content 2", real_estate_id: @real_estate1.id)).to be_present

        put :update, params: updated_params 
        @real_estate1.reload

        expect(RealEstateContent.find_by(contentName: "Content 2", real_estate_id: @real_estate1.id)).not_to be_present
      end
    end

    context "when invalid parameters are provided" do
      let(:invalid_params) { {  id: @real_estate2.id, realEstateName: nil } }

      it "returns a JSON response with an error message" do
        put :update, params: invalid_params 

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Update error...")

        expect(@real_estate2.realEstateName).not_to be_nil
      end
    end
  end


  describe "DELETE #destroy" do

    context "when valid parameters are provided" do
      it "destroys the real estate and associated contents and returns a success message" do
        expect {
          delete :destroy, params: { id: @real_estate2.id }
        }.to change(RealEstate, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Real estate deleted!")
      end

      it "destroys the real estate and associated contents and returns a success message" do
        expect {
          delete :destroy, params: { id: @real_estate1.id }
        }.to change(RealEstate, :count).by(-1)
        .and change(RealEstateContent, :count).by(-2)

        expect(response).to have_http_status(200)
        expect(response.body).to eq("Real estate deleted!")
      end
    end

    context "when invalid parameters are provided" do
      it "returns an error message when real estate is not found" do
        delete :destroy, params: { id: 999 }

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Real estate not found!")
      end
    end
  end
end