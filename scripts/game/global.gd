extends Node

var mouseSensitivity = 0.005

const MAIN_MENU_SRC = "res://scenes/gui/main_menu.tscn";
const WAREHOUSE_SRC = "res://scenes/maps/warehouse.tscn";
const HILLS_SRC = "res://scenes/maps/hills.tscn";

var weapons = {
	"pistol" : {
		name = "pistol",
		location = "playerHead/playerCamera/weapons/pistol",
		damage = 20,
		fireRate = 10,
		rounds = 8
	},
	"shotgun" : {
		name = "shotgun",
		location = "playerHead/playerCamera/weapons/shotgun",
		damage = 5,
		fireRate = 20,
		rounds = 8
	}
}
