class EnableUuidExtensions < ActiveRecord::Migration[6.1]
  def up
    execute 'CREATE EXTENSION IF NO EXISTS "uuis-ossp"'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS "uuid-ossp"'
  end
end