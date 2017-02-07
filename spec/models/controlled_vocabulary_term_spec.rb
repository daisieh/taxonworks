require 'rails_helper'

describe ControlledVocabularyTerm, :type => :model do
  let(:controlled_vocabulary_term) { FactoryGirl.build(:controlled_vocabulary_term) }

  context 'validation' do
    before(:each) { controlled_vocabulary_term.valid? }

    context 'required' do
      specify 'name' do
        expect(controlled_vocabulary_term.errors.include?(:name)).to be_truthy
      end

      specify 'definition' do
        expect(controlled_vocabulary_term.errors.include?(:definition)).to be_truthy
      end

      specify 'type' do
        expect(controlled_vocabulary_term.errors.include?(:type)).to be_truthy
      end
    end
  end

  context 'name and definition ' do
    let(:name) { 'Name should be unique' }
    let(:definition) { 'Never before seen!' }
    
    before { Keyword.create!(name: name, definition: definition) } 

    specify 'are unique' do
      expect(Keyword.new(name: name, definition: definition).valid?).to be_falsey 
    end
  end

  specify 'definition is 4 letters long minium' do
    controlled_vocabulary_term.definition = 'abc'
    controlled_vocabulary_term.valid?
    expect(controlled_vocabulary_term.errors.include?(:definition)).to be_truthy
  end

  specify 'if uri is provided uri_relation must also be provided' do
    controlled_vocabulary_term.uri = 'http://abc.com/123'
    expect(controlled_vocabulary_term.valid?).to be_falsey
    expect(controlled_vocabulary_term.errors.include?(:uri_relation)).to be_truthy
  end

  specify 'if uri_relation is provided uri must also be provided' do
    controlled_vocabulary_term.uri_relation = 'skos:narrowMatch'
    expect(controlled_vocabulary_term.valid?).to be_falsey
    expect(controlled_vocabulary_term.errors.include?(:uri)).to be_truthy
  end

  specify 'if uri_relation is provided it must be in SKOS_RELATIONS' do
    controlled_vocabulary_term.uri_relation = 'skos:not_real_fake'
    expect(controlled_vocabulary_term.valid?).to be_falsey
    expect(controlled_vocabulary_term.errors.include?(:uri_relation)).to be_truthy
  end

  context 'within projects' do
    let(:uri) { 'http://purl.org/net/foo/1' }

    specify 'name is unique within projects per type' do
      a = FactoryGirl.create(:valid_controlled_vocabulary_term)
      b = FactoryGirl.build(:controlled_vocabulary_term, a.attributes.merge(definition: 'Something else.', uri: uri, uri_relation: 'skos:closeMatch' ))
      expect(b.valid?).to be_falsey
      b.name = 'Something Completely Different'
      expect(b.valid?).to be_truthy
    end

    specify 'definition is unique within projects' do
      a = FactoryGirl.create(:valid_controlled_vocabulary_term, definition: 'Something crazy!', uri: uri, uri_relation: 'skos:closeMatch')
      b = FactoryGirl.build(:valid_controlled_vocabulary_term, name: 'Something else.', definition: 'Something crazy!', uri: uri, uri_relation: 'skos:closeMatch')
      expect(b.valid?).to be_falsey
      expect(b.errors.include?(:definition)).to be_truthy
    end

    specify 'uri is unique within projects' do
      a = FactoryGirl.create(:valid_controlled_vocabulary_term, uri: uri,  uri_relation: 'skos:closeMatch')
      b = FactoryGirl.build(:valid_controlled_vocabulary_term, uri: uri, uri_relation: 'skos:closeMatch' )
      expect(b.valid?).to be_falsey
      expect(b.errors.include?(:uri)).to be_truthy
    end

    specify 'is case sensitive, i.e. bat and Bat are different' do
      a = FactoryGirl.create(:valid_controlled_vocabulary_term, name: 'blue')
      b = FactoryGirl.build(:valid_controlled_vocabulary_term, definition: 'Something else.', name: 'Blue', uri: uri, uri_relation: 'skos:closeMatch')
      expect(b.valid?).to be_truthy
    end

  end

  context 'concerns' do
    it_behaves_like 'alternate_values'
    it_behaves_like 'is_data'
  end

end
