require 'test_helper'

class RealEstatesControllerTest < ActionDispatch::IntegrationTest
  # def setup
  #   @real_estate = real_estates(:one)
  # end

  # test "should get index" do
  #   get real_estates_url
  #   assert_response :success
  #   assert_equal response.content_type, 'application/json'
  #   assert_not_nil response.parsed_body
  #   assert_equal response.parsed_body.length, RealEstate.count
  # end

  # test "should create real estate" do
  #   assert_difference('RealEstate.count') do
  #     post real_estates_url, params: { real_estate: { realEstateName: "Test Estate", price: 1000, realEstateCountry: "Test Country", realEstateCity: "Test City", squareSize: 100, yearBuilt: 2000 } }
  #   end
  #   assert_response :success
  #   assert_equal response.content_type, 'application/json'
  #   assert_not_nil response.parsed_body['id']
  # end

  # test "should update real estate" do
  #   patch real_estate_url(@real_estate), params: { real_estate: { realEstateName: "Updated Estate" } }
  #   assert_response :success
  #   assert_equal response.content_type, 'application/json'
  #   @real_estate.reload
  #   assert_equal "Updated Estate", @real_estate.realEstateName
  # end

  # test "should show real estate" do
  #   get real_estate_url(@real_estate)
  #   assert_response :success
  #   assert_equal response.content_type, 'application/json'
  #   assert_not_nil response.parsed_body['id']
  #   assert_not_nil response.parsed_body['realEstateName']
  # end

  # test "should destroy real estate" do
  #   assert_difference('RealEstate.count', -1) do
  #     delete real_estate_url(@real_estate)
  #   end
  #   assert_response :success
  #   assert_equal response.content_type, 'application/json'
  #   assert_equal response.parsed_body, "Real estate deleted!"
  # end
end
