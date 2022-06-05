extends Node2D

# TO-DO: Sometimes it won't collide.

const IMPACT = preload("res://SFX/sfx_sounds_interaction7.wav")
const WIN = preload("res://SFX/sfx_sounds_fanfare3.wav")
const LOST = preload("res://SFX/sfx_sounds_damage3.wav")

#enum COLLIDED {PLAYER = 1, ENEMY = 2, PLAYER_H = 3, ENEMY_H = 4}

var Play  :  bool setget set_game
var title := Title.new(64)

var player       := Paddle.new()
var playerH      := PaddleH.new()
var playerScore  : Score
var playerTarget : Target

var enemy       := Enemy.new()
var enemyH      := EnemyH.new()
var enemyScore  : Score
var enemyTarget : Target

var ball :  Ball
var beep := AudioStreamPlayer.new()

var touched = false

func _ready() -> void:
	Screen.get_screen(get_tree().get_root().size)
	get_tree().connect('screen_resized', Screen, 'update_screen')
	render_game()

func render_game() -> void:
	ball = Ball.new()
	playerScore = Score.new(64, Screen.screenSize.x/2 - Screen.screenSize.x/4)
	playerTarget = Target.new(Vector2(32, Screen.screenSize.y -32))

	player.set_start_pos(Vector2(player.paddlePadding, 0))
	playerH.set_start_pos(Vector2(0, Screen.screenSize.y - playerH.paddleSize.x))

	enemy = Enemy.new(); enemyH = EnemyH.new()
	enemyScore = Score.new(64, Screen.screenSize.x/2 + Screen.screenSize.x/4)
	enemyTarget = Target.new(Vector2(Screen.screenSize.x - 32, 32))

	enemy.set_start_pos(Vector2(Screen.screenSize.x - (enemy.paddlePadding + enemy.paddleSize.x), 0))
	enemyH.set_start_pos(Vector2(0, 0 + enemyH.paddleSize.x))

	add_children([beep, title, ball, player, playerH, playerScore, playerTarget, enemy, enemyH, enemyScore, enemyTarget])
	set_game(Play)
	enemyTarget.rotation_degrees = 180
	
	ball.restart()


func add_children(children: Array):
	for i in children:
		add_child(i)


func set_game(value):
	Play = value
	title.set_text("CLICK TO PLAY") if !Play else title.set_text("MOVE YOUR MOUSE")
	yield(get_tree().create_timer(5.0), "timeout")
	if Play: title.set_text("")

func _physics_process(delta: float) -> void:
	if !Play:
		if Input.is_mouse_button_pressed(BUTTON_LEFT): self.Play = true; ball.acceleration = 1.0
	else:
		check_collision_field()
		handle_ball(delta)
		handle_enemy(delta)
	player.position.y =  clamp(get_local_mouse_position().y, 0, Screen.screenSize.y - player.paddleSize.y)
	playerH.position.x = clamp(get_local_mouse_position().x, 0, Screen.screenSize.x - playerH.paddleSize.x)

func handle_ball(delta) -> void:
	var newSpeed = ball.speed * delta
	newSpeed.x = clamp(newSpeed.x, -15, 15)
	newSpeed.y = clamp(newSpeed.y, -15, 15)
	ball.position += newSpeed
	if ball.out():
		self.Play = false
		if ball.position.x <= 0 or ball.position.y >= Screen.screenSize.y:
			enemyScore.points += 1
			beep.stream = LOST
			beep.play()
		elif ball.position.x >= Screen.screenSize.x or ball.position.y <= 0 : 
			playerScore.points += 1
			beep.stream = WIN
			beep.play()
		ball.restart()
		newColor()


func handle_collisions():
	var entity := true
	if Collisions.pointToRect(ball.position, Rect2(player.position, player.paddleSize)) and ball.speed.x < 0: 
		if !touched:
			player.changeBallDirection(ball)
	elif Collisions.pointToRect(ball.position, Rect2(enemy.position,  enemy.paddleSize)) and ball.speed.x > 0:
		if !touched:
			enemy.changeBallDirection(ball)
			enemy.change_enemy_pos()
	elif Collisions.pointToRect(ball.position, Rect2(playerH.position, playerH.paddleSize)) and ball.speed.y > 0 :
		if !touched:
			playerH.changeBallDirection(ball)
	elif Collisions.pointToRect(ball.position, Rect2(enemyH.position,  enemyH.paddleSize)) and ball.speed.y < 0:
		if !touched:
			enemyH.changeBallDirection(ball)
			enemyH.change_enemy_pos()
	else:
		entity = false

	if entity:
		ball.acceleration += 0.2
		newColor()
		beep.stream = IMPACT
		beep.play()
		touched = true

func check_collision_field() -> void:
	if  (ball.position.x <= player.paddleSize.x + player.paddlePadding + player.paddlePadding or
	ball.position.x >= Screen.screenSize.x - enemy.paddleSize.x - enemy.paddlePadding or
	ball.position.y >= Screen.screenSize.y - playerH.paddleSize.y or
	ball.position.y <= enemyH.paddleSize.y + enemyH.paddlePadding):
		handle_collisions()
	else:
		touched = false




func handle_enemy(delta) -> void:
	enemy.speed = 400.0
	enemyH.speed = 400.0
	if ball.position.y > enemy.position.y + (enemy.chasePos+10):
		enemy.position.y += enemy.speed * delta
	elif ball.position.y < enemy.position.y + (enemy.chasePos -10):
		enemy.position.y -= enemy.speed * delta
	
	enemy.position.y = clamp(enemy.position.y, 0, Screen.screenSize.y - enemy.paddleSize.y)

	if ball.position.x > enemyH.position.x + (enemyH.chasePos - 10):
		enemyH.position.x += enemyH.speed * delta
	elif ball.position.x < enemyH.position.x + (enemyH.chasePos + 10):
		enemyH.position.x -= enemyH.speed * delta
	
	enemyH.position.x = clamp(enemyH.position.x, 0, Screen.screenSize.x - enemyH.paddleSize.x)


func newColor():
	# pallete from https://lospec.com/palette-list/blk-nx64

	var pallete := ['#12173d','#293268','#464b8c','#6b74b2','#909edd','#c1d9f2','#ffffff','#a293c4',
	'#7b6aa5','#53427f','#3c2c68','#431e66','#5d2f8c','#854cbf','#b483ef','#8cff9b','#42bc7f','#22896e',
	'#14665b','#0f4a4c','#0a2a33','#1d1a59','#322d89','#354ab2','#3e83d1','#50b9eb','#8cdaff','#53a1ad',
	'#3b768f','#21526b','#163755','#008782','#00aaa5','#27d3cb','#78fae6','#cdc599','#988f64','#5c5d41',
	'#353f23','#919b45','#afd370','#ffe091','#ffaa6e','#ff695a','#b23c40','#ff6675','#dd3745','#a52639',
	'#721c2f','#b22e69','#e54286','#ff6eaf','#ffa5d5','#ffd3ad','#cc817a','#895654','#61393b','#3f1f3c',
	'#723352','#994c69','#c37289','#f29faa','#ffccd0 ']

	randomize()
	var assign := floor(rand_range(0, pallete.size()-1))
	modulate = pallete[assign]
