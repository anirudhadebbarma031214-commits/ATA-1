extends Node3D
## Procedural attraction landmarks for the ATA-1 Agartala-inspired city.

func _ready() -> void:
	_build_mall(Vector3(0, 0, 62))
	_build_palace(Vector3(62, 0, 0))
	_build_lake(Vector3(-62, 0, 0))
	_build_market(Vector3(0, 0, -62))
	_build_pandal(Vector3(62, 0, 62))
	_build_food_street(Vector3(-62, 0, 62))
	_build_park(Vector3(62, 0, -62))
	_build_hospital(Vector3(-62, 0, -62))

func _material(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	return m

func _box(parent: Node3D, label: String, size: Vector3, at: Vector3, color: Color) -> MeshInstance3D:
	var item := MeshInstance3D.new()
	item.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	item.mesh = mesh
	item.position = at
	item.material_override = _material(color)
	parent.add_child(item)
	return item

func _cylinder(parent: Node3D, label: String, radius: float, height: float, at: Vector3, color: Color) -> void:
	var item := MeshInstance3D.new()
	item.name = label
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	item.mesh = mesh
	item.position = at
	item.material_override = _material(color)
	parent.add_child(item)

func _place(label: String, origin: Vector3) -> Node3D:
	var p := Node3D.new()
	p.name = label
	p.position = origin
	add_child(p)
	return p

func _sign(p: Node3D, words: String, at: Vector3, color: Color) -> void:
	_box(p, "SignBoard", Vector3(9, 1.2, 0.25), at, color)
	var label := Label3D.new()
	label.text = words
	label.font_size = 40
	label.pixel_size = 0.012
	label.position = at + Vector3(0, 0, 0.16)
	p.add_child(label)

func _build_mall(origin: Vector3) -> void:
	var p := _place("AgartalaShoppingMall", origin)
	_box(p, "MallBuilding", Vector3(22, 10, 13), Vector3(0, 5, 0), Color(0.55, 0.62, 0.68))
	_box(p, "GlassFront", Vector3(18, 6, 0.2), Vector3(0, 4.8, 6.6), Color(0.08, 0.42, 0.58))
	_box(p, "Roof", Vector3(23, 0.8, 14), Vector3(0, 10.4, 0), Color(0.12, 0.18, 0.25))
	_sign(p, "CITY MALL", Vector3(0, 8, 6.8), Color(0.08, 0.24, 0.46))
	_box(p, "Parking", Vector3(28, 0.12, 12), Vector3(0, 0.06, 14), Color(0.18, 0.19, 0.2))
	for i in range(6):
		_box(p, "ParkingLine_%d" % i, Vector3(0.12, 0.15, 4), Vector3(-11 + i * 4.4, 0.15, 14), Color(0.92, 0.92, 0.82))

func _build_palace(origin: Vector3) -> void:
	var p := _place("UjjayantaPalaceInspiredLandmark", origin)
	_box(p, "PalaceBase", Vector3(20, 2, 12), Vector3(0, 1, 0), Color(0.88, 0.84, 0.68))
	_box(p, "MainHall", Vector3(13, 7, 8), Vector3(0, 5.5, 0), Color(0.92, 0.88, 0.76))
	_box(p, "LeftWing", Vector3(5, 4.5, 7), Vector3(-8, 4.2, 0), Color(0.84, 0.8, 0.67))
	_box(p, "RightWing", Vector3(5, 4.5, 7), Vector3(8, 4.2, 0), Color(0.84, 0.8, 0.67))
	_cylinder(p, "Dome", 2.4, 3.5, Vector3(0, 10.4, 0), Color(0.72, 0.75, 0.76))
	_sign(p, "ROYAL HERITAGE", Vector3(0, 2.5, 6.3), Color(0.47, 0.25, 0.1))

func _build_lake(origin: Vector3) -> void:
	var p := _place("LakeAndGarden", origin)
	_box(p, "LakeWater", Vector3(25, 0.12, 18), Vector3(0, 0.02, 0), Color(0.08, 0.42, 0.67))
	_box(p, "Walkway", Vector3(29, 0.2, 2), Vector3(0, 0.12, 10), Color(0.72, 0.69, 0.59))
	for x in [-11.0, -5.0, 2.0, 9.0]:
		_cylinder(p, "TreeTrunk", 0.35, 2.2, Vector3(x, 1.1, 13), Color(0.32, 0.2, 0.1))
		_cylinder(p, "TreeCanopy", 1.5, 2.2, Vector3(x, 3, 13), Color(0.12, 0.42, 0.19))
	_sign(p, "LAKESIDE PARK", Vector3(0, 2.5, 15), Color(0.06, 0.28, 0.34))

func _build_market(origin: Vector3) -> void:
	var p := _place("AgartalaStreetMarket", origin)
	_box(p, "MarketRoad", Vector3(30, 0.1, 16), Vector3(0, 0.02, 0), Color(0.22, 0.22, 0.23))
	var colors := [Color(0.82, 0.28, 0.18), Color(0.16, 0.48, 0.72), Color(0.85, 0.58, 0.12), Color(0.2, 0.58, 0.34), Color(0.62, 0.32, 0.66)]
	for i in range(5):
		var x := -12.0 + float(i) * 6.0
		_box(p, "Shop_%02d" % i, Vector3(4.5, 3.4, 4), Vector3(x, 1.7, -8), colors[i])
		_box(p, "Awning_%02d" % i, Vector3(5, 0.35, 2), Vector3(x, 3.1, -4.5), Color(0.94, 0.84, 0.66))
		_box(p, "VendorStall_%02d" % i, Vector3(3, 1.5, 2), Vector3(x, 0.75, 5), Color(0.72, 0.42, 0.2))
	_sign(p, "LOCAL MARKET", Vector3(0, 4.2, -5.6), Color(0.12, 0.3, 0.18))

func _build_pandal(origin: Vector3) -> void:
	var p := _place("DurgaPujaPandal", origin)
	_box(p, "Platform", Vector3(18, 0.6, 14), Vector3(0, 0.3, 0), Color(0.72, 0.57, 0.35))
	_box(p, "BackWall", Vector3(12, 8, 1), Vector3(0, 4.3, -5), Color(0.68, 0.22, 0.24))
	_box(p, "Roof", Vector3(16, 0.7, 12), Vector3(0, 8.5, 0), Color(0.9, 0.68, 0.22))
	for x in [-6.0, -3.0, 3.0, 6.0]:
		_box(p, "DecorativePillar", Vector3(0.5, 8, 0.5), Vector3(x, 4, 4), Color(0.94, 0.78, 0.38))
	_box(p, "IdolBackdrop", Vector3(7, 5, 0.35), Vector3(0, 4.2, -4.35), Color(0.95, 0.72, 0.25))
	_cylinder(p, "IdolPlaceholder", 1.25, 3, Vector3(0, 2.2, -3.7), Color(0.92, 0.55, 0.25))
	_sign(p, "DURGA PUJA", Vector3(0, 7.3, 6.2), Color(0.48, 0.08, 0.12))

func _build_food_street(origin: Vector3) -> void:
	var p := _place("TripuraFoodStreet", origin)
	_box(p, "Street", Vector3(28, 0.1, 13), Vector3(0, 0.02, 0), Color(0.23, 0.23, 0.24))
	var colors := [Color(0.8, 0.25, 0.1), Color(0.12, 0.5, 0.28), Color(0.92, 0.58, 0.12), Color(0.18, 0.36, 0.68)]
	for i in range(4):
		var x := -10.0 + float(i) * 6.5
		_box(p, "FoodStall_%02d" % i, Vector3(4.5, 2.7, 3.4), Vector3(x, 1.35, -5), colors[i])
		_box(p, "Counter_%02d" % i, Vector3(4.8, 0.8, 1.1), Vector3(x, 0.75, -2.7), Color(0.75, 0.67, 0.53))
	_sign(p, "TRIPURA FOOD STREET", Vector3(0, 3.7, -6.9), Color(0.38, 0.12, 0.08))

func _build_park(origin: Vector3) -> void:
	var p := _place("CityGarden", origin)
	_box(p, "GrassField", Vector3(25, 0.1, 22), Vector3(0, 0.02, 0), Color(0.18, 0.43, 0.2))
	_box(p, "WalkingPath", Vector3(3, 0.13, 20), Vector3(0, 0.1, 0), Color(0.75, 0.69, 0.56))
	for x in [-9.0, -3.0, 4.0, 10.0]:
		_cylinder(p, "TreeTrunk", 0.38, 2.5, Vector3(x, 1.25, -5), Color(0.3, 0.19, 0.1))
		_cylinder(p, "TreeCanopy", 1.6, 2.2, Vector3(x, 3.3, -5), Color(0.11, 0.38, 0.17))
	_sign(p, "CITY GARDEN", Vector3(0, 2.6, 11), Color(0.08, 0.28, 0.14))

func _build_hospital(origin: Vector3) -> void:
	var p := _place("CityHospital", origin)
	_box(p, "MainBuilding", Vector3(18, 8, 11), Vector3(0, 4, 0), Color(0.82, 0.86, 0.87))
	_box(p, "Wing", Vector3(8, 5, 8), Vector3(8, 2.5, 6), Color(0.72, 0.8, 0.83))
	_box(p, "Entrance", Vector3(5, 3, 0.5), Vector3(0, 2, 5.8), Color(0.12, 0.5, 0.38))
	_box(p, "CrossVertical", Vector3(0.7, 2.4, 0.3), Vector3(0, 6.4, 5.9), Color(0.85, 0.1, 0.12))
	_box(p, "CrossHorizontal", Vector3(2.2, 0.7, 0.3), Vector3(0, 6.4, 5.9), Color(0.85, 0.1, 0.12))
	_sign(p, "CITY HOSPITAL", Vector3(0, 7.3, 6.3), Color(0.08, 0.32, 0.24))
