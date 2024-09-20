# Definindo a classe Animal
class Animal
  def initialize
    puts "Um novo animal foi criado!"
  end
end

# Definindo a classe Gato, que herda de Animal
class Gato < Animal
  def miar
    puts 'miau'
  end
end

# Criando uma instância da classe Gato e chamando o método miar
gato = Gato.new
gato.miar
