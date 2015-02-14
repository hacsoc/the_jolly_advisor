class Professor < ActiveRecord::Base
  class << self
    def TBA
      where(name: "TBA").first_or_create
    end
  end
end
