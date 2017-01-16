class DeliveryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.try(:admin) || user == record.sender
  end

  def destroy?
    create?
  end
end
