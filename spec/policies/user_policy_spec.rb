# require 'rails_helper'

# RSpec.describe ProductPolicy do
#   context 'permissions' do
#     subject { ProductPolicy.new(user, product) }
  
#     let(:user) { FactoryGirl.create :user }
#     let(:product) { FactoryGirl.create :product }

#     context 'for anonymous users' do
#       let(:user) { nil }

#       it { should_not permit_action : }
#       it { should_not permit_action : }
#     end

#     context "for random users" do
#       let(:random_user) { FactoryGirl.create :user }

#       it { should_not permit_action : }
#       it { should_not permit_action : }
#     end

#     context 'for admins' do
#       let(:user) { FactoryGirl.create :user, :admin }

#       it { should permit_action : }
#       it { should permit_action : }
#     end
#   end
# end