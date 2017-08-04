require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe D2lImporter::Converter do
  it 'should exist' do
    expect(D2lImporter::Converter).not_to be_nil
    expect(D2lImporter::Converter).to be < Canvas::Migration::Migrator
  end

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

  it 'should require some settings' do
    settings = {}
    expect{ D2lImporter::Converter.new(settings) }.to raise_error RuntimeError
  end

  context "#export" do
    let(:archive_file) { File.new(File.expand_path(File.dirname(__FILE__))+ '/fixtures/D2LExport.zip') }
    subject { D2lImporter::Converter.new({archive_file: archive_file}) }
    it "should export a course hash" do
      expect{subject.export}.not_to raise_error
      expect(subject.export).to be_a Hash
      expect(subject.resources).not_to be_nil
      puts subject.resources.inspect
    end
  end
end
