puts "Escreva seu nome: "
nome = gets.chomp 
puts "Digite sua idade: "
idade = gets.chomp.to_i
if idade >= 18
   puts " #{nome} esta apto a tirar a habiltação"
else 
  puts " #nome, você não está apto a tirar a habilitação"
end 