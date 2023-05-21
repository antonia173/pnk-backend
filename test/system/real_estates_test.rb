require "application_system_test_case"

class RealEstatesTest < ApplicationSystemTestCase
  setup do
    @real_estate = real_estates(:one)
  end

  test "visiting the index" do
    visit real_estates_url
    assert_selector "h1", text: "Real estates"
  end

  test "should create real estate" do
    visit real_estates_url
    click_on "New real estate"

    click_on "Create Real estate"

    assert_text "Real estate was successfully created"
    click_on "Back"
  end

  test "should update Real estate" do
    visit real_estate_url(@real_estate)
    click_on "Edit this real estate", match: :first

    click_on "Update Real estate"

    assert_text "Real estate was successfully updated"
    click_on "Back"
  end

  test "should destroy Real estate" do
    visit real_estate_url(@real_estate)
    click_on "Destroy this real estate", match: :first

    assert_text "Real estate was successfully destroyed"
  end
end
