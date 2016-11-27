$LOAD_PATH.unshift File.expand_path('../../lib/*', __FILE__)

require 'file_db'

RSpec.configure do |config|
  config.before(:suite) do
    class User < FileDb::Model
      columns :name, :test
    end
    FileDb::Configuration.configure data_directory: 'data'
    FileDb::System::Check.run!
    User.create name: 'max', test: 'test'
    User.create name: 'tester', test: 'tests'
  end

  config.after(:suite) do
    File.delete File.join(
      FileDb::Configuration.configured(:data_directory),
      "#{User.table_name}.csv"
    )
    Dir.delete(FileDb::Configuration.configured :data_directory)
  end
end
