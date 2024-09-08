extends TextureRect

@onready var score_label = $MarginContainer/HBoxContainer/score_label
@onready var counter_label = $MarginContainer/HBoxContainer/counter_label
@onready var popup = $PopupDialog  # Popup de puntuación total

var current_score = 0
var current_count = 60  # Temporizador de 60 segundos

# Contador de puntos y temporizador
func _ready():
	var grid_node = get_parent().get_node("grid")
	grid_node.connect("score_updated", Callable(self, "_on_score_updated"))
	start_timer()

func _on_score_updated(new_score):
	current_score = new_score
	score_label.text = str(current_score)

# Inicia el temporizador
func start_timer():
	counter_label.text = str(current_count)
	get_tree().create_timer(1.0).connect("timeout", Callable(self, "_on_timer_timeout"))

# Actualiza el temporizador
func _on_timer_timeout():
	current_count -= 1
	counter_label.text = str(current_count)
	
	if current_count > 0:
		get_tree().create_timer(1.0).connect("timeout", Callable(self, "_on_timer_timeout"))
	else:
		end_game()

# Finaliza el juego y muestra la puntuación total
func end_game():
	popup.popup_centered()  # Muestra el popup
	popup.get_child(0).text = "Puntuación total: " + str(current_score)  # Cambia el texto
	get_parent().get_node("grid").game_over()  # Llama al método game_over en grid.gd 
