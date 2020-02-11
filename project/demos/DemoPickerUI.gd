class_name DemoPickerUI
extends Control


signal demo_requested

var demo_path := "" setget set_demo_path

onready var list: ItemList = $VBoxContainer/ItemList
onready var button: Button = $VBoxContainer/Button


func _ready() -> void:
	var _err := list.connect("demo_selected", self, "set_demo_path")
	_err = list.connect("item_activated", self, "emit_signal", ["demo_requested"])
	_err = button.connect("pressed", self, "emit_signal", ["demo_requested"])
	demo_path = list.file_paths[0]


func set_demo_path(value: String) -> void:
	demo_path = value
