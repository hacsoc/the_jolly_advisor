json.array!(@users) do |user|
  json.extract! user, :id, :case_id, :name, :type, :class_year
  json.url user_url(user, format: :json)
end
