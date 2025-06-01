extends Node2D


var eyesAreOpened: bool = false
var idOfAudio: int

@export var OpenEye: Sprite2D
@export var ClosedEye: Sprite2D

@export var OpenMouth: Sprite2D
@export var ClosedMouth: Sprite2D
@export var talkThresholdPercentage: float = 40

var characterTalking: bool = false
func timeOut() -> void:
	eyesAreOpened = not eyesAreOpened

func _ready() -> void:
	dealWithEye()
	dealWithMouth()
	idOfAudio = AudioServer.get_bus_index("mic")

func dealWithEye() -> void:
	if eyesAreOpened:
		OpenEye.visible = true
		ClosedEye.visible = false
	else:
		OpenEye.visible = false
		ClosedEye.visible = true

func dealWithMouth() -> void:
	if characterTalking:
		OpenMouth.visible = true
		ClosedMouth.visible = false
	else:
		OpenMouth.visible = false
		ClosedMouth.visible = true

func _process(_delta: float) -> void:
	dealWithEye()
	var peakVolume: float = AudioServer.get_bus_peak_volume_left_db(idOfAudio,0)
	var volume: float = transformPeakVolumeIntoAPercentage(peakVolume)
	characterTalking = volume > talkThresholdPercentage 
	dealWithMouth()


func transformPeakVolumeIntoAPercentage(volume: float) -> float:
	# turn volume into positive
	volume *=  -1

	# volume when there's not any noise in the mic
	var percentage: float = 72

	# turns the volume into a 0-1 value
	percentage = ( volume / percentage) 

	# invert 0-1 value to 1-0 because the volume is inverted
	volume = 1 - percentage

	# multiply to 100 to turn into a percentage
	return volume * 100

	
