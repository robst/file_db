module FileDb
  class Model
    extend FileDb::Columns
    extend FileDb::Table
    extend FileDb::Query
    include FileDb::Data

    extend FileDb::Filter::ClassMethods
    include FileDb::Filter::InstanceMethods
  end
end
