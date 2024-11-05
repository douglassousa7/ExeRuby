#Globais: Pode ser acessad de qualquer lugar do pŕograma.
#Forma: Use o prefixo $ 
# USO DESENCORAJADA 



#CLASSE: Pode ser acessada de qualquer lugar da classe
#FORMa: @ 


#INSTANCIA: Semelhante a de classe
#Forma: @




class Teste
  def global
    $global = 0
    puts $global
  end
 end
  
 class Teste_2
  def outro_global
    $global += 1
    puts $global
  end
 end
 
 teste = Teste.new
 teste_2 = Teste_2.new
 teste.global
 teste_2.outro_global
 puts $global