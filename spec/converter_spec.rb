require 'spec_helper'

describe D2lImporter::Converter do
  it "is a Canvas LMS class" do
    expect(D2lImporter::Converter).to be < Canvas::Migration::Migrator
  end

  before do
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
  end

  it 'should initalize' do
    settings = {archive_file: File.new('/dev/null')}
    expect{ D2lImporter::Converter.new(settings) }.not_to raise_error
  end

  it 'should require super' do
    settings = {}
    expect{ D2lImporter::Converter.new(settings) }.to raise_error RuntimeError
  end
end
