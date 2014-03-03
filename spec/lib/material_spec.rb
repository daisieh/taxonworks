require 'spec_helper'
require 'material'

describe 'Material' do 
  context '#create_quick_verbatim' do
  
    before(:each) {
      @one_object_stub = {collection_objects: {}}
      @one_object_stub[:collection_objects][:object1] = {total: nil}

      @two_objects_stub = {collection_objects: {}} # need a deep clone method
      @two_objects_stub[:collection_objects][:object1] = {total: nil}
      @two_objects_stub[:collection_objects][:object2] = {total: nil}
    }

    specify 'returns a response instance of Material::QuickVerbatimResponse' do
      expect(Material.create_quick_verbatim().class).to eq(Material::QuickVerbatimResponse) 
    end

    specify 'returns no collection objects when no options are passed' do
      expect(Material.create_quick_verbatim.collection_objects).to eq([])
    end

    specify 'returns a single collection object when collection_objects[:object1][:total] is set' do
      @one_object_stub[:collection_objects][:object1][:total] = 1
      expect(Material.create_quick_verbatim(@one_object_stub).collection_objects).to have(1).things
    end

    specify 'returns an array of objects when multiple object totals are set' do
      expect(Material.create_quick_verbatim(@two_objects_stub).collection_objects).to have(2).things
    end

    specify 'uses the buffered_ values when provided' do
      event = 'ABCD'
      opts = @one_object_stub.merge(collection_object: {buffered_collecting_event: event}) 
      @one_object_stub[:collection_objects][:object1][:total] = 1
      expect(Material.create_quick_verbatim(opts).collection_objects).to have(1).things
      expect(Material.create_quick_verbatim(opts).collection_objects.first.buffered_collecting_event).to eq(event)
    end

    specify 'contains multiple objects with a virtual container when no container provided' do
      @two_objects_stub[:collection_objects][:object1][:total] = 1
      @two_objects_stub[:collection_objects][:object2][:total] = 2
      response = Material.create_quick_verbatim(@two_objects_stub)
      expect(response.collection_objects.first.container.class).to eq(Container::Virtual)
      expect(response.collection_objects.first.container).to eq(response.collection_objects.last.container)
    end

    specify 'assigns a note when provided' do
      text = 'Some text.'
      @one_object_stub[:collection_objects][:object1][:total] = 1
      opts = @one_object_stub.merge(
        note: {text: text}
      )
      response = Material.create_quick_verbatim(opts)
      expect(response.collection_objects.first.notes).to have(1).things
      expect(response.collection_objects.first.notes.first.text).to eq(text)
    end

    specify 'assigns the "same" note to more than one' do
      text = 'Some text.'
      @two_objects_stub[:collection_objects][:object1][:total] = 1
      @two_objects_stub[:collection_objects][:object2][:total] = 2
    
      opts = @two_objects_stub.merge(
        note: {text: text}
      )
      response = Material.create_quick_verbatim(opts)
      expect(Material.create_quick_verbatim(opts).collection_objects).to have(2).things
      expect(response.collection_objects.first.notes.first.text).to eq(response.collection_objects.last.notes.first.text)
    end

    specify 'material can be assigned to a repository' do
      repository = FactoryGirl.create(:valid_repository)
      @one_object_stub[:collection_objects][:object1][:total] = 1
      opts = @one_object_stub.merge(collection_object: {repository_id: repository.id}) 
      response = Material.create_quick_verbatim(opts)
      expect(response.collection_objects.first.repository).to eq(repository)
    end

    specify 'attributes are assigned' do

    end

  end
end


describe Material::QuickVerbatimResponse do

  before(:each) {
    @response = Material::QuickVerbatimResponse.new()
  }

  specify '#collection_objects' do
    expect(@response.collection_objects).to eq([]) 
  end

  # specify '#next_identifier(IdentifierFactory)' do
  #   expect(response.next_identifier.class).to eq(Identifier) 
  # end

  specify '#identifier' do
    expect(@response.identifier.class).to eq(Identifier) 
  end

  specify '#repository' do
    expect(@response.repository.class).to eq(Repository) 
  end

  specify '#note' do
    expect(@response.note.class).to eq(Note) 
  end

end
