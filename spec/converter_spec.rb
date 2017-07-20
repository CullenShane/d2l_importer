require 'spec_helper'

describe D2lImporter::Converter do
  it "is a Canvas LMS class" do
    expect(D2lImporter::Converter).to be < Canvas::Migration::Migrator
  end

  it 'should initalize' do
    Rails.application =
        Class.new do
                 def self.config
                   Class.new do
                     def self.root
                       Pathname.new(File.path(__dir__))
                     end
                   end
                 end
    end
    expect{D2lImporter::Converter.new({archive_file: File.new('/dev/null')}) }.not_to raise_error
  end
end
