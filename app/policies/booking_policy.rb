class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    record.product.available == true
  end

  def update?
    user == record.order.customer
  end

  def destroy?
    user == record.order.customer
  end
end
