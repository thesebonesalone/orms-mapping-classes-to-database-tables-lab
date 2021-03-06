class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students ( id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )
    SQL
    runner(sql)
  end
  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    runner(sql)
  end
  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    sql = <<-SQL
    SELECT * FROM students ORDER BY id DESC LIMIT 1
    SQL
    @id = DB[:conn].execute(sql)[0][0]
  end
  def self.create(attributes)
    new_student = self.new(attributes[:name], attributes[:grade])
    new_student.save
    new_student
  end


end

def runner(sql)
  DB[:conn].execute(sql)
end