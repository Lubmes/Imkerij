require 'rails_helper'

RSpec.describe ProductPolicy do
  context 'permissions' do
    subject { ProductPolicy.new(user, product) }
  
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }
    let(:product) { FactoryGirl.create :product,
                                        category: category }

    context 'for anonymous users' do
      let(:user) { nil }

      it { should_not permit_action :create }
      it { should_not permit_action :update }
      it { should_not permit_action :destroy }
    end

    context "for random users" do
      let(:random_user) { FactoryGirl.create :user }

      it { should_not permit_action :create }
      it { should_not permit_action :update }
      it { should_not permit_action :destroy }
    end

    context 'for admins' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :create }
      it { should permit_action :update }
      it { should permit_action :destroy }
    end
  end
end