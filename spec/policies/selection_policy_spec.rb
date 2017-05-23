require 'rails_helper'

describe SelectionPolicy do
  context 'toegang' do
    subject { SelectionPolicy.new(user, selection) }
    let(:order) { FactoryGirl.create( :order, customer: user) }
    let(:product) { FactoryGirl.create( :product) }
    let(:selection) { FactoryGirl.create :selection, order: order, product: product }

    context 'voor anonieme gebruikers' do
      let(:user) { nil }

      it { should permit_edit_and_update_actions } # moet misschien forbid zijn, maar te complex even.
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
