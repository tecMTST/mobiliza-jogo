extends Node2D

# abencoado seja o https://randommomentania.com/2018/08/godot-touch-screen-joystick-part-1/

export var raio_tolerancia = 400

signal alavanca_movida(posicao)
signal alavanca_solta

onready var _toque = $ControleDeToque
onready var _sprite_topo = $Topo as Sprite
onready var _sprite_base = $Base as Sprite

var _movendo = false

func _ready():
	_sprite_topo.visible = false
	_sprite_base.visible = false

func _mover_alavanca(posicao: Vector2):
	if not _movendo:
		return
	var diferenca = posicao - _sprite_base.position
	emit_signal("alavanca_movida", diferenca)
	_sprite_topo.position = _sprite_base.position + diferenca.normalized() * 150


func _on_ControleDeToque_arrastar_realizado(historico):
	_mover_alavanca(get_local_mouse_position())


func _on_ControleDeToque_toque_desfeito(historico):
	emit_signal("alavanca_solta")
	_movendo = false
	_sprite_topo.visible = false
	_sprite_base.visible = false
	_sprite_topo.position = Vector2.ZERO


func _on_ControleDeToque_toque_realizado(historico):
	var posicao = get_local_mouse_position()
	$Base/Animador.play("anuncio")
	_sprite_topo.position = posicao
	_sprite_base.position = posicao
	_movendo = true
	_sprite_topo.visible = true
	_sprite_base.visible = true
	_mover_alavanca(posicao)


