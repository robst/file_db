module FileDb
  class Model
    extend FileDb::Columns
    extend FileDb::Table
    extend FileDb::Query
    include FileDb::Data
  end
end
