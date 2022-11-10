tool
class_name ItemType
extends Resource

enum SlotFlags {
	SMALL = 1 << 0,
	LARGE = 1 << 1,
	EQUIPMENT = 1 << 2,
	QUEST = 1 << 3,
	POTION = 1 << 4,
	AMMO = 1 << 5,
	CURRENCY = 1 << 6,
	FUEL = 1 << 7,
	QUEST = 1 << 8,
	CRAFTING = 1 << 9
	#
	#
	#
	#
	#
	E_MAINHAND = 1 << 15,
	E_OFFHAND = 1 << 16,
	E_HELM = 1 << 17,
	E_CHEST = 1 << 18,
	E_BELT = 1 << 19,
	E_HANDS = 1 << 20,
	E_FEET = 1 << 21,
	E_RING = 1 << 22,
	E_NECK = 1 << 23,
}


export var item_name := ""
export var max_stack_count := 1
export var in_inventory_width := 1
export var in_inventory_height := 1
export var texture : Texture
export var texture_scale := 1.5
export(int, FLAGS,
		"SMALL",
		"LARGE",
		"EQUIPMENT",
		"QUEST",
		"POTION",
		"AMMO",
		"CURRENCY",
		"FUEL",
		"QUEST",
		"CRAFTING",
		"#",
		"#",
		"#",
		"#",
		"#",
		"E_MAINHAND",
		"E_OFFHAND",
		"E_HELM",
		"E_CHEST",
		"E_BELT",
		"E_HANDS",
		"E_FEET",
		"E_RING",
		"E_NECK"
	) var slot_flags := 1
export var default_properties : Dictionary
