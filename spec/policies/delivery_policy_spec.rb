require 'rails_helper'

describe DeliveryPolicy do
  context 'toegang' do
    subject { DeliveryPolicy.new(user, delivery) }
    let(:delivery) { FactoryGirl.create :delivery }

    context 'voor anonieme gebruikers' do
      let(:order) { FactoryGirl.create( :order, package_delivery: delivery) }
      let(:user) { nil }

      it { should forbid_edit_and_update_actions }
      it { should forbid_action :destroy }
    end

    context "voor willekeurige gebruikers" do
      let(:user) { FactoryGirl.create :user }
      let(:order) { FactoryGirl.create( :order, package_delivery: delivery, customer: user) }

      it { should permit_edit_and_update_actions }
      it { should forbid_action :destroy }
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }
      let(:order) { FactoryGirl.create( :order, package_delivery: delivery, customer: user) }

      it { should permit_edit_and_update_actions }
      it { should forbid_action :destroy }
    end
  end
end
