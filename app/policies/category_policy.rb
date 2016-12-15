class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    create?
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

  def admin_action?
   create?
  end 
end
