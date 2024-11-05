#Globais: Pode ser acessad de qualquer lugar do pŕograma.
#Forma: Use o prefixo $ 
# USO DESENCORAJADA 



#CLASSE: Pode ser acessada de qualquer lugar da classe
#FORMa: @ 


#INSTANCIA: Semelhante a de classe
#Forma: @

class Usuario
  def add(nome)
    @nome = nome
    puts "Usuário adicionado"
    ola
  end
  
  def ola
    puts "Seja bem vindo(a), #{@nome}!"
  end
 end
  
 usuario = Usuario.new
 usuario.add('Tenille')