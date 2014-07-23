require 'rails_helper'
describe 'Notable', :type => :model do
  let(:class_with_note) { TestNotable.new } 
 
  context 'foo', a: :b do
    it "has access to methods defined in shared context" do
      expect(shared_method).to eq("it works")
    end

    it "has access to methods defined with let in shared context" do
      expect(shared_let['arbitrary']).to eq('object')
    end

    it "runs the before hooks defined in the shared context" do
      expect(@some_var).to be(:some_value)
    end

    it "accesses the subject defined in the shared context" do
      expect(subject).to eq('this is the subject')
    end 
  end 

  context 'associations' do
    specify 'has many notes' do
      expect(class_with_note).to respond_to(:notes) # tests that the method notations exists
      expect(class_with_note.notes.count == 0).to be_truthy # currently has no notes
    end
  end

  specify 'accepts_nested_attributes_for' do
    notes = {notes_attributes: [{text: "a"}, {text: "b"}]}
    class_with_note.attributes = notes
    expect(class_with_note.save).to be_truthy
    expect(class_with_note.notes.count).to eq(2)
  end

  specify 'adding a object note works' do
    expect(class_with_note.save).to be_truthy
    expect(class_with_note.notes << FactoryGirl.build(:note, text: 'foo')).to be_truthy
    expect(class_with_note.save).to be_truthy
    expect(class_with_note.notes.count == 1).to be_truthy
    expect(class_with_note.notes[0].text).to eq('foo')
  end

  specify 'adding a attribute (column) note works' do
    expect(class_with_note.save).to be_truthy
    expect(class_with_note.notes << FactoryGirl.build(
      :note, 
      text: 'foo', 
      note_object_attribute: TestNotable.columns[4].name)).to be_truthy # column 4 is 'string', others are on restricted list
   
    expect(class_with_note.save).to be_truthy
    expect(class_with_note.notes.size == 1).to be_truthy
    expect(class_with_note.notes[0].text).to eq('foo')
    expect(class_with_note.notes[0].note_object_attribute).to eq(TestNotable.columns[4].name)
  end

  context 'can not add note to housekeeping columns' do
    before (:each) {
      @bad_note = FactoryGirl.build(:note, text: 'foo')
      expect(class_with_note.save).to be_truthy
      expect(class_with_note.notes.count == 0).to be_truthy
      @error_message = 'can not add a note to this attribute (column)'
    }

    # for each column in ::NON_ANNOTATABLE_COLUMNS test that you can't add a note to it.
    ::NON_ANNOTATABLE_COLUMNS.each do |attr|
      specify "can not add a note to #{attr.to_s}" do
        @bad_note.note_object_attribute = attr
        @bad_note.text                  = "note to #{attr.to_s}"
        expect(class_with_note.notes << @bad_note).to be_falsey
        expect(class_with_note.notes.count == 0).to be_truthy
        expect(@bad_note.errors.messages[:note_object_attribute].include?(@error_message)).to be_truthy
        # now add note to a different column
        @bad_note.note_object_attribute = TestNotable.columns[1].name
        expect(@bad_note.errors.full_messages.include?(@error_message)).to be_falsey
      end
    end

    specify 'can not add a note to a non-existent attribute (column)' do
      expect(class_with_note.save).to be_truthy
      expect(class_with_note.notes.count == 0).to be_truthy
      bad_note = FactoryGirl.build(:note, text: 'foo')

      bad_note.note_object_attribute = 'nonexistentColumn'
      expect(class_with_note.notes << bad_note).to be_falsey
      expect(class_with_note.notes.count == 0).to be_truthy
      expect(bad_note.errors.messages[:note_object_attribute].include?('not a valid attribute (column)')).to be_truthy
      # now add note to a different column
      bad_note.note_object_attribute = TestNotable.columns[1].name
      expect(bad_note.errors.full_messages.include?(@error_message)).to be_falsey
    end
  end

  context 'methods' do
    specify 'has_notations?' do
      expect(class_with_note.has_notations?).to eq(false)
    end
  end
end

class TestNotable < ActiveRecord::Base
  include FakeTable
  include Shared::Notable
end

