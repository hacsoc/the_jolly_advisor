module ProfessorsHelper
  def professor_search_link(professor)
    link_to professor.name, courses_path(professor: professor.name)
  end
end
