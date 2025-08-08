extends Control

@onready var SnapshotRect:TextureRect = $MarginContainer/SubViewport/SnapshotTextureRect
@onready var NoteLabel:Label = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/NoteLabel
@onready var BtnControls:Control = $BtnControls

signal close_note

func _ready() -> void:
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)
		close_note.emit()
		
	BtnControls.onAction = func() -> void:
		await BtnControls.reveal(false)
		close_note.emit()
	
	BtnControls.reveal(false)
	hide()

func open_notes() -> void:
	show()
	take_snapshot()
	NoteLabel.text = ">>: "
	BtnControls.reveal(true)
	await close_note
	hide()

func take_snapshot() -> void:
	SnapshotRect.texture = U.get_viewport_texture(GBL.find_node(REFS.MAIN_ACTIVE_VIEWPORT))
