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
    admins_only
  end

  def pdf?
    user
  end

  def refund?
    admins_only
  end

  def problem?
    admins_only
  end

  def print?
    admins_only
  end

  def sent_out?
    admins_only
  end
end
