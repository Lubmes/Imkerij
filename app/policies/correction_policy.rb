class CorrectionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.try(:admin)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end