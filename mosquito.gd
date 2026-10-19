extends Area2D

const SPEED = 100.0
const DISTANCIA_MINIMA = 50.0
const DISTANCIA_SEPARACAO = 45.0

var tempo := 0.0
var alvo_offset := Vector2.ZERO

func _ready():
	add_to_group("mosquitos")

	alvo_offset = Vector2(
		randf_range(-80.0, 80.0),
		randf_range(-60.0, 60.0)
	)

	position += Vector2(
		randf_range(-80.0, 80.0),
		randf_range(-50.0, 50.0)
	)
	
	
func _process(delta):
	tempo += delta

	var jogador = get_tree().get_first_node_in_group("jogador")

	if jogador:
		# Cada mosquito possui seu próprio ponto ao redor do jogador
		var alvo = jogador.global_position + alvo_offset

		var direcao = global_position.direction_to(alvo)

		# Movimento lateral do enxame
		var lateral = Vector2(-direcao.y, direcao.x)
		var oscilacao = sin(tempo * 4.0) * 0.25

		direcao += lateral * oscilacao

		# Separação entre os mosquitos
		var separacao = Vector2.ZERO

		for outro in get_tree().get_nodes_in_group("mosquitos"):
			if outro == self:
				continue

			var distancia_outro = global_position.distance_to(outro.global_position)

			if distancia_outro < 70.0 and distancia_outro > 0:
				var afastar = outro.global_position.direction_to(global_position)

				var forca = (70.0 - distancia_outro) / 70.0

				separacao += afastar * forca

		# A separação tem bastante força
		direcao += separacao * 5.0

		direcao = direcao.normalized()

		# Não deixa o mosquito chegar perto demais do jogador
		var distancia_jogador = global_position.distance_to(jogador.global_position)

		if distancia_jogador > DISTANCIA_MINIMA:
			global_position += direcao * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		body.vida -= 1
		body.vida_label.text = "Vidas: " + str(body.vida)
		queue_free()
