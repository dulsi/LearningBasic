extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var manual = {
	"main" : "[center]Table of Contents[/center]\nSome text\n[url]for[/url]",
	"for" : "[center]For statement[/center]\nFor description"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	bbcode_text = manual["main"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RichTextLabel_meta_clicked(meta):
	bbcode_text = manual[meta]
