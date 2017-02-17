class DeliveryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.try(:admin) || user
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    false
  end
end
