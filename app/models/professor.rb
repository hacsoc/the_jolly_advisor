class Professor < ActiveRecord::Base
  class << self
    def TBA
      where(name: "TBA").first_or_create
    end
  end

  has_many :course_instances, dependent: :destroy

  scope :order_by_realness, -> { order('CASE WHEN("name" = \'Staff\' OR "name" = \'TBA\') THEN 1 ELSE 0 END') }
end
