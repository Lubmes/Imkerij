require 'rails_helper'

describe OrderPolicy do
  context 'toegang' do
    subject { OrderPolicy.new(user, order) }
    let(:user) { create :user }
    let(:order) { create :order, customer: user, status: 'open' }
    let(:delivery) { create :delivery }
    let!(:selection) { create( :selection, :product_name         => 'Honingpot',
                                           :product_quantity     => 4,
                                           :product_price        => '5,00',
                                           :product_mail_weight  => '460',
                                           :product_sales_tax    => 6,
                                           :order                => order) }

    context 'voor anonieme (gast) gebruikers' do
      let(:user) { nil }

      it { should permit_action :empty }
      it { should permit_action :check_out }
      it { should forbid_action :confirm }
      it { should forbid_action :pay }
      it { should forbid_action :success }
    end

    context "voor willekeurige gebruikers" do
      let(:user) { FactoryGirl.create :user }

      it { should permit_action :empty }
      it { should permit_action :check_out }
      context 'na toevoeging adres' do
        let(:order) { FactoryGirl.create :order, customer: user, status: 'open', package_delivery: delivery }
        it { should permit_action :confirm }
      end
      context 'na confirmatie' do
        let(:order) { FactoryGirl.create :order, customer: user, status: 'confirmed', package_delivery: delivery }
        it { should permit_action :pay }
      end
      context 'na betaling' do
        let(:order) { FactoryGirl.create :order, customer: user, status: 'paid', package_delivery: delivery }
        it { should permit_action :success }
      end
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }

      context 'op andere gebruikers' do
        let(:other_user) { FactoryGirl.create :user }
        let(:order) { FactoryGirl.create :order, customer: other_user, status: 'open' }

        it { should forbid_action :empty }
        it { should permit_action :check_out }
        context 'na toevoeging adres' do
          let(:order) { FactoryGirl.create :order, customer: user, status: 'open', package_delivery: delivery }
          it { should permit_action :confirm }
        end
        context 'na confirmatie' do
          let(:order) { FactoryGirl.create :order, customer: other_user, status: 'confirmed', package_delivery: delivery }
          it { should permit_action :pay }
        end
        context 'na betaling' do
          let(:order) { FactoryGirl.create :order, customer: other_user, status: 'paid', package_delivery: delivery }
          it { should permit_action :success }
        end
      end
      context 'op zichzelf' do
        it { should permit_action :empty }
        it { should permit_action :check_out }
        context 'na toevoeging adres' do
          let(:order) { FactoryGirl.create :order, customer: user, status: 'open', package_delivery: delivery }
          it { should permit_action :confirm }
        end
        context 'na confirmatie' do
          let(:order) { FactoryGirl.create :order, customer: user, status: 'confirmed', package_delivery: delivery }
          it { should permit_action :pay }
        end
        context 'na betaling' do
          let(:order) { FactoryGirl.create :order, customer: user, status: 'paid', package_delivery: delivery }
          it { should permit_action :success }
        end
      end

    end
  end
end
