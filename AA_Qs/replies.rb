require 'sqlite3'
require_relative 'questions_db.rb'

class Replies
  attr_accessor :body, :user_id, :question_id, :parent_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum) }
  end

  def self.child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT 
        *
      FROM
        replies
      WHERE
        parent_id IS NOT NULL
    SQL
    data.map { |datum| Replies.new(datum) }
  end


  def initialize(options)
    @id = options['id']
    @body = options['body']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @body, @user_id, @questions_id, @parent_id)
      INSERT INTO
        replies (id, body, user_id, questions_id, parent_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update 
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id,  @body, @user_id, @questions_id, @parent_id)
      UPDATE 
        replies
      SET 
        body = ?, user_id = ?, questions_id = ?, parent_id = ?
      VALUES
        id = ?
    SQL
  end

end