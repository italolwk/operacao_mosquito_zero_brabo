extends CharacterBody2D

const SPEED = 250.0

var vida = 3
var pode_atacar = true
var tempo_ataque = 1.0
var mosquitos_eliminados = 0
var fase_concluida = false
var onda = 1

@onready var ataque = $Ataque
@onready var vida_label = get_parent().get_node("VidaLabel")
@onready var mosquitos_label = get_parent().get_node("MosquitosLabel")
@onready var missao_concluida_label = get_parent().get_node("MissaoConcluidaLabel")


func _physics_process(delta):
	
	var direction = Vector2.ZERO
	

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	if direction.length() > 0:
		direction = direction.normalized()

	velocity = direction * SPEED
	move_and_slide()

	# Ataque
	if Input.is_key_pressed(KEY_SPACE) and pode_atacar:
		atacar()


func atacar():
	pode_atacar = false

	var mosquitos = ataque.get_overlapping_areas()
	
	for mosquito in mosquitos:
		if mosquito.is_in_group("mosquitos"):
			mosquito.queue_free()
			mosquitos_eliminados += 1

	mosquitos_label.text = "Mosquitos: " + str(mosquitos_eliminados)
	
	await get_tree().create_timer(tempo_ataque).timeout

	pode_atacar = true
