class User < ActiveRecord::Base
  def to_s
    case_id
  end
end
