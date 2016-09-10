require 'rails_helper'

RSpec.describe CategoryPolicy do
  context 'toegang' do
    subject { CategoryPolicy.new(user, category) }
  
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }

    context 'voor anonieme gebruikers' do
      let(:user) { nil }

      it { should_not permit_action :create }
      it { should_not permit_action :update }
      it { should_not permit_action :destroy }
    end

    context "voor willekeurige gebruikers" do
      let(:random_user) { FactoryGirl.create :user }

      it { should_not permit_action :create }
      it { should_not permit_action :update }
      it { should_not permit_action :destroy }
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :create }
      it { should permit_action :update }
      it { should permit_action :destroy }
    end
  end
end