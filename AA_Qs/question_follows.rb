require 'sqlite3'
require_relative 'questions_db.rb'

class Question_follows
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM Question_follows")
    data.map { |datum| Question_follows.new(datum) }
  end

  def self.followers_for_question_id(q_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        users.fname, users.lname
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_id = ?
    SQL
    data.map { |datum| Question_follows.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @user_id, @question_id)
      INSERT INTO
        question_follows (id, user_id, question_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update 
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @user_id, @question_id)
      UPDATE 
        question_follows
      SET 
        user_id = ?, question_id = ?
      VALUES
        id = ?
    SQL
  end

end