require 'rails_helper'

describe CorrectionPolicy do
  context 'toegang' do
    subject { CorrectionPolicy.new(user, correction) }
    let(:correction) { FactoryGirl.create :correction }

    context 'voor anonieme gebruikers' do
      let(:user) { nil }

      it { should forbid_edit_and_update_actions }
      it { should forbid_action :destroy }
    end

    context "voor willekeurige gebruikers" do
      let(:user) { FactoryGirl.create :user }

      it { should permit_edit_and_update_actions }
      it { should permit_action :destroy }
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_edit_and_update_actions }
      it { should permit_action :destroy }
    end
  end
end
