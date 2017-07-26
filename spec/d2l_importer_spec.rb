require "spec_helper"

describe D2lImporter do
  it "has a version number" do
    expect(D2lImporter::VERSION).not_to be_nil
  end

  it "has a Converter module" do
    expect(D2lImporter::Converter).not_to be_nil
  end
end
