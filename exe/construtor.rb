class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
 
  def check
    puts "Instância da classe iniciada com os valores:"
    puts "Nome = #{@name}"
    puts "Idade = #{@age}"
  end
 end
 
 person = Person.new('João', 12)
 person.check

# Person.new('João', 12).check ##Substitua as duas últimas linhas do programa por