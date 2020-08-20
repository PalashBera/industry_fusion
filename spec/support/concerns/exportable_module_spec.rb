require "rails_helper"

shared_examples_for "export_module" do
  let(:user)    { create(:admin_user) }
  let(:example) { create(described_class.to_s.split("::")[1].gsub("Controller", "").singularize.underscore.downcase.to_sym, archive: true) }

  describe "GET export" do
    it "should return proper response header" do
      get :export, params: { q: { archive_eq: "true"} }, format: "xlsx"
      expect(response.header["Content-Type"]).to include "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    end

    it "requires login & returns the proper search results" do
      sign_in user
      get :export, params: { q: { archive_eq: "true"} }, format: "xlsx"
      expect(assigns(:resources).include?(example)).to eq(true)
    end
  end
end
