class ProductPolicy < CategoryPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
