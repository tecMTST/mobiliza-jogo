extends KinematicBody2D
class_name Pessoa


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var variedade_distancia_maxima: Vector2 = Vector2(100,200)
export var variedade_aleatorio: int = 200

onready var sprites = $SpritesPessoa as AnimatedSprite
onready var _temporizador_sorte := Timer.new()

var _alvo: KinematicBody2D
var distancia_maxima: int
var cor='azul'
var aleatorio: RandomNumberGenerator

onready var vetor_diferente: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	_temporizador_sorte.wait_time = 5
	_temporizador_sorte.one_shot = true
	_temporizador_sorte.autostart = false
	add_child(_temporizador_sorte)
	_temporizador_sorte.start()

func gerar_vetor_aleatorio():
	return Vector2(
		aleatorio.randf_range(-variedade_aleatorio, variedade_aleatorio),
		aleatorio.randf_range(-variedade_aleatorio, variedade_aleatorio))


func definir_alvo(alvo):
	aleatorio = alvo.aleatorio
	aleatorio.randomize()
	distancia_maxima = aleatorio.randi_range(variedade_distancia_maxima.x,variedade_distancia_maxima.y)	
	vetor_diferente = gerar_vetor_aleatorio()
	_alvo = alvo
	cor='verde'


func mobilizar(ponto):
	definir_alvo(ponto)
	cor='vermelha'


func _explorar():
	if cor != 'vermelha':
		return
	if _temporizador_sorte.time_left <= 0:
		_temporizador_sorte.wait_time = aleatorio.randf_range(3,5)
		_temporizador_sorte.start()
		vetor_diferente = gerar_vetor_aleatorio()
		distancia_maxima = 400


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _alvo:
		return

	var distancia = (_alvo.position - position) + vetor_diferente
	var porcento_distancia = (distancia.length_squared() / (distancia_maxima ^ 2))
	var vetor_movimento = distancia.normalized() * porcento_distancia

	move_and_slide(vetor_movimento)

	if vetor_movimento.x < 0:
		sprites.scale.x=-abs(sprites.scale.x)
	elif vetor_movimento.x > 0:
		sprites.scale.x=abs(sprites.scale.x)

	var tamanho_movimento = vetor_movimento.length_squared()
	if tamanho_movimento > 400:
		sprites.play("andando_%s" % cor)
	else:
		sprites.play("parada_%s" % cor)

	sprites.speed_scale = porcento_distancia / 200
	_explorar()


func _on_Area_body_entered(body):
	if not body.jogador or (_alvo):
		return
	if not body.adicionar_seguidor(self):
		return
	definir_alvo(body)
