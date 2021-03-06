class PicturePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.try(:admin)
  end

  def destroy?
    user.try(:admin)
  end
end
