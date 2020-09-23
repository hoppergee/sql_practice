require 'minitest/autorun'
require 'byebug'
require 'mysql2'
require 'pathname'
require 'erb'

class Base < Minitest::Test
  class << self
    attr_accessor :_current_folder

    def inherited(klass)
      file_location = caller_locations.first.absolute_path
      klass._current_folder = Pathname.new(file_location).dirname
      super
    end
  end

  def setup
    build_database
    build_table
    insert_data
  end

  private

  def result
    query_sql = File.read(path_of_query_sql_file)
    result = query(query_sql)
    result.map{ |line| line.values.join(' ') }.join("\n")
  end

  def expect_result
    File.read(path_of_expect_file)
  end

  def path_of_query_sql_file
    @path_of_query_sql_file ||= Pathname.new(dir_path).join('query.sql')
  end

  def path_of_expect_file
    @path_of_expect_file ||= Pathname.new(dir_path).join('expect.txt')
  end

  def build_database
    connection.query('DROP DATABASE if exists hackerrank')
    connection.query('CREATE DATABASE hackerrank')
  end

  def build_table
    build_sql_path = Pathname.new(dir_path).join('build.sql')
    build_sql = File.read(build_sql_path)
    query(build_sql)
    client.next_result while @client.more_results?
  end

  def insert_data
    Pathname.new(dir_path).glob('*.csv').each do |csv_path|
      insert_one_table_data(csv_path.basename('.csv'))
    end
  end

  def insert_one_table_data(table_name)
    build_insert_sql = ERB.new <<~INSERT_SQL
      load data infile '<%= path_of_csv %>'
      into table <%= table_name %>
      fields terminated by ','
      enclosed by '"'
      lines terminated by '\n'
      ignore 1 rows;
    INSERT_SQL
    table_name = table_name
    path_of_csv = Pathname.new(dir_path).join("#{table_name}.csv")
    insert_sql = build_insert_sql.result(binding)

    query(insert_sql)
  end

  def dir_path
    self.class._current_folder
  end

  def connection
    @connection ||= Mysql2::Client.new(
      host: 'mysql',
      username: 'root',
      flags: Mysql2::Client::MULTI_STATEMENTS
    )
  end

  def client
    @client ||= Mysql2::Client.new(
      host: 'mysql',
      username: 'root',
      database: 'hackerrank',
      flags: Mysql2::Client::MULTI_STATEMENTS
    )
  end

  def query(sql)
    client.query(sql)
  end
end
