require 'rails_helper'

RSpec.describe Tag, type: :model do
  include Shoulda::Matchers::ActiveRecord

  subject { described_class.new(title: "Tag") }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid with a bad title" do
    should validate_uniqueness_of(:title)

    subject.title = nil
    expect(subject).to_not be_valid
    subject.title = "Ta"
    expect(subject).to_not be_valid #too short (3 char min)
  end

  it "has a valid many to many with Task" do
    should have_and_belong_to_many(:tasks).autosave(false)
  end

end