#Globais: Pode ser acessad de qualquer lugar do pŕograma.
#Forma: Use o prefixo $ 
# USO DESENCORAJADA 



#CLASSE: Pode ser acessada de qualquer lugar da classe
#FORMa: @ 


#INSTANCIA: Semelhante a de classe
#Forma: @
#
#
#Teste 1
#teste visionamento 

class Usuario
  @@usuario_count = 0
  def add(name)
    puts "Usuário #{name} adicionado"
    @@usuario_count += 1
    puts @@usuario_count
  end
 end
  
 first_user = Usuario.new
 first_user.add('Tenille')
  
 second_user = Usuario.new
 second_user.add('Paulo')

