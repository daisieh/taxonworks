require 'rails_helper'

describe 'CollectingEvents', :type => :feature do
  let(:page_title) { 'Collecting events' }
  let(:index_path) { collecting_events_path }

  it_behaves_like 'a_login_required_and_project_selected_controller' do
  end

  context 'signed in as a user, with some records created' do
    before do 
      sign_in_user_and_select_project
      10.times { factory_girl_create_for_user_and_project(:valid_collecting_event, @user, @project) }
    end 

    describe 'GET /collecting_events' do
      before { visit collecting_events_path }

      it_behaves_like 'a_data_model_with_standard_index'
    end

    describe 'GET /collecting_events/list' do
      before do
        visit list_collecting_events_path
      end

      it_behaves_like 'a_data_model_with_standard_list_and_records_created'
    end

    describe 'GET /collecting_events/n' do
      before {
        visit collecting_event_path(CollectingEvent.second)
      }

      it_behaves_like 'a_data_model_with_standard_show'

      specify 'there is a \'Add Google map georeference\' link' do
        expect(page).to have_link('Add Google map georeference')
      end
    end
  end

  context 'creating a new collecting event' do
    before do 
      sign_in_user_and_select_project # logged in and project selected
      visit collecting_events_path # when I visit the collecting_events_path
    end 

    specify 'following the new link & create a new collecting event' do
      click_link('New') # when I click the new link
      # I fill out the verbatim_label field with "This is a label.\nAnd a second line."
      fill_in 'Verbatim label', with: 'This is a label.\nAnd a second line.'

      click_button 'Create Collecting event' # when I click the 'Create Collecting event' button
      # then I get the message "Collecting event was successfully created"
      expect(page).to have_content('Collecting event was successfully created.')
    end
  end
end
