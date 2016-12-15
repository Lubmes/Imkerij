require 'rails_helper'

RSpec.describe ProductPolicy do
  context 'toegang' do
    subject { ProductPolicy.new(user, product) }
  
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }
    let(:product) { FactoryGirl.create :product,
                                        category: category }

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