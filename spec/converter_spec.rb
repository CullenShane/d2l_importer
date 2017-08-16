require 'spec_helper'

describe D2lImporter::Converter do
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

  it 'is a Canvas LMS class' do
    expect(D2lImporter::Converter).to be < Canvas::Migration::Migrator
  end

  it 'should initialize' do
    settings = {archive_file: File.new('/dev/null')}
    expect{ D2lImporter::Converter.new(settings) }.not_to raise_error
  end

  it 'should require some settings' do
    settings = {}
    expect{ D2lImporter::Converter.new(settings) }.to raise_error RuntimeError
  end

  context '#export' do
    let(:archive_file) { File.new('/dev/null') }
    subject { D2lImporter::Converter.new({archive_file: archive_file, unzipped_file_path: File.join(__dir__, 'fixtures')}) }
    it 'should export a course hash' do
      expect{subject.export}.not_to raise_error
      expect(subject.export).to be_a Hash
      expect(subject.resources).not_to be_nil
      expect(subject.resources).to be_a Hash
      expect(subject.export[:modules]).to be_a Array
    end
  end
end
