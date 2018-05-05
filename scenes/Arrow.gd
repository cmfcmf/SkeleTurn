extends Area2D

var velocity = Vector2()
var gravityFactor = 1
var customGravity = 1300
var speed = 700

func _ready():
	get_node("Particles").emitting = true

func initialize(var gravityFactor, var position, var direction, var velocity): # constructor
	self.gravityFactor = gravityFactor
	self.translate(position)
	self.velocity.x = velocity.x + speed * direction
	self.velocity.y = velocity.y

func calculateVelocity(delta):
	velocity.y += gravityFactor * customGravity * delta

func _physics_process(delta):
	self.calculateVelocity(delta)
	self.translate(velocity * delta)
	
	if position.x<0:
		position.x=1280
	if position.x>1280:
		position.x=0
	
	self.look_at(self.position + self.velocity * delta)
	
func mydelete():
	get_node("ArrowCollision").disabled = true
	get_node("Particles").emitting = false
	get_node("ArrowSprite").visible = false
	set_physics_process(false)
	
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.wait_time = 1
	add_child(timer)
	timer.start()
	
func _on_timer_timeout():
	self.queue_free()
	
func _on_Arrow_body_entered(body):
	if body.is_in_group("Player"):
		get_node("Explosion").emitting = true
		body.die()
	self.mydelete()