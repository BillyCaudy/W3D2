require 'sqlite3'
require_relative 'questions_db.rb'

class Users
  attr_accessor :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @fname, @lname)
      INSERT INTO
        users (id, fname, lname)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update 
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @fname, @lname)
      UPDATE 
        users
      SET 
        fname = ?, lname = ?
      VALUES
        id = ?
    SQL
  end

end