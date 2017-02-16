require 'rails_helper'

describe UserPolicy do
  context 'toegang' do
    subject { UserPolicy.new(user, other_user) }
    let(:user)        { FactoryGirl.create :user }
    let(:other_user)  { FactoryGirl.create :user }

    let(:resolved_scope) do
      UserPolicy::Scope.new(user, User.all).resolve
    end

    context 'voor anonieme gebruikers:' do
      let(:user) { nil }
      it 'sluit de andere gebruikers buiten zijn scope' do
        expect(resolved_scope).not_to include(other_user)
      end

      it { should forbid_action :index }
      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action :destroy }
    end

    context "voor willekeurige gebruikers:" do
      context 'op andere gebruikers' do
        it 'sluit de andere gebruikers buiten zijn scope' do
         expect(resolved_scope).not_to include(other_user)
        end

        it { should_not permit_action :index }
        it { should forbid_new_and_create_actions }
        it { should forbid_edit_and_update_actions }
        it { should forbid_action :destroy }
      end
      context 'op zichzelf' do
        let(:other_user) { user }

        it { should permit_edit_and_update_actions }
        it { should forbid_action :destroy }
      end
    end

    context 'voor administrators:' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :index }

      context 'op andere gebruikers' do
        it 'sluit de andere gebruikers buiten zijn scope' do
          expect(resolved_scope).to include(other_user)
        end

        it { should permit_new_and_create_actions }
        it { should permit_edit_and_update_actions }
        it { should forbid_action :destroy }
      end
      context 'op zichzelf' do
        let(:other_user) { user }

        it { should permit_action :update }
        it { should forbid_action :destroy }
      end
    end
  end
end
