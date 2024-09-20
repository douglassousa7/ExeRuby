# Hash fornecido
numbers = {a: 10, b: 30, c: 20, d: 25, e: 15}

# Seleciona o par chave-valor com o maior valor
maior_par = numbers.max_by { |chave, valor| valor }

# Exibe o resultado
puts "A chave com o maior valor é #{maior_par[0]} e o valor é #{maior_par[1]}"
