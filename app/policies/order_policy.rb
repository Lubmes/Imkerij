class OrderPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.try(:admin)
        scope = Order.all
        # scope = scope.where.not(status: 'open') # unless order van zichzelf
      elsif user.nil?
        scope = []
      else
        scope = Order.where(customer_id: user.id)
      end
    end
  end

  def empty?
    guest_user || (customers_own_domain_only && bookable_order)
  end

  def check_out?
    guest_user || (user && bookable_order)
  end

  def confirm?
    user && bookable_order && sendable_order
  end

  def pay?
    user && record.status == 'confirmed' && sendable_order
  end

  def success?
    user && record.status == 'paid' && sendable_order
  end

  private

  def guest_user
    user == nil
  end

  def bookable_order
    record.bookable?
  end

  def sendable_order
    record.package_delivery != nil
  end

  def customers_own_domain_only
    user && user == record.customer
  end
end
