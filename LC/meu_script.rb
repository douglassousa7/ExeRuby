# meu_script.rb
nome = ARGV[0]
idade = ARGV[1]

if nome && idade
  puts "Olá, #{nome}! Você tem #{idade} anos."
else
  puts "Por favor, forneça seu nome e idade ao rodar o programa."
end
