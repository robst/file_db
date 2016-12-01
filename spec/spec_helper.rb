$LOAD_PATH.unshift File.expand_path('../../lib/*', __FILE__)

require 'file_db'

RSpec.configure do |config|
  config.before(:suite) do
    FileDb::Configuration.configure data_directory: 'data'

    class User < FileDb::Model
      columns :name, :test
    end

    User.create name: 'max', test: 'test'
    User.create name: 'tester', test: 'tests'
  end

  config.after(:suite) do
    FileDb::DatabaseManager.instance.drop_database!
  end
end
