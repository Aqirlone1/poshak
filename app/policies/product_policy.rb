class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.active? || user&.admin?
  end

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  def toggle_active?
    update?
  end

  def toggle_featured?
    update?
  end

  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.active
    end
  end
end
