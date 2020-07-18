require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show with out city state" do
    visit company_path(@company)
    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
  end

  test "Update" do
    visit edit_company_path(@company)
    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  test "Invalid zip code update" do
    old_zip = @company.zip_code
    visit edit_company_path(@company)
    within("form#edit_company_#{@company.id}") do
      fill_in("company_zip_code", with: "dduddugd")
      click_button "Update Company"
    end
    assert_text "Error Please validate your entered zip code"

    @company.reload
    assert_equal old_zip, @company.zip_code
  end

  test "Invalid email" do
    visit edit_company_path(@company)
    within("form#edit_company_#{@company.id}") do
      fill_in("company_email", with: "Updated Test Company")
    end

    message = find("#company_email").native.attribute("title")
    normalValidation =find("#company_email").native.attribute("validationMessage")
    assert_equal  message, "email domain not permitted"
    assert_equal normalValidation, "Please match the requested format."
  end

  test "Invalid number" do
    visit edit_company_path(@company)
    within("form#edit_company_#{@company.id}") do
      fill_in("company_phone", with: "Updated Test Company")
    end

    message = find("#company_phone").native.attribute("title")
    normalValidation =find("#company_phone").native.attribute("validationMessage")
    puts normalValidation
    puts message
    assert_equal  message, "Please enter a valid phone number without your area code"
    assert_equal normalValidation, "Please match the requested format."
  end
  
end
