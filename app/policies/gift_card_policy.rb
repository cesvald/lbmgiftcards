class GiftCardPolicy < ApplicationPolicy

  class Scope < ApplicationPolicy::Scope

    def resolve
      if user.admin?
        scope.all
      elsif user.regular?
        scope.where(user: user)
      end
    end

  end

  def redeem?
    update?
  end

  def invalidate?
    update?
  end
  
  def fisical?
    update?
  end

  def permitted_attributes
    [:code, :value]
  end
end