class OrderPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user&.admin? || record.user_id == user&.id
  end

  def update_status?
    user&.admin?
  end

  def cancel?
    (record.user_id == user&.id || user&.admin?) && record.cancellable?
  end

  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.where(user_id: user&.id)
    end
  end
end
