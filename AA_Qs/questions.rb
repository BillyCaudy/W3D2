require 'sqlite3'
require_relative 'questions_db.rb'

class Questions
  attr_accessor :title, :body, :author_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def self.find_by_author(a_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, a_id)
      SELECT 
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    data.map { |datum| Questions.new(datum) }
  end


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @title, @body, @author_id)
      INSERT INTO
        questions (id, title, body, author_id)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update 
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @title, @body, @author_id)
      UPDATE 
        questions
      SET 
        title = ?, body = ?, author_id = ?
      VALUES
        id = ?
    SQL
  end

end