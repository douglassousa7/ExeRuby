class Produto
  attr_reader :fabricante 
  attr_writer :preco
  attr_accessor :nome

  def initialize
    @fabricate = 'Aplle'
    @codigo = 1234
  end
end

celular = Produto.new 
# celular.fabricante = "lg" #tentando chamar o setter (x)
puts celular.fabricante #tentando chamar o getter

