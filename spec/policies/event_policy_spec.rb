require 'rails_helper'

RSpec.describe EventPolicy do
  context 'toegang' do
    subject { EventPolicy.new(user, event) }
  
    let(:user) { FactoryGirl.create :user }
    let(:event) { FactoryGirl.create :event }

    context 'voor anonieme gebruikers' do
      let(:user) { nil }

      it { should forbid_edit_and_update_actions }
      it { should forbid_action :destroy }
    end

    context "voor willekeurige gebruikers" do
      let(:user) { FactoryGirl.create :user }

      it { should forbid_edit_and_update_actions }
      it { should forbid_action :destroy }
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_edit_and_update_actions }
      it { should permit_action :destroy }
    end
  end
end