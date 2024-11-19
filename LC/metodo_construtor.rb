# class Pessoa
#   def initialize (nome, idade)
#     @nome = nome
#     @idade = idade 
#   end 

#   def exibir_informacoes
#     puts "#{@nome} tem #{@idade} anos."
#   end
# end

# pessoa = Pessoa.new('Joana', 45)
# pessoa.exibir_informacoes



# exe 2


# class Pessoa
#   def initialize(nome, idade)
#     @nome = nome  # Variável de instância
#     @idade = idade
#   end

#   def apresentar
#     puts "Olá, meu nome é #{@nome} e tenho #{@idade} anos."
#   end
# end

# pessoa1 = Pessoa.new("Douglas", 25)
# pessoa1.apresentar
# # Saída: Olá, meu nome é Douglas e tenho 25 anos.




# ex 3


# class Contador
#   def initialize
#     @contagem = 0
#   end

#   def incrementar
#     @contagem += 1
#   end

#   def mostrar
#     puts "Contagem atual: #{@contagem}"
#   end
# end

# contador = Contador.new
# contador.incrementar
# contador.mostrar # Saída: Contagem atual: 1



#exe 4


# class Pessoa
#   def initialize(nome)
#     @nome = nome
#   end

#   def nome
#     @nome
#   end
# end

# pessoa = Pessoa.new("Douglas")
# puts pessoa.nome # Saída: Douglas



# ex 5

#Criados para alterar o valor de uma variável de instância.
#Exemplo:


# class Pessoa
#   def initialize(nome)
#     @nome = nome
#   end

#   def alterar_nome(novo_nome)
#     @nome = novo_nome
#   end

#   def nome
#     @nome
#   end
# end

# pessoa = Pessoa.new("Douglas")
# pessoa.alterar_nome("Carlos")
# puts pessoa.nome # Saída: Carlos



# ex 6
# Uso de attr_accessor, attr_reader e attr_writer:

# Atalhos para criar métodos de leitura e escrita.
# Exemplo com attr_accessor

class Pessoa
  attr_accessor :nome

  def initialize(nome)
    @nome = nome
  end
end

pessoa = Pessoa.new("Douglas")
puts pessoa.nome # Saída: Douglas
pessoa.nome = "Carlos"
puts pessoa.nome # Saída: Carlos
