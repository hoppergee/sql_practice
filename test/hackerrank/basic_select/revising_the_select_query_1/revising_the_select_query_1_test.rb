require 'minitest/autorun'
require 'byebug'
require 'mysql2'
require 'pathname'
require 'erb'

class RevisingTheSelectQuery1Test < Minitest::Test
  def setup
    @connection = Mysql2::Client.new(
      host: 'localhost',
      username: 'root',
      flags: Mysql2::Client::MULTI_STATEMENTS
    )

    @client = Mysql2::Client.new(
      host: 'localhost',
      username: 'root',
      database: 'hackerrank',
      flags: Mysql2::Client::MULTI_STATEMENTS
    )
  end

  def test_a
    @connection.query('DROP DATABASE hackerrank')
    @connection.query('CREATE DATABASE hackerrank')

    dir_path = File.expand_path(__dir__)
    build_sql_path = Pathname.new(dir_path).join('build.sql')
    build_sql = File.read(build_sql_path)
    @client.query(build_sql)
    @client.next_result while @client.more_results?

    build_insert_sql = ERB.new <<~INSERT_SQL
      load data infile '<%= path_of_csv %>'
      into table city
      fields terminated by ','
      enclosed by '"'
      lines terminated by '\n'
      ignore 1 rows;
    INSERT_SQL
    path_of_csv = Pathname.new(dir_path).join('city.csv')
    insert_sql = build_insert_sql.result(binding)

    @client.query(insert_sql)

    path_of_query_sql_file = Pathname.new(dir_path).join('query.sql')
    query_sql = File.read(path_of_query_sql_file)
    result = @client.query(query_sql)
    result = result.map{ |line| line.values.join(' ') }.join("\n")

    path_of_expect_file = Pathname.new(dir_path).join('expect.txt')
    expect_result = File.read(path_of_expect_file)

    assert_equal result, expect_result
  end

end
