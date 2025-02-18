require 'gtk3'

ARQUIVO_TAREFAS = "tarefas.txt"

# Função para carregar as tarefas do arquivo
def carregar_tarefas
  begin
    if File.exist?(ARQUIVO_TAREFAS)
      File.readlines(ARQUIVO_TAREFAS).map do |linha|
        concluida, texto, data = linha.chomp.split("|")
        { concluida: concluida == "true", texto: texto, data: data }
      end
    else
      []
    end
  rescue => e
    puts "Erro ao carregar tarefas: #{e.message}"
    []
  end
end

# Função para salvar as tarefas no arquivo
def salvar_tarefas(tarefas)
  begin
    File.open(ARQUIVO_TAREFAS, "w") do |file|
      tarefas.each do |tarefa|
        file.puts("#{tarefa[:concluida]}|#{tarefa[:texto]}|#{tarefa[:data]}")
      end
    end
  rescue => e
    puts "Erro ao salvar tarefas: #{e.message}"
  end
end

# Criar janela principal
janela = Gtk::Window.new("Gerenciador de Tarefas")
janela.set_size_request(500, 400)
janela.signal_connect("destroy") { Gtk.main_quit }

# Layout vertical
caixa = Gtk::Box.new(:vertical, 10)
caixa.set_border_width(10)

# Campo de entrada de texto
entrada = Gtk::Entry.new
entrada.placeholder_text = "Digite a nova tarefa"

# Campo de entrada para data e hora
entrada_data = Gtk::Entry.new
entrada_data.placeholder_text = "Data e Hora (opcional)"

# Botão para adicionar tarefa
botao_adicionar = Gtk::Button.new(label: "Adicionar Tarefa")

# Lista de tarefas (com Scroll)
modelo_lista = Gtk::ListStore.new(TrueClass, String, String) # Correção aqui
lista_tarefas = Gtk::TreeView.new(modelo_lista)

# Coluna para checkboxes (tarefas concluídas)
renderer_concluida = Gtk::CellRendererToggle.new
coluna_concluida = Gtk::TreeViewColumn.new("Concluída", renderer_concluida, active: 0)
lista_tarefas.append_column(coluna_concluida)

# Coluna para o texto da tarefa
renderer_texto = Gtk::CellRendererText.new
coluna_texto = Gtk::TreeViewColumn.new("Tarefa", renderer_texto, text: 1)
lista_tarefas.append_column(coluna_texto)

# Coluna para a data e hora
renderer_data = Gtk::CellRendererText.new
coluna_data = Gtk::TreeViewColumn.new("Data/Hora", renderer_data, text: 2)
lista_tarefas.append_column(coluna_data)

# Adicionar Scroll à lista de tarefas
scrolled_window = Gtk::ScrolledWindow.new
scrolled_window.set_policy(:automatic, :automatic) # Barras de rolagem automáticas
scrolled_window.add(lista_tarefas)

# Botão para remover tarefa
botao_remover = Gtk::Button.new(label: "Remover Selecionada")

# Botão para editar tarefa
botao_editar = Gtk::Button.new(label: "Editar Tarefa")

# Carregar tarefas na lista
tarefas = carregar_tarefas
tarefas.each do |tarefa|
  iter = modelo_lista.append
  iter[0] = tarefa[:concluida]
  iter[1] = tarefa[:texto]
  iter[2] = tarefa[:data]
end

# Evento para adicionar tarefa
botao_adicionar.signal_connect("clicked") do
  texto = entrada.text.strip
  data = entrada_data.text.strip
  unless texto.empty?
    iter = modelo_lista.append
    iter[0] = false # Tarefa não concluída por padrão
    iter[1] = texto
    iter[2] = data.empty? ? "Sem data" : data
    tarefas << { concluida: false, texto: texto, data: data }
    salvar_tarefas(tarefas)
    entrada.text = "" # Limpa o campo após adicionar
    entrada_data.text = "" # Limpa o campo de data
  end
end

# Evento para remover tarefa
botao_remover.signal_connect("clicked") do
  selecionado = lista_tarefas.selection.selected
  if selecionado
    tarefa = selecionado[1]
    dialog = Gtk::MessageDialog.new(parent: janela,
                                    flags: :modal,
                                    type: :question,
                                    buttons: :yes_no,
                                    message: "Tem certeza que deseja remover a tarefa: #{tarefa}?")
    resposta = dialog.run
    if resposta == Gtk::ResponseType::YES
      modelo_lista.remove(selecionado)
      tarefas.delete_if { |t| t[:texto] == tarefa }
      salvar_tarefas(tarefas)
    end
    dialog.destroy
  end
end

# Evento para editar tarefa
botao_editar.signal_connect("clicked") do
  selecionado = lista_tarefas.selection.selected
  if selecionado
    tarefa = selecionado[1]
    data = selecionado[2]
    dialog = Gtk::MessageDialog.new(parent: janela,
                                    flags: :modal,
                                    type: :question,
                                    buttons: :ok_cancel,
                                    message: "Editar Tarefa")
    entrada_edicao = Gtk::Entry.new
    entrada_edicao.text = tarefa
    entrada_edicao_data = Gtk::Entry.new
    entrada_edicao_data.text = data
    dialog.content_area.pack_start(entrada_edicao, expand: true, fill: true, padding: 5)
    dialog.content_area.pack_start(entrada_edicao_data, expand: true, fill: true, padding: 5)
    dialog.show_all
    resposta = dialog.run
    if resposta == Gtk::ResponseType::OK
      novo_texto = entrada_edicao.text.strip
      nova_data = entrada_edicao_data.text.strip
      unless novo_texto.empty?
        selecionado[1] = novo_texto
        selecionado[2] = nova_data.empty? ? "Sem data" : nova_data
        tarefa_index = tarefas.index { |t| t[:texto] == tarefa }
        tarefas[tarefa_index][:texto] = novo_texto
        tarefas[tarefa_index][:data] = nova_data
        salvar_tarefas(tarefas)
      end
    end
    dialog.destroy
  end
end

# Evento para marcar/desmarcar tarefa como concluída
renderer_concluida.signal_connect("toggled") do |renderer, path|
  iter = modelo_lista.get_iter(path)
  iter[0] = !iter[0] # Alterna entre true/false
  tarefa = iter[1]
  tarefa_index = tarefas.index { |t| t[:texto] == tarefa }
  tarefas[tarefa_index][:concluida] = iter[0]
  salvar_tarefas(tarefas)
end

# Adicionar widgets ao layout
caixa.pack_start(entrada, expand: false, fill: false, padding: 5)
caixa.pack_start(entrada_data, expand: false, fill: false, padding: 5)
caixa.pack_start(botao_adicionar, expand: false, fill: false, padding: 5)
caixa.pack_start(scrolled_window, expand: true, fill: true, padding: 5)
caixa.pack_start(botao_remover, expand: false, fill: false, padding: 5)
caixa.pack_start(botao_editar, expand: false, fill: false, padding: 5)

# Adicionar layout à janela e exibir
janela.add(caixa)
janela.show_all
Gtk.main