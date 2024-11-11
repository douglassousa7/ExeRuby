#serve para incluir funcionalidades extras as classe, parece muito com herença, mas
#podemos "herdar" de varios lugares

module ImpressaoDecorada
  def imprimir text 
    decoracao =  '#' * 20
    puts decoracao
    puts text
    puts decoracao
  end 
end 

module Pernas   
     include ImpressaoDecorada

     def chute_frontal
        imprimir 'chute frontal'
     end  

     def chute_lateral
        imprimir 'chute lateral'
     end
end 

module Bracos   
  include ImpressaoDecorada

  def jab_de_direita
     imprimir 'jab de direita'
  end  

  def jab_de_esquerda
     imprimir 'chute lateral'
  end

  def gancho
    imprimir 'gancho'
  end
end 

class LutadorX  
    include Pernas 
    include Bracos
end 

class LutadorY  
  include Pernas 
  
end 

lutadorx = LutadorX.new
lutadorx.chute_frontal
lutadorx.jab_de_direita

lutadory = LutadorY.new
lutadory.chute_lateral
