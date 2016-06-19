module FileDb
  class Model
    extend FileDb::Query
    include FileDb::Data
    include FileDb::Convert
  end
end
