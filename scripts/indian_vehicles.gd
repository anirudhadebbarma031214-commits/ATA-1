extends Node3D
## Simple stylized Indian traffic vehicles for the ATA-1 prototype.
## These are original placeholder meshes, not exact licensed car models.

var vehicle_specs := [
	{"name": "INDIAN HATCHBACK", "color": Color(0.12, 0.42, 0.92), "size": Vector3(1.8, 0.65, 3.2), "roof": Vector3(1.35, 0.58, 1.55), "kind": "car"},
	{"name": "INDIAN SEDAN", "color": Color(0.82, 0.84, 0.88), "size": Vector3(1.9, 0.62, 3.8), "roof": Vector3(1.45, 0.58, 1.8), "kind": "car"},
	{"name": "INDIAN SUV", "color": Color(0.12, 0.16, 0.19), "size": Vector3(2.05, 0.82, 3.8), "roof": Vector3(1.65, 0.72, 2.0), "kind": "car"},
	{"name": "YELLOW-GREEN AUTO", "color": Color(0.12, 0.68, 0.32), "size": Vector3(1.45, 1.05, 2.1), "roof": Vector3(1.35, 0.52, 1.35), "kind": "auto"},
	{"name": "INDIAN TAXI", "color": Color(0.95, 0.72, 0.12), "size": Vector3(1.85, 0.65, 3.5), "roof": Vector3(1.4, 0.55, 1.7), "kind": "car"},
	{"name": "CITY DELIVERY VAN", "color": Color(0.88, 0.9, 0.92), "size": Vector3(1.9, 1.0, 3.5), "roof": Vector3(1.65, 0.45, 2.0), "kind": "van"}
]

func _ready() -> void:
	var positions := [
		Vector3(9, 0, -5), Vector3(13, 0, -5), Vector3(17, 0, -5),
		Vector3(-9, 0, -7), Vector3(-13, 0, -7), Vector3(-17, 0, -7)
	]
	for i in range(vehicle_specs.size()):
		_create_vehicle(vehicle_specs[i], positions[i], i == 3)

func _create_vehicle(spec: Dictionary, at: Vector3, auto_rickshaw: bool) -> void:
	var vehicle := Node3D.new()
	vehicle.name = str(spec["name"]).replace(" ", "_")
	vehicle.position = at
	add_child(vehicle)

	var body_size: Vector3 = spec["size"]
	var body_color: Color = spec["color"]
	_add_box(vehicle, "Body", body_size, Vector3(0, body_size.y * 0.5 + 0.38, 0), body_color)

	var roof_size: Vector3 = spec["roof"]
	var roof_z := -0.12
	if auto_rickshaw:
		roof_z = -0.05
	_add_box(vehicle, "Cabin", roof_size, Vector3(0, body_size.y + roof_size.y * 0.5 + 0.28, roof_z), body_color.darkened(0.12))

	var glass_material := StandardMaterial3D.new()
	glass_material.albedo_color = Color(0.12, 0.24, 0.3, 0.82)
	glass_material.metallic = 0.25
	glass_material.roughness = 0.22
	var glass_size := Vector3(roof_size.x * 0.88, roof_size.y * 0.52, 0.08)
	_add_box(vehicle, "FrontWindshield", glass_size, Vector3(0, body_size.y + roof_size.y * 0.55 + 0.28, -roof_size.z * 0.5 - 0.025), glass_material.albedo_color)
	_add_box(vehicle, "RearWindow", glass_size, Vector3(0, body_size.y + roof_size.y * 0.55 + 0.28, roof_size.z * 0.5 + 0.025), glass_material.albedo_color)

	var lamp_material := StandardMaterial3D.new()
	lamp_material.albedo_color = Color(1.0, 0.92, 0.65)
	for side in [-1.0, 1.0]:
		_add_box(vehicle, "Headlight", Vector3(0.22, 0.16, 0.06), Vector3(side * body_size.x * 0.34, 0.48, -body_size.z * 0.5 - 0.035), lamp_material.albedo_color)
		_add_wheel(vehicle, side * (body_size.x * 0.5 + 0.03), 0.32, body_size.z * 0.3)
		_add_wheel(vehicle, side * (body_size.x * 0.5 + 0.03), 0.32, -body_size.z * 0.3)

	if auto_rickshaw:
		_add_box(vehicle, "FrontPanel", Vector3(0.72, 0.48, 0.08), Vector3(0, 0.92, -body_size.z * 0.5 - 0.04), Color(0.08, 0.08, 0.08))
		_add_wheel(vehicle, 0, 0.28, -body_size.z * 0.5 - 0.05)
	else:
		_add_box(vehicle, "FrontGrille", Vector3(body_size.x * 0.34, 0.16, 0.06), Vector3(0, 0.48, -body_size.z * 0.5 - 0.04), Color(0.08, 0.09, 0.1))

func _add_box(parent: Node3D, node_name: String, box_size: Vector3, at: Vector3, tint: Color) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var box := BoxMesh.new()
	box.size = box_size
	mesh_instance.mesh = box
	mesh_instance.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.42
	mesh_instance.material_override = material
	parent.add_child(mesh_instance)

func _add_wheel(parent: Node3D, x: float, y: float, z: float) -> void:
	var wheel := MeshInstance3D.new()
	wheel.name = "Wheel"
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = 0.28
	cylinder.bottom_radius = 0.28
	cylinder.height = 0.18
	wheel.mesh = cylinder
	wheel.position = Vector3(x, y, z)
	wheel.rotation.z = PI * 0.5
	var rubber := StandardMaterial3D.new()
	rubber.albedo_color = Color(0.045, 0.045, 0.05)
	rubber.roughness = 0.9
	wheel.material_override = rubber
	parent.add_child(wheel)
