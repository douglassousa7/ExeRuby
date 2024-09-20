# Inicializa um hash vazio
hash = {}

# Solicita ao usuário 3 pares de chave-valor
3.times do |i|
  puts "Digite a chave do elemento #{i+1}:"
  chave = gets.chomp
  puts "Digite o valor para a chave '#{chave}':"
  valor = gets.chomp
  hash[chave] = valor
end

# Exibe as chaves e valores
hash.each do |chave, valor|
  puts "Uma das chaves é #{chave} e o seu valor é #{valor}"
end
