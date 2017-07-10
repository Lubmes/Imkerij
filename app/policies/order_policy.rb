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
    (guest_user || (customers_own_domain_only && bookable_order)) && !all_ready_empty && !record.confirmed?
  end

  def check_out?
    (guest_user || (user && bookable_order)) && !all_ready_empty && !record.confirmed?
  end

  def confirm?
    user && bookable_order && sendable_order && !all_ready_empty
  end

  def pay?
    user && record.confirmed? && sendable_order && !all_ready_empty
  end

  def success?
    user && record.paid? && sendable_order
  end

  private

  def all_ready_empty
    record.total_price == 0
  end

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
