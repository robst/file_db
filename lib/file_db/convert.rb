module FileDb
  module Convert

    def to_csv
      self.class.columns.inject([]) do |csv, column|
        csv << send(column)
      end
    end
  end

end
