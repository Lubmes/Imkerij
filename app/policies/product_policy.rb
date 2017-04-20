class ProductPolicy < CategoryPolicy
  def permitted_attributes
    if user.admin?
      [ :name, :description, :price, :sales_tax,
        :mail_weight, :content_weight, :content_volume,
        :available, :category_id ]
    end
  end

  class Scope < Scope
    def resolve
      if user.try(:admin)
        scope.all
      else
        scope.where(available: true)
      end
    end
  end

  # Erft over van category policy
end
