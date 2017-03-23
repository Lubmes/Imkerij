class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit?
    user.try(:admin)
  end

  def update?
    edit?
  end
end
