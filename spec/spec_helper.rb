$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'file_db'

RSpec.configure do |config|
  config.before(:suite) do
    class User < FileDb::Model
      columns :name, :test
    end
    FileDb::Configuration.configure data_directory: 'data'
    FileDb::Database.database_check!
    User.create name: 'max', test: 'test'
  end

  config.after(:suite) do
    Dir.delete(FileDb::Configuration.configured :data_directory)
  end
end
