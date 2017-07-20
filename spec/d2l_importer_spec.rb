require "spec_helper"

describe D2lImporter do
  it "has a version number" do
    expect(D2lImporter::VERSION).not_to be nil
  end

  it "has a Converter module" do
    expect(D2lImporter::Converter).to be_a_kind_of Module
  end
end
