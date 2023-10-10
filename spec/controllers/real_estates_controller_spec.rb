require 'rails_helper'

RSpec.describe RealEstatesController, type: :controller do
  before(:each) do
    @real_estate1 = create(:real_estate, :apartment, :with_contents)
    @real_estate2 = create(:real_estate)
  end

  describe "GET #index" do
    it "returns a JSON response with real estates" do
      get :index 

      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)

      expect(json_response[0]["id"]).to eq(@real_estate1.id)
      expect(json_response[0]["realEstateName"]).to eq(@real_estate1.name)
      expect(json_response[0]["price"]).to eq(@real_estate1.price.to_s)
      expect(json_response[0]["realEstateCity"]).to eq(@real_estate1.city)
      expect(json_response[0]["realEstateCountry"]).to eq(@real_estate1.country)
      expect(json_response[0]["dateAdded"]).to eq(@real_estate1.date_added)
      expect(json_response[0]["realEstateType"]).to eq(@real_estate1.type_name)

      expect(json_response[1]["id"]).to eq(@real_estate2.id)
      expect(json_response[1]["realEstateType"]).to be_nil
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
        expect(json_response["realEstateName"]).to eq(@real_estate1.name)
        expect(json_response["realEstateCountry"]).to eq(@real_estate1.country)
        expect(json_response["realEstateCity"]).to eq(@real_estate1.city)

        type = @real_estate1.real_estate_type
        expect(json_response["realEstateType"]["id"]).to eq(type.id)
        expect(json_response["realEstateType"]["typeName"]).to eq(type.name)

        content1 = @real_estate1.real_estate_contents.first
        expect(json_response["content"].size).to eq(2)
        expect(json_response["content"][0]["contentId"]).to eq(content1.id)
        expect(json_response["content"][0]["contentName"]).to eq(content1.name)

      end

      it "returns a JSON response with the real estate details without content and type" do
        get :show, params: { id: @real_estate2.id }

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response["content"].size).to eq(0)
        expect(json_response["realEstateType"]).to be_nil
      end
    end

    context "when the real estate does not exist" do
      it "returns a JSON response with an error message" do
        get :show, params: { id: 999 }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(404)
        expect(json_response["error"]).to eq("Real estate not found!")
      end
    end
  end


  describe "POST #create" do
    context "when valid parameters are provided" do
      it "creates a new real estate with associated type and contents" do
        response_data = {
            price: 100000,
            realEstateName: "Estate POST",
            realEstateCountry: "Country POST",
            realEstateCity: "City POST",
            realEstateType: { id: 2, typeName: "Type A", description: "Type A Description" },
            content: [{ contentName: "Content A", quantity: 2, description: "Content A Description" }]
        }

        post :create, params: response_data

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        real_estate = RealEstate.find_by(id: json_response["id"])

        expect(real_estate.price).to eq(response_data[:price])
        expect(real_estate.name).to eq(response_data[:realEstateName])
        expect(real_estate.country).to eq(response_data[:realEstateCountry])
        expect(real_estate.city).to eq(response_data[:realEstateCity])

        expect(real_estate.type_name).to eq(response_data[:realEstateType][:typeName])
        expect(real_estate.real_estate_type.description).to eq(response_data[:realEstateType][:description])

        expect(real_estate.real_estate_contents.count).to eq(1)
        expect(real_estate.real_estate_contents.first.name).to eq(response_data[:content][0][:contentName])
      end

      it "creates a new real estate without content and type" do
        response_data = {
            price: 100000,
            realEstateName: "Estate POST 2",
            realEstateCountry: "Country POST 2",
            realEstateCity: "City POST 2",
            realEstateType: {},
            content: []
        }

        post :create, params: response_data

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        real_estate = RealEstate.find_by(id: json_response["id"])
        expect(real_estate.real_estate_contents.count).to eq(0)
        expect(real_estate.real_estate_type).to be_nil
      end
    end

    context "when invalid parameters are provided" do
      response_data = { price: 100000, realEstateCity: "City A" } 

      it "returns a JSON response with an error message" do
        post :create, params: response_data

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Creating real estate error: Validation failed: Name can't be blank, Country can't be blank")
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
          realEstateType: { id: @real_estate1.real_estate_type.id },
          content: [{ id: @real_estate1.real_estate_contents.first.id, contentName: "Content 1", quantity: 2, description: "Updated Content Description" },
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

        expect(@real_estate1.real_estate_contents.first.description).to eq(updated_params[:content][0][:description])
      end

      it "creates new content" do        
        put :update, params: updated_params 

        @real_estate1.reload
        expect(@real_estate1.real_estate_contents.last.name).to eq(updated_params[:content][1][:contentName])
      end

      it "deleted content if it is missing in response" do
        del_content_name = @real_estate1.real_estate_contents.last.name
        expect(RealEstateContent.find_by(contentName: del_content_name, real_estate_id: @real_estate1.id)).to be_present

        put :update, params: updated_params 
        @real_estate1.reload

        expect(RealEstateContent.find_by(contentName: del_content_name, real_estate_id: @real_estate1.id)).not_to be_present
      end
    end

    context "when invalid parameters are provided" do
      let(:invalid_params) { {  id: @real_estate2.id, realEstateName: nil } }

      it "returns a JSON response with an error message" do
        put :update, params: invalid_params 

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Update real estate error: Validation failed: Name can't be blank")

        expect(@real_estate2.name).not_to be_nil
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

        expect(response.body).to eq("Real estate not found!")
      end
    end
  end
end