# #cria um array (lista) baseado em um outro array(lista) existente

numeros = [2,3,4,5]
 
# .map não altera o conteúdo do array original
  # novo_numeros = numeros.map do |x| 
  #            x * 5
  #           end
 
  # puts "\n Array Original" #\n -> pular uma linha
  # puts " #{numeros}"
 
  # puts "\n Novo Array"
  # puts " #{novo_numeros}"
 

# .map! força que o conteúdo do array original seja alterado 
# numeros.map! do |x| 
#   x * 5
#  end
 
#  puts "\n Array Original"
#  puts " #{numeros}"
#  puts ''



#Explos de uso de MAP pelo chatpt:

# nomes = ["Alice", "Bob", "Ronaldinho"]
# cumprimentos = nomes.map do |nome|
#   "Olá, #{nome}!"
# end

# puts cumprimentos # => ["Olá, Alice!", "Olá, Bob!", "Olá, Carol!"]

#ex 2:

numeros = [1, 2, 3, 4, 5]
quadrados = numeros.map do |numero|
  numero ** 2
end

puts quadrados # => [1, 4, 9, 16, 25]
