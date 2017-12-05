module PGArrayPatch
  refine Array do
    def to_pg_sql
      "{#{sort.map { |e| ActiveRecord::Base.connection.quote(e) }.join(',')}}"
    end
  end
end
