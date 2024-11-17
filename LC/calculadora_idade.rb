# ano_de_nas = ARGV.first.to_i
# idade = Time.now.year - ano_de_nas
# puts "sua idadade é #{idade} anos"

puts "Digite ano de nascimento: "
anoN = gets.chomp.to_i 

puts "Digite o ano atual: "
ano = gets.chomp.to_i

idade = anoN-ano 
puts "Sua idade é #{idade}"