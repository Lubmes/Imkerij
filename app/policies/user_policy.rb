class UserPolicy < ApplicationPolicy
  def permitted_attributes
    if user.admin? && user != record
      [:email, :password, :first_name, :last_name, :address_street_name, :address_street_number, :address_zip_code, :address_city, :address_country, :admin]
    else
      [:email, :password, :first_name, :last_name, :address_street_name, :address_street_number, :address_zip_code, :address_city, :address_country]
    end
  end

  class Scope < Scope
    def resolve
      if user.try(:admin)
        scope = User.all
        scope = scope.where.not(first_name: 'guest')
      elsif user.nil?
        scope = []
      else
        scope = User.where(id: user.id)
      end
    end
  end

  def index?
    user.try(:admin)
  end

  def show?
    user.try(:admin) || user == record
  end

  def create?
    user.try(:admin)
  end

  def edit?
    user.try(:admin) || user == record
  end

  def update?
    user.try(:admin) || user == record
  end

  def destroy?
    # user.try(:admin) && user != record
    false
  end
end
