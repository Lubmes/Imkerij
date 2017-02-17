class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user
  end

  def update?
    user.try(:admin)
  end

  def pdf?
    user
  end

  def print?
    admins_only
  end
end
