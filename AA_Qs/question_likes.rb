require 'sqlite3'
require_relative 'questions_db.rb'

class Question_likes
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM Question_likes")
    data.map { |datum| Question_likes.new(datum) }
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
        question_likes (id, user_id, question_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update 
    raise "#{self} already in database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @id, @user_id, @question_id)
      UPDATE 
        question_likes
      SET 
        user_id = ?, question_id = ?
      VALUES
        id = ?
    SQL
  end

end