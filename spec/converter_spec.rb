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

  context '#consume_resources' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    subject { converter.consume_resources(manifest) }
    it 'will return a hash' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject['RES_CONTENT_42']).not_to be_nil
      expect(subject['RES_CONTENT_42']).to be_a Hash
      expect(subject['RES_CONTENT_42'].keys).to include :type, :migration_id, :href, :material_type
      expect(subject['RES_CONTENT_42'][:material_type]).to eq 'contentmodule'
      expect(subject['RES_CONTENT_244'][:material_type]).to eq 'content'
    end
  end

  context '#reoganize_organizations' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    before { converter.consume_resources(manifest) }
    subject { converter.reorganize_organization(manifest) }
    it 'will return an array' do
      expect{subject}.not_to raise_error
      expect(subject).to be_an Array
      expect(subject).not_to be_empty
      expect(subject.first[:title]).to eq 'Getting Started'
      expect(subject.first[:items]).to be_an Array
      expect(subject.first[:items].length).to eq 1 #TODO: This should be 2
    end
  end

  context '#create_file_map' do
    let(:manifest) { ::Nokogiri::HTML File.open File.join(__dir__, 'fixtures','imsmanifest.xml') }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    before { converter.consume_resources(manifest) }
    subject { converter.create_file_map(manifest) }
    it 'will return an array' do
      expect{subject}.not_to raise_error
      expect(subject).to be_a Hash
      expect(subject).not_to be_empty
      expect(subject.length).to be 1
      expect(subject['RES_CONTENT_244'].keys).to include :migration_id, :path_name, :file_name, :type
    end
    context '#package_course_files' do
      let(:course) { { file_map: converter.create_file_map(manifest) } }
      subject { converter.package_course_files(course) }
      it 'will write a file' do
        expect{subject}.not_to raise_error
        expect(subject).to be_a String
        puts subject
        expect(File.exist? subject).to be true
      end
    end
  end
end
