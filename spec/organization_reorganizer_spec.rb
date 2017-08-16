require 'spec_helper'

describe D2lImporter::Converter::OrganizationReorganizer do

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

end
