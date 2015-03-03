module PGArrayPatch
  refine Array do
    def to_pg_sql
      "{#{map { |e| ActiveRecord::Base.sanitize(e) }.join(',')}}"
    end
  end
end
