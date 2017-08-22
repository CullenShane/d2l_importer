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
      subject.first[:items].each do |item|
        expect(item).to include :type, :item_migration_id, :linked_resource_id, :linked_resource_title, :linked_resource_type
      end
      subject.first[:items].first.each_value do |val|
        expect(val).not_to be_nil
      end
      expect(subject.first[:items].length).to eq 2
    end
  end

  context '#get_d2l_code_from' do
    let(:href) { '/d2l/common/dialogs/quickLink/quickLink.d2l?ou={orgUnitId}&amp;type=discuss&amp;rCode=019c73b0-e08e-4030-ae29-05956f973b1d' }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    subject { converter.get_d2l_code_from(href) }
    it { is_expected.to eq '019c73b0-e08e-4030-ae29-05956f973b1d'}
    context 'bad href' do
      let(:href) { '' }
      it { is_expected.to eq nil }
    end
  end

  context '#get_d2l_type_from' do
    let(:href) { '/d2l/common/dialogs/quickLink/quickLink.d2l?ou={orgUnitId}&amp;type=discuss&amp;rCode=019c73b0-e08e-4030-ae29-05956f973b1d' }
    let(:converter) { D2lImporter::Converter.new( {archive_file: nil} ) }
    subject { converter.get_d2l_type_from(href) }
    it { is_expected.to eq 'discussion' }
    context 'bad href' do
      let(:href) { '' }
      it { is_expected.to eq nil }
    end
  end

end
