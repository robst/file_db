$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'timecop'
require 'file_db'

RSpec.configure do |config|
  config.before(:suite) do
    class User < FileDb::Model
      columns :name, :test
    end
    FileDb::Configuration.configure data_directory: 'data'
    FileDb::Database.database_check!
    time = Time.local(2013, 12, 11, 11, 28, 0)
    Timecop.travel time
    User.create name: 'max', test: 'test'
    User.create name: 'tester', test: 'tests'
  end

  config.after(:suite) do
    Timecop.return
    File.delete File.join(
      FileDb::Configuration.configured(:data_directory),
      "#{User.table_name}.csv"
    )
    Dir.delete(FileDb::Configuration.configured :data_directory)
  end
end
