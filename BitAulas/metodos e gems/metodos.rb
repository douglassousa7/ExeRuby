# Tópicos da nossa aula
# *O que são métodos?
# Método é uma forma de organizar funções específicas em um programa.  E ele 
#permite a reutilização de código, ou seja, evita escrever o mesmo código diversas vezes.

#*******************************************************************************

# **Criando métodos.
# Para definir o método:
# 1. utlizamos a palavra def
# 2. Seguida do nome do método (escolhido por você)
# 3. Na sequência definimos um conjunto de expressões
# 4. para finalizar esse bloco use a palavra end
# 5. para executar o método basta escrever seu nome

# def oi 
#   puts 'Oi dev!'
# end
# oi
# oi
# oi
# oi

#*********************************************************************************
# ***Entendendo o que são parâmetros e usando.
# Um método pode depender de um ou mais parâmetros
# Como?
# Ao lado do método que você criou defina os parâmetros (o que deverá aparecer)
# def (nome do método) (parâmetro1, parametro2)

# def nome (nome, sobrenome)
#  puts "Oi #{nome} #{sobrenome}, você é um Dev em Ruby!"
# end

# nome = 'Tenille'
# sobrenome = 'Martins'


# nome(nome, sobrenome)
# nome(nome, sobrenome)
# nome(nome, sobrenome)



#***********************************************************************************
# ****Entendendo e usando return (retorno)
# o return sempre resulta sua última instrução

#Exemplos chatGpt

# def saudacao(nome)
#   puts "Olá, #{nome}!"
# end

# saudacao("Douglas") # => "Olá, Douglas!"
# saudacao("Maria")   # => "Olá, Maria!"

#ex2

# def soma(a, b)
#   resultado = a + b
#   return resultado
# end

# puts soma(3, 4) # => 7



#exemplo 3 usando o #return

# def multiplica_por_dois(numero)
#   return numero * 2
# end

# puts multiplica_por_dois(5) # => 10


#exe

def divide(a, b)
  return "Divisão por zero não é permitida!" if b == 0
  a / b
end

puts divide(10, 2) # => 5
puts divide(10, 0) # => "Divisão por zero não é permitida!"
