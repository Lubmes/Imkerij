class DashboardPolicy < Struct.new(:user, :dashboard)
  def show?
    user.try(:admin)
  end  
end
