require 'spec_helper'

RSpec.describe Country, type: :model do

  let(:ind) {FactoryGirl.create(:country, name: "India", code: "IND")}
  let(:usa) {FactoryGirl.create(:country, name: "United States of America", code: "USA")}
  let(:uae) {FactoryGirl.create(:country, name: "United Arab Emirates", code: "UAE")}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:country).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('United States of America').for(:name )}
    it { should allow_value('USA').for(:name )}
    it { should allow_value('US').for(:name )}
    it { should_not allow_value("X").for(:name )}
    it { should_not allow_value("x"*129).for(:name )}

    it { should validate_presence_of :code }
    it { should allow_value('USA').for(:code )}
    it { should allow_value('US').for(:code )}
    it { should_not allow_value("X").for(:code )}
    it { should_not allow_value("x"*17).for(:code )}
  end

  context "Associations" do
  end

  context "Class Methods" do
    it "search" do
      [ind, usa, uae]
      expect(Country.search("United States")).to match_array([usa])
      expect(Country.search("India")).to match_array([ind])
      expect(Country.search("United")).to match_array([usa, uae])
    end

    context "Import Methods" do

      it "save_row_data" do
        row = {id: "1", name: "Australia", code: "AUS"}
        error_object = Country.save_row_data(row)
        expect(error_object.errors).to be_empty
        expect(Country.find_by_code("AUS")).not_to be_nil

        row = {name: "Canada", code: ""}
        error_object = Country.save_row_data(row)
        expect(error_object.errors).not_to be_empty
        expect(Country.find_by_code("CAN")).to be_nil

        row = {name: "", code: "CAN"}
        error_object = Country.save_row_data(row)
        expect(error_object).to be_nil
        expect(Country.find_by_code("CAN")).to be_nil
      end

    end
    
  end

  context "Instance Methods" do

    it "display_name" do
      usa.name = "Changed"
      expect(usa.display_name).to match("United States of America")
    end

    it "can_be_edited?" do
      expect(ind.can_be_edited?).to be_truthy
    end

    it "can_be_deleted?" do
      expect(ind.can_be_deleted?).to be_truthy
    end

  end

end