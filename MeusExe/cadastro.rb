# Programa de cadastro básico
NOME_SISTEMA = "Cadastro 1.0"

def adicionar_pessoa(lista)
  puts "Digite o nome:"
  nome = gets.chomp
  puts "Digite a idade:"
  idade = gets.chomp.to_i
  
  pessoa = { nome: nome, idade: idade }
  lista << pessoa
  yield(pessoa) if block_given?  # Executa bloco se passado
end

pessoas = []  # Array vazio

# Adiciona uma pessoa
adicionar_pessoa(pessoas) do |p|
  puts "Adicionado: #{p[:nome]} com #{p[:idade]} anos!"
end

# Mostra todas as pessoas
for pessoa in pessoas
  case pessoa[:idade]
  when 0..17
    puts "#{pessoa[:nome]} é menor de idade."
  when 18..100
    puts "#{pessoa[:nome]} é maior de idade."
  else
    puts "Idade estranha para #{pessoa[:nome]}!"
  end
end