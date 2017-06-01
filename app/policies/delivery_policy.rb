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
    create? && record.editable?
  end

  def update?
    edit?
  end

  def destroy?
    false
  end
end
