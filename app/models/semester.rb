class Semester < ActiveRecord::Base
  def to_s
    "#{semester} #{year}"
  end
end
