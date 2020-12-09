extends Resource
class_name ItemResource

export var name : String
export var stackable : bool
enum ItemType {WEAPON, CONSUMABLE, EQUIPABLE, SPELL}
export (ItemType) var type
export var texture : Texture
export var reusable : bool

export var effect_range : float
export var cooldown : int
export var damage : int
export var accuracy : float
export var uses : int
