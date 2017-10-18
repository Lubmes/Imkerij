require 'rails_helper'

describe InvoicePolicy do
  context 'toegang' do
    subject { InvoicePolicy.new(user, invoice) }
    let(:order) { FactoryGirl.create :order }
    let(:invoice) { FactoryGirl.create :invoice, order: order }

    context 'voor anonieme gebruikers' do
      let(:user) { nil }

      it { should forbid_action :pdf }
    end

    context "voor willekeurige gebruikers" do
      let(:user) { FactoryGirl.create :user }

      it { should permit_action :pdf }
      it { should forbid_action :print }
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :pdf }
      it { should permit_action :print }
    end
  end
end
