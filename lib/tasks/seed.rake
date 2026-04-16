namespace :db do
  namespace :seed do
    desc "Truncate app data and run db:seed"
    task reset: :environment do
      connection = ActiveRecord::Base.connection
      excluded_tables = %w[schema_migrations ar_internal_metadata]
      tables = connection.tables - excluded_tables

      if tables.empty?
        puts "No tables to truncate. Running db:seed..."
      else
        quoted_tables = tables.map { |table| connection.quote_table_name(table) }.join(", ")
        connection.execute("TRUNCATE TABLE #{quoted_tables} RESTART IDENTITY CASCADE")
        puts "Truncated #{tables.size} tables."
      end

      puts "Running db:seed..."
      success = system("bin/rails db:seed")
      raise "db:seed failed during reset" unless success

      puts "db:seed:reset complete."
    end
  end
end
