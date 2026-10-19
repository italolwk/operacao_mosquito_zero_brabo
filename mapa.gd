extends Control

const MOSQUITO = preload("res://mosquito.tscn")

var onda = 1
var verificando_onda = false

var posicoes_mosquitos = [
	Vector2(500, 300),
	Vector2(650, 350),
	Vector2(800, 300),
	Vector2(950, 350),
	Vector2(1050, 300)
]


func _ready():
	spawn_mosquitos(5)
	
func _process(_delta):
	var mosquitos = get_tree().get_nodes_in_group("mosquitos")

	if mosquitos.size() == 0 and not verificando_onda:
		iniciar_proxima_onda()

func iniciar_proxima_onda():
	verificando_onda = true

	onda += 1

	$OndaLabel.text = "Onda: " + str(onda)
	
	$OndaMensagemLabel.text = "ONDA " + str(onda)
	$OndaMensagemLabel.visible = true

	print("NOVA ONDA: ", onda)

	await get_tree().create_timer(2.0).timeout
	
	$OndaMensagemLabel.visible = false

	var quantidade = 5 + (onda - 1) * 2

	spawn_mosquitos(quantidade)

	verificando_onda = false


func spawn_mosquitos(quantidade):
	for i in range(quantidade):
		var mosquito = MOSQUITO.instantiate()
		add_child(mosquito)

		var posicao = posicoes_mosquitos[i % posicoes_mosquitos.size()]
		mosquito.global_position = posicao
