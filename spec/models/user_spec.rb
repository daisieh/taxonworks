require 'rails_helper'

describe User, :type => :model do

  let(:user) { User.new(password: 'password',
                        password_confirmation: 'password',
                        email: 'user_model@example.com',
                        name: 'Bob'
  ) }
  subject { user }

  context 'associations' do
    context 'has_many' do
      specify 'projects' do
        expect(user.projects << Project.new()).to be_truthy
      end

      specify 'pinboard_items' do
        expect(user.pinboard_items << PinboardItem.new()).to be_truthy
      end
    end
  end

  context 'preferences' do
    specify '#hub_favorites' do
      expect(user.hub_favorites).to eq({})
    end

    specify '#footprints' do
      expect(user.footprints).to eq({})
    end

    context '#hub_tab_order' do
      specify 'is an array' do
        expect(user.hub_tab_order).to eq([])
      end

      specify 'is set to DEFAULT_HUB_TAB_ORDER after_create' do
        expect(user.save!).to be_truthy
        expect(user.hub_tab_order).to eq(DEFAULT_HUB_TAB_ORDER)
      end
    end

  end

  context 'authorization' do
    context 'when just a user' do
      specify '#is_administrator? is false' do
        expect(user.is_administrator?).to be(false)
      end

      specify '#is_project_administrator? is false' do
        expect(user.is_project_administrator?).to be(false)
      end

      specify '#is_super_user?' do
        expect(user.is_superuser?).to be(false)
      end
    end

    context 'when administator' do
      before { user.is_administrator = true }
      specify '#is superuser?' do
        expect(user.is_superuser?).to be true
      end
    end

    context 'when a project administrator' do
      before {
        ProjectMember.create(project_id: $project_id, user: user, is_project_administrator: true)
      }

      specify '#is_superuser(project)?' do
        expect(user.is_superuser?(Project.find($project_id))).to be true
      end

      specify '#administered_projects' do
        expect(user.administered_projects).to contain_exactly(Project.find($project_id) )
      end

      specify '#administers_projects?' do
        expect(user.administers_projects?).to be true 
      end

    end
  end

  context 'with password, password confirmation, name, and email' do
    it { is_expected.to be_valid }
  end

  context 'with password, password confirmation, name < 2 characters, and email' do
    before { user.password = user.name= 'a' }
    it { is_expected.to be_invalid }
  end

  context 'when password is empty' do
    before { user.password = user.password_confirmation = '' }
    it { is_expected.to be_invalid }
  end

  context 'when password confirmation doesn\'t match' do
    before { user.password_confirmation = 'mismatch' }
    it { is_expected.to be_invalid }
  end

  context 'when password is too short' do
    before { user.password = user.password_confirmation = 'a' * 5 }
    it { is_expected.to be_invalid }
  end

  context 'when email is empty' do
    before { user.email = '' }
    it { is_expected.to be_invalid }
  end

  context 'when email doesn\'t match expected format' do
    before { user.email = 'a b@c.d' }
    it { is_expected.to be_invalid }
  end

  describe 'saved user' do
    before { user.save }
    context 'password is not validated on .update() when neither password and password_confirmation are provided' do
      before { user.update(email: 'abc@def.com') }
      it { is_expected.to be_valid }
      specify 'without errors' do
        expect(user.errors.count).to eq(0)
      end
    end

    context 'password is validated on .update() when password is provided' do
      before { user.update(password: 'Abcd123!') }
      it { is_expected.not_to be_valid }
    end

    context 'password is validated on .update() when password is provided' do
      before { user.update(password_confirmation: 'Abcd123!') }
      it { is_expected.not_to be_valid }
    end
  end

  context 'new users' do
    before {
      user.self_created = true
      user.save
    }

    specify 'if self_created = true creator is self after save' do
      expect(user.creator).to eq(user)
    end

    specify 'if self_created = true updater is self after save' do
      expect(user.updater).to eq(user)
    end
  end


  describe 'remember token' do
    before { user.save }
    it(:remember_token) { is_expected.not_to be_blank }
  end

  describe 'password reset token' do

    it 'is nil on a newly created user' do
      expect(user.password_reset_token).to be_nil
    end

    include_examples "random_token_methods" do
      let(:token_name) { :password_reset }
    end
  end

  describe 'API access token' do
    it 'is nil on a newly created user' do
      expect(user.api_access_token).to be_nil
    end

    describe '#generate_api_access_token' do
      it 'returns a secure random string generated from RandomToken.generate' do
        value = RandomToken.generate
        allow(RandomToken).to receive(:generate).and_return(value)
        expect(user.generate_api_access_token).to eq(value)
      end

      it 'stores the token in api_access_token field' do
        token = user.generate_api_access_token
        expect(user.api_access_token).to eq(token)
      end
    end
  end

  context 'user activity summaries' do
    before {
      user.save
      4.times { (FactoryGirl.create(:valid_otu, creator: user, updater: user)) }
      @last_otu = FactoryGirl.create(:valid_otu, creator: user, updater: user)
    }

    # specify '.last Otu created by me' do
    #   expect(user.last_otu_created).to eq @last_otu
    # end

    specify '.total_objects(Otu)' do
      expect(user.total_objects(Otu)).to eq 5
    end

    specify ".total_objects2('otus')" do # klass_string expects plural
      expect(user.total_objects2('otus')).to eq 5
    end
  end

  context 'footprints' do
    before {
      user.save
    }
    let(:otu) { Otu.create(name: 'for footprints testing') }
    let(:object_route) { "/otus/#{otu.id.to_s}" }

    context 'add_recently_visited_to_footprint' do

      specify 'with a route and no recent object' do
        user.add_recently_visited_to_footprint('/otus/')
        expect(user.footprints).to eq('recently_visited' =>  [{'/otus/' => {}}])
      end

      specify 'with a route and a recent object' do
        user.add_recently_visited_to_footprint(object_route, otu)
        expect(user.footprints).to eq('recently_visited' => [ {object_route => {object_type: 'Otu', object_id: otu.id}} ])
      end

      specify 'with the same route and recent object > 1x' do
        user.add_recently_visited_to_footprint(object_route, otu)
        user.add_recently_visited_to_footprint(object_route, otu)
        user.add_recently_visited_to_footprint(object_route, otu)
        
        expect(user.footprints).to eq('recently_visited' => [ {object_route => {object_type: 'Otu', object_id: otu.id}} ])
      end

      specify 'current limit is 10 items' do
        (0..25).each do |i|
          user.add_recently_visited_to_footprint("/otus/#{i}")
        end
        expect(user.footprints['recently_visited'].count).to eq(20)
      end

    end
   
  end

  context 'scopes' do
    let(:p) { Project.create(name: 'Stubbed for project member test') }
    let!(:u) { User.create(name: 'Jones', email: 'abc@example.com', self_created: true, password: 'acdadewsr1A') }

    specify '.not_in_project' do
      expect(User.not_in_project(1).to_a).to include(u)
    end

  end

  context 'concerns' do
    it_behaves_like 'data_attributes'
    it_behaves_like 'notable'
    # it_behaves_like 'random_token_fields'
  end

end
