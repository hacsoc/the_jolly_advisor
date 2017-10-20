class Professor < ActiveRecord::Base
  # rubocop does not realize this is an acronym and wants it to be snake_case
  # instead.
  #
  # rubocop:disable Style/MethodName
  def self.TBA
    where(name: "TBA").first_or_create
  end

  scope :order_by_realness, -> do
    order('CASE WHEN("name" = \'Staff\' OR "name" = \'TBA\') THEN 1 ELSE 0 END')
  end
end
