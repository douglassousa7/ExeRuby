# hello_proc = proc do |msg|
#   puts msg
# end 

  hello_proc.call 

 hello_lambda = lambda do |msg|
   puts msg 
 end    
 
   hello_lambda.call

  # se voce tntar executar o promeiro 
  # codigo (com proc) verá que a saída é uma linha vazia, 
  # pois o parêmetro "msg" não foi passado.
  # assim, podemos ver que procs automaticamente atribuem "nill"
  # para variaves cujo valor não tenha sido definido.

  # já o segundo código (com lamnda) lançará uma exceção
  # "ArgumetErro: wrong number of arguments (0 for 1)"!