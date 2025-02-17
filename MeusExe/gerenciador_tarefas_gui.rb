require 'gtk3'

ARQUIVO_TAREFAS = "tarefas.txt"

# Função para carregar as tarefas do arquivo
def carregar_tarefas
  begin
    File.exist?(ARQUIVO_TAREFAS) ? File.read(ARQUIVO_TAREFAS).split("\n") : []
  rescue => e
    puts "Erro ao carregar tarefas: #{e.message}"
    []
  end
end

# Função para salvar as tarefas no arquivo
def salvar_tarefas(tarefas)
  begin
    File.open(ARQUIVO_TAREFAS, "w") { |file| tarefas.each { |tarefa| file.puts(tarefa) } }
  rescue => e
    puts "Erro ao salvar tarefas: #{e.message}"
  end
end

# Criar janela principal
janela = Gtk::Window.new("Gerenciador de Tarefas")
janela.set_size_request(400, 400)
janela.signal_connect("destroy") { Gtk.main_quit }

# Layout vertical
caixa = Gtk::Box.new(:vertical, 10)
caixa.set_border_width(10)

# Campo de entrada de texto
entrada = Gtk::Entry.new
entrada.placeholder_text = "Digite a nova tarefa"

# Botão para adicionar tarefa
botao_adicionar = Gtk::Button.new(label: "Adicionar Tarefa")

# Lista de tarefas (com Scroll)
modelo_lista = Gtk::ListStore.new(String)
lista_tarefas = Gtk::TreeView.new(modelo_lista)

# Coluna da lista
renderer = Gtk::CellRendererText.new
coluna = Gtk::TreeViewColumn.new("Tarefas", renderer, text: 0)
lista_tarefas.append_column(coluna)

# Adicionar Scroll à lista de tarefas
scrolled_window = Gtk::ScrolledWindow.new
scrolled_window.set_policy(:automatic, :automatic) # Barras de rolagem automáticas
scrolled_window.add(lista_tarefas)

# Botão para remover tarefa
botao_remover = Gtk::Button.new(label: "Remover Selecionada")

# Carregar tarefas na lista
tarefas = carregar_tarefas
tarefas.each { |tarefa| iter = modelo_lista.append; iter[0] = tarefa }

# Evento para adicionar tarefa
botao_adicionar.signal_connect("clicked") do
  texto = entrada.text.strip
  unless texto.empty?
    iter = modelo_lista.append
    iter[0] = texto
    tarefas << texto
    salvar_tarefas(tarefas)
    entrada.text = "" # Limpa o campo após adicionar
  end
end

# Evento para remover tarefa
botao_remover.signal_connect("clicked") do
  selecionado = lista_tarefas.selection.selected
  if selecionado
    tarefa = selecionado[0]
    dialog = Gtk::MessageDialog.new(parent: janela,
                                    flags: :modal,
                                    type: :question,
                                    buttons: :yes_no,
                                    message: "Tem certeza que deseja remover a tarefa: #{tarefa}?")
    resposta = dialog.run
    if resposta == Gtk::ResponseType::YES
      modelo_lista.remove(selecionado)
      tarefas.delete(tarefa)
      salvar_tarefas(tarefas)
    end
    dialog.destroy
  end
end

# Adicionar widgets ao layout
caixa.pack_start(entrada, expand: false, fill: false, padding: 5)
caixa.pack_start(botao_adicionar, expand: false, fill: false, padding: 5)
caixa.pack_start(scrolled_window, expand: true, fill: true, padding: 5)
caixa.pack_start(botao_remover, expand: false, fill: false, padding: 5)

# Adicionar layout à janela e exibir
janela.add(caixa)
janela.show_all
Gtk.main