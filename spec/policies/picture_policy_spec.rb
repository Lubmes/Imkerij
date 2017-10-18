require 'rails_helper'

RSpec.describe PicturePolicy do
  context 'toegang' do
    subject { PicturePolicy.new(user, picture) }
    let(:picture) { build :picture }

    context 'voor anonieme gebruikers' do
      let(:user) { nil }

      it { should forbid_action :destroy }
    end

    context "voor willekeurige gebruikers" do
      let(:user) { FactoryGirl.create :user }

      it { should forbid_action :destroy }
    end

    context 'voor administrators' do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :destroy }
    end
  end
end
