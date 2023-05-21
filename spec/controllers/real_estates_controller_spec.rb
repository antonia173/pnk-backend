require 'rails_helper'

RSpec.describe RealEstatesController, type: :controller do
  describe "GET #index" do
    it "returns a JSON response with real estates" do
      real_estate_type = RealEstateType.create(typeName: "House", description: "A residential property")
      real_estate1 = RealEstate.create(realEstateName: "Estate 1", price: 100000, real_estate_type: real_estate_type)
      real_estate2 = RealEstate.create(realEstateName: "Estate 2", price: 200000)

      get :index

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json_response = JSON.parse(response.body)
      expect(json_response["content"].size).to eq(2)

      expect(json_response[0]["id"]).to eq(real_estate1.id)
      expect(json_response[0]["realEstateName"]).to eq("Estate 1")
      expect(json_response[0]["price"]).to eq(100000)
      expect(json_response[0]["realEstateType"]).to eq("House")

      expect(json_response[1]["id"]).to eq(real_estate2.id)
      expect(json_response[1]["realEstateName"]).to eq("Estate 2")
      expect(json_response[1]["price"]).to eq(200000)
    end
  end

  describe "GET #show" do
    context "when the real estate exists" do
      real_estate_type = RealEstateType.create(typeName: "House", description: "A residential property")
      real_estate = RealEstate.create(realEstateName: "Estate 1", price: 100000, real_estate_type: real_estate_type)
      real_estate_content1 = RealEstateContent.create(contentName: "Kupaonice", description: "Broj kupaonica u objektu.", quantity: 2, real_estate_id: real_estate.id) 
      real_estate_content2 = RealEstateContent.create(contentName: "Kuhinje", description: "Broj kuhinja u objektu.", quantity: 1, real_estate_id: real_estate.id) 

      it "returns a JSON response with the real estate details" do
        get :show, params: { id: real_estate.id }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)

        expect(json_response["id"]).to eq(real_estate.id)
        expect(json_response["price"]).to eq(real_estate.price)
        expect(json_response["realEstateName"]).to eq(real_estate.realEstateName)
        expect(json_response["realEstateCountry"]).to eq(real_estate.realEstateCountry)
        expect(json_response["realEstateCity"]).to eq(real_estate.realEstateCity)

        expect(json_response["realEstateType"]["id"]).to eq(real_estate_type.id)
        expect(json_response["realEstateType"]["typeName"]).to eq(real_estate_type.typeName)
        expect(json_response["realEstateType"]["description"]).to eq(real_estate_type.description)

        expect(json_response["content"].size).to eq(2)

        expect(json_response["content"][0]["contentId"]).to eq(real_estate_content1.id)
        expect(json_response["content"][0]["contentName"]).to eq(real_estate_content1.contentName)
        expect(json_response["content"][0]["quantity"]).to eq(real_estate_content1.quantity)
        expect(json_response["content"][0]["description"]).to eq(real_estate_content1.description)

        expect(json_response["content"][1]["contentId"]).to eq(real_estate_content2.id)
        expect(json_response["content"][1]["contentName"]).to eq(real_estate_content2.contentName)
        expect(json_response["content"][1]["quantity"]).to eq(real_estate_content2.quantity)
        expect(json_response["content"][1]["description"]).to eq(real_estate_content2.description)
      end
    end

    context "when the real estate does not exist" do
      it "returns a JSON response with an error message" do
        get :show, params: { id: 999 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Real estate not found!")
      end
    end

    context "when the real estate content and real estate type is empty" do
      real_estate = RealEstate.create(realEstateName: "Estate 1", price: 100000)

      it "returns a JSON response with the real estate details without content and type" do
        get :show, params: { id: real_estate.id }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        expect(json_response["content"].size).to eq(0)
        expect(json_response["realEstateType"]).to eq(nil)
      end
    end
  end


  describe "POST #create" do
    context "when valid parameters are provided" do
      let(:type_params) { { typeName: "Type A", description: "Type A Description" } }
      let(:content_params) { [{ contentName: "Content 1", quantity: 2, description: "Content 1 Description" }] }
      let(:real_estate_params) do
        {
          price: 100000,
          realEstateName: "Estate 1",
          realEstateCountry: "Country",
          realEstateCity: "City",
          yearBuilt: 2020,
          squareSize: 100,
          realEstateType: type_params,
          content: content_params
        }
      end

      it "creates a new real estate with associated type and contents" do
        post :create, params: { real_estate: real_estate_params }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")

        json_response = JSON.parse(response.body)

        expect(json_response).to include("id", "price", "realEstateName", "realEstateCountry", "realEstateCity", "yearBuilt", "squareSize")
        expect(json_response["realEstateType"]).to include("id", "typeName", "description")
        expect(json_response["content"]).to be_an(Array)
        expect(json_response["content"].size).to eq(1)

        created_real_estate = RealEstate.find(json_response["id"])
        expect(created_real_estate.price).to eq(real_estate_params[:price])
        expect(created_real_estate.realEstateName).to eq(real_estate_params[:realEstateName])
        expect(created_real_estate.realEstateCountry).to eq(real_estate_params[:realEstateCountry])
        expect(created_real_estate.realEstateCity).to eq(real_estate_params[:realEstateCity])
        expect(created_real_estate.yearBuilt).to eq(real_estate_params[:yearBuilt])
        expect(created_real_estate.squareSize).to eq(real_estate_params[:squareSize])
        expect(created_real_estate.real_estate_type).to be_present
        expect(created_real_estate.real_estate_type.typeName).to eq(type_params[:typeName])
        expect(created_real_estate.real_estate_type.description).to eq(type_params[:description])
        expect(created_real_estate.real_estate_contents.count).to eq(1)
        expect(created_real_estate.real_estate_contents.first.contentName).to eq(content_params[0][:contentName])
        expect(created_real_estate.real_estate_contents.first.quantity).to eq(content_params[0][:quantity])
        expect(created_real_estate.real_estate_contents.first.description).to eq(content_params[0][:description])
      end
    end

    context "when content is empty and type not present" do
      let(:real_estate_params) do
        {
          price: 100000,
          realEstateName: "Estate 1",
          realEstateCountry: "Country",
          realEstateCity: "City",
          yearBuilt: 2020,
          squareSize: 100,
          realEstateType: {},
          content: []
        }
      end

      it "creates real estate without content and type" do
        post :create, params: { real_estate: real_estate_params }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")

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

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Creating error...")
      end
    end
  end


  describe "PUT #update" do
    real_estate_type = RealEstateType.create( typeName: "House", description: "A residential property")
    real_estate = RealEstate.create(realEstateName: "Estate 1", price: 100000, realEstateCountry: "Country", realEstateCity: "City")
    real_estate_content1 = RealEstateContent.create(contentName: "Kupaonice", description: "Broj kupaonica u objektu.", quantity: 2, real_estate: real_estate) 

    context "when valid parameters are provided" do
      let(:type_params) { { id: real_estate_type.id } }
      let(:content_params) { [{ id: real_estate_content1.id, contentName: "New Content", quantity: 2, description: "New Content Description" }] }
      let(:updated_real_estate_params) do
        {
          id: real_estate.id,
          price: 150000,
          realEstateName: "Updated Estate",
          realEstateCountry: "Updated Country",
          realEstateCity: "Updated City",
          yearBuilt: 2022,
          squareSize: 120,
          realEstateType: type_params,
          content: content_params
        }
      end

      it "updates the real estate, type, and contents" do
        put :update, params: updated_real_estate_params 

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response).to eq("Real estate updated successfuly!")

        real_estate.reload
        expect(real_estate.price).to eq(updated_real_estate_params[:price])
        expect(real_estate.realEstateName).to eq(updated_real_estate_params[:realEstateName])
        expect(real_estate.realEstateCountry).to eq(updated_real_estate_params[:realEstateCountry])
        expect(real_estate.realEstateCity).to eq(updated_real_estate_params[:realEstateCity])
        expect(real_estate.yearBuilt).to eq(updated_real_estate_params[:yearBuilt])
        expect(real_estate.squareSize).to eq(updated_real_estate_params[:squareSize])
        expect(real_estate.real_estate_type).to eq(real_estate_type)

        expect(real_estate.real_estate_contents.count).to eq(1)
        expect(real_estate.real_estate_contents.first.contentName).to eq(content_params[0][:contentName])
        expect(real_estate.real_estate_contents.first.quantity).to eq(content_params[0][:quantity])
        expect(real_estate.real_estate_contents.first.description).to eq(content_params[0][:description])
      end
    end

    context "when new content is added while editing" do
      let(:type_params) { { id: real_estate_type.id } }
      let(:content_params) { [
        { id: real_estate_content1.id, 
          contentName: "Kupaonice", 
          description: "Broj kupaonica u objektu.", 
          quantity: 2, 
          real_estate: real_estate},
        { contentName: "New Content",
          description: "New Content description.", 
          quantity: 1, 
          real_estate: real_estate}
        ]}
      let(:updated_real_estate_params) do {
          id: real_estate.id,
          price: 10000,
          realEstateName: "Estate 1",
          realEstateCountry: "Country",
          realEstateCity: "City",
          yearBuilt: 2022,
          squareSize: 120,
          realEstateType: type_params,
          content: content_params
        }
      end

      it "creates new content associated to real estate" do
        put :update, params: updated_real_estate_params 

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response).to eq("Real estate updated successfuly!")

        real_estate.reload
        expect(real_estate.real_estate_contents.count).to eq(2)
        expect(real_estate.real_estate_contents.last.contentName).to eq(content_params[1][:contentName])
        expect(real_estate.real_estate_contents.last.quantity).to eq(content_params[1][:quantity])
        expect(real_estate.real_estate_contents.last.description).to eq(content_params[1][:description])
      end
    end

    context "when content is deleted while editing" do
      let(:type_params) { { id: real_estate_type.id } }
      let(:content_params) { [] }
      let(:updated_real_estate_params) do {
          id: real_estate.id,
          price: 10000,
          realEstateName: "Estate 1",
          realEstateCountry: "Country",
          realEstateCity: "City",
          yearBuilt: 2022,
          squareSize: 120,
          realEstateType: type_params,
          content: content_params
        }
      end

      it "deletes content that is missing from response" do
        put :update, params: updated_real_estate_params 

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response).to eq("Real estate updated successfuly!")

        real_estate.reload
        expect(real_estate.real_estate_contents.count).to eq(0)
      end
    end

    context "when invalid parameters are provided" do
      let(:invalid_real_estate_params) { {  id: real_estate.id, realEstateName: nil } }

      it "returns a JSON response with an error message" do
        put :update, params: invalid_real_estate_params 

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Update error...")

        real_estate.reload
        expect(real_estate.realEstateName).not_to be_nil
      end
    end
  end


  describe "DELETE #destroy" do
    let!(:real_estate_type) { RealEstateType.create(typeName: "House", description: "A residential property") }
    let!(:real_estate) { RealEstate.create(realEstateName: "Estate 1", price: 100000, realEstateCountry: "Country", realEstateCity: "City") }

    context "when real estate doesn't have associated contents" do
      it "destroys the real estate and returns a success message" do
        expect {
          delete :destroy, params: { id: real_estate.id }
        }.to change(RealEstate, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json; charset=utf-8")

        json_response = JSON.parse(response.body)
        expect(json_response).to eq("Real estate deleted!")
      end
    end

    context "when real estate has associated contents" do
      let!(:real_estate_content1) { create(:real_estate_content, contentName: "Content 1", description: "Content 1 description.", quantity: 2, real_estate: real_estate) }

      it "destroys the real estate and associated contents and returns a success message" do
        expect {
          delete :destroy, params: { id: real_estate.id }
        }.to change(RealEstate, :count).by(-1)
        .and change(RealEstateContent, :count).by(-1)

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response).to eq("Real estate deleted!")
      end

      it "returns an error message when real estate is not found" do
        delete :destroy, params: { id: 999 }

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq("application/json")

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Real estate not found!")
      end
    end
  end
end