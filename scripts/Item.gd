extends Resource
class_name ItemResource

export var name : String
export var stackable : bool = false
enum ItemType {WEAPON, CONSUMABLE, EQUIPABLE, SPELL}
export (ItemType) var type
export var texture : Texture

export var effect_range : int
export var cooldown : int
export var damage : int
export var accuracy : float
export var uses : int
