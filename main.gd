extends Node2D

enum COLLIDED {PLAYER = 1, ENEMY = 2, PLAYER_H = 3, ENEMY_H = 4}

var Play  : bool setget set_game
var title : Title

var player       : Paddle
var playerH      : PaddleH
var playerScore  : Score
var playerTarget : Target

var enemy       : Paddle
var enemyH      : PaddleH
var enemyScore  : Score
var enemyTarget : Target

var ball :  Ball
var turn := Vector2(1,1)

func _ready() -> void:
	Screen.get_screen(get_tree().get_root().size)
	get_tree().connect('screen_resized', Screen, 'update_screen')
	render_game()

func render_game() -> void:
	title = Title.new(64); ball = Ball.new(); player = Paddle.new(); playerH = PaddleH.new()
	playerScore = Score.new(64, Screen.screenSize.x/2 - Screen.screenSize.x/4)
	playerTarget = Target.new(Vector2(32, Screen.screenSize.y -32))

	player.set_start_pos(Vector2(player.paddlePadding, 0))
	playerH.set_start_pos(Vector2(0, Screen.screenSize.y - playerH.paddleSize.x))

	enemy = Paddle.new(); enemyH = PaddleH.new()
	enemyScore = Score.new(64, Screen.screenSize.x/2 + Screen.screenSize.x/4)
	enemyTarget = Target.new(Vector2(Screen.screenSize.x - 32, 32))

	enemy.set_start_pos(Vector2(Screen.screenSize.x - (enemy.paddlePadding + enemy.paddleSize.x), 0))
	enemyH.set_start_pos(Vector2(0, 0 + enemyH.paddleSize.x))

	add_children([title, ball, player, playerH, playerScore, playerTarget, enemy, enemyH, enemyScore, enemyTarget])
	set_game(Play)
	enemyTarget.rotation_degrees = 180


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
		if ball.acceleration != 0: # needs to set only once
			ball.restart()
			ball.acceleration = 0
		if Input.is_mouse_button_pressed(BUTTON_LEFT): self.Play = true
	else:
		handle_ball(delta)
		player.position.y =  clamp(get_local_mouse_position().y, 0, Screen.screenSize.y - player.paddleSize.y)
		playerH.position.x = clamp(get_local_mouse_position().x, 0, Screen.screenSize.x - playerH.paddleSize.x)
		handle_collisions()
		handle_enemy(delta)

func handle_ball(delta) -> void:
	ball.position.x += (ball.speed.x+(ball.acceleration)) * delta * turn.x
	ball.position.y += ball.speed.y * delta * turn.y
	if ball.out():
		self.Play = false
		if ball.position.x <= 0 or ball.position.y >= Screen.screenSize.y:
			turn.x = 1
			enemyScore.points += 1
		elif ball.position.x >= Screen.screenSize.x or ball.position.y <= 0 : 
			turn.x = -1
			playerScore.points += 1



func handle_collisions() -> void:
	var betweenPoint : float
	var entity       : int

	if Collisions.pointToRect(ball.position, Rect2(player.position, player.paddleSize)): 
		entity = COLLIDED.PLAYER
	elif Collisions.pointToRect(ball.position, Rect2(enemy.position,  enemy.paddleSize)):
		entity = COLLIDED.ENEMY
	elif Collisions.pointToRect(ball.position, Rect2(playerH.position, playerH.paddleSize)):
		entity = COLLIDED.PLAYER_H
	elif Collisions.pointToRect(ball.position, Rect2(enemyH.position,  enemyH.paddleSize)):
		entity = COLLIDED.ENEMY_H

	if entity:
		ball.acceleration += 10
		newColor()
		match entity:
			COLLIDED.PLAYER:
				turn.x *= -1
				if turn.x == 1:
					betweenPoint = ball.position.y - player.position.y - (player.paddleSize.y/2)
					continue
			COLLIDED.ENEMY:
				turn.x *= -1
				if turn.x == -1: 
					betweenPoint = ball.position.y - enemy.position.y  - (enemy.paddleSize.y/2)
					continue
			COLLIDED.PLAYER, COLLIDED.ENEMY:
				ball.speed.y = clamp(ball.speed.y + (betweenPoint + ball.acceleration),-500,500)
			COLLIDED.PLAYER_H:
				turn.y *= -1
				betweenPoint = ball.position.x - playerH.position.x - (playerH.paddleSize.x)
			COLLIDED.ENEMY_H:
				turn.y *= -1
				betweenPoint = ball.position.x - enemyH.position.x - (enemyH.paddleSize.x/2)
			COLLIDED.PLAYER_H, COLLIDED.ENEMY_H:
				ball.speed.x = clamp(ball.speed.x + (betweenPoint + ball.acceleration),-500,500)
				ball.speed.y *= turn.y


func handle_enemy(delta) -> void:
	enemy.speed = 300.0
	enemyH.speed = 300.0
	
	if ball.position.y > enemy.position.y + (enemy.paddleSize.y/2 + 3):
		enemy.position.y += enemy.speed * delta
	elif ball.position.y < enemy.position.y + (enemy.paddleSize.y/2 - 3):
		enemy.position.y -= enemy.speed * delta
	
	enemy.position.y = clamp(enemy.position.y, 0, Screen.screenSize.y - enemy.paddleSize.y)

	if ball.position.x > enemyH.position.x + (enemyH.paddleSize.x/2 + 3):
		enemyH.position.x += enemyH.speed * delta
	elif ball.position.x < enemyH.position.x + (enemyH.paddleSize.x/2 - 3):
		enemyH.position.x -= enemyH.speed * delta
	
	enemyH.position.x = clamp(enemyH.position.x, 0, Screen.screenSize.x - enemyH.paddleSize.x)


func newColor():
	# pallete from https://lospec.com/palette-list/paintnet-base-colors
	# should change, probably more saturation
	var pallete := [ 
	'#808080', '#ffffff', '#7f0000', '#ff0000', '#7f3300', '#ff6a00', '#7f6a00', '#ffd800', '#5b7f00',
	'#b6ff00', '#267f00', '#4cff00', '#007f0e', '#00ff21', '#007f46', '#00ff90', '#007f7f', '#00ffff',
	'#004a7f', '#0094ff', '#00137f', '#0026ff', '#21007f', '#4800ff', '#57007f', '#b200ff', '#7f006e',
	'#ff00dc', '#7f0037', '#ff006e ' ]
	randomize()
	var assign := floor(rand_range(0, pallete.size()-1))
	modulate = pallete[assign]
