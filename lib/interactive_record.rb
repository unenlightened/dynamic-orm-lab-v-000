require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    sql = "PRAGMA table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []

    table_info.each{|column| column_names << column["name"]}

    column_names.compact
  end

  def attr_accessor
    self.column_names.each {|col_name| attr_accessor col_name.to_sym}
  end

  def initialize(properties={})
    properties.each {|property, value| self.send("#{property}=", value)}
  end

 def table_name_for_insert
   self.class.table_name
 end

 def col_names_for_insert
   self.class.column_names.delete("id").join(', ')
 end

 def values_for_insert
   values = []

   self.class.column_names.each do |col_name|
     values << "'#{send(col_name)}'" unless send(col_name).nil?
   end

   values.join(', ')
 end

 def save
   sql <<-SQL
     INSERT INTO #{table_name_for_insert} #{col_names_for_insert}
     VALUES #{values_for_insert}
   SQL

   DB[:conn].execute(sql)

   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
 end

 def self.find_by_name(name)
   sql = "SELECT * FROM students WHERE name = #{name}?"
    DB[:conn].execute(sql)
 end

 def self.find_by(attribute)
   sql = "SELECT * FROM students WHERE name = #{name}?"
    DB[:conn].execute(sql)

 end



end
