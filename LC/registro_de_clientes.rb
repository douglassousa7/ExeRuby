# clientes = {
#   1 => {nome: "lucas", data_de_cadastro: "25/08/2013", cidade: "Rio de janeiro-Rj" },
#   2 => {nome: "Pedro", data_de_cadastro: "15/08/2010", cidade: "Minas Gerais-mg" },

# }

# id_do_cliente = ARGV.first.to_i

# puts "buscando informações do cliente ##{id_do_cliente}..."
# sleep 3 # segundos 

#  cliente = clientes[id_do_cliente]

#  puts "Nome: #{cliente [:nome]}"
#  puts "Data de cadastro: #{cliente [:data_de_cadastro ]}"
#  puts "Cidade: #{cliente [:cidade]}"
#  puts
#  puts "Programa finalizado"






 clientes = {
  1 => { nome: "lucas", data_de_cadastro: "25/08/2013", cidade: "Rio de Janeiro-RJ" },
  2 => { nome: "Pedro", data_de_cadastro: "15/08/2010", cidade: "Minas Gerais-MG" }
}

id_do_cliente = ARGV.first.to_i

puts "Buscando informações do cliente ##{id_do_cliente}..."
sleep 3 # segundos 

cliente = clientes[id_do_cliente]

if cliente
  puts "Nome: #{cliente[:nome]}"
  puts "Data de cadastro: #{cliente[:data_de_cadastro]}"
  puts "Cidade: #{cliente[:cidade]}"
else
  puts "Cliente não encontrado."
end

puts "Programa finalizado."