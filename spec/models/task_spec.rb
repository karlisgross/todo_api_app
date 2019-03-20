require 'rails_helper'

RSpec.describe Task, type: :model do
  include Shoulda::Matchers::ActiveRecord

  subject { described_class.new({title: "Tsk", tags: [ "Tag1", "Tag2"]}) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
    subject.tags = nil
    expect(subject).to be_valid
  end

  it "is not valid with a bad title" do
    subject.title = nil
    expect(subject).to_not be_valid
    subject.title = "Ts"
    expect(subject).to_not be_valid #too short (3 char min)
  end

  it "has a valid many to many with Tag" do
    should have_and_belong_to_many(:tags).autosave(true)
  end

end
