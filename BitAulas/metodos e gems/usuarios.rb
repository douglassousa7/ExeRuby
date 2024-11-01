# Importa a gem Faker
require 'faker'

# Configura Faker para gerar dados em português brasileiro
Faker::Config.locale = 'pt-BR'

# Define a quantidade de perfis que queremos gerar
quantidade_de_usuarios = 5

# Exibe o cabeçalho da lista
puts "Perfis de Usuários Gerados:\n\n"

# Gera cada perfil e exibe no terminal
quantidade_de_usuarios.times do
  nome = Faker::Name.name
  email = Faker::Internet.email
  cidade = Faker::Address.city
  profissao = Faker::Job.title

  puts "Nome: #{nome}"
  puts "Email: #{email}"
  puts "Cidade: #{cidade}"
  puts "Profissão: #{profissao}"
  puts "-" * 20 # Linha de separação entre perfis
end
