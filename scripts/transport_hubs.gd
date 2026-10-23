extends Node3D
## Stylized Indian airport and railway station landmarks for the prototype map.

func _ready() -> void:
	_build_airport(Vector3(-31, 0, -31))
	_build_railway_station(Vector3(31, 0, 31))

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	return material

func _box(parent: Node3D, label: String, size: Vector3, pos: Vector3, color: Color) -> MeshInstance3D:
	var item := MeshInstance3D.new()
	item.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	item.mesh = mesh
	item.position = pos
	item.material_override = _material(color)
	parent.add_child(item)
	return item

func _build_airport(origin: Vector3) -> void:
	var airport := Node3D.new()
	airport.name = "AgartalaAirport"
	airport.position = origin
	add_child(airport)
	_box(airport, "Terminal", Vector3(18, 4, 7), Vector3(0, 2, 0), Color(0.72, 0.76, 0.78))
	_box(airport, "GlassFront", Vector3(14, 1.8, 0.15), Vector3(0, 2.1, 3.58), Color(0.12, 0.35, 0.48))
	_box(airport, "Roof", Vector3(19, 0.45, 8), Vector3(0, 4.2, 0), Color(0.18, 0.24, 0.3))
	_box(airport, "DropOff", Vector3(20, 0.12, 5), Vector3(0, 0.06, 7), Color(0.22, 0.22, 0.23))
	_box(airport, "Runway", Vector3(32, 0.1, 8), Vector3(-2, 0.02, -10), Color(0.12, 0.13, 0.14))
	for i in range(7):
		_box(airport, "RunwayMark_%02d" % i, Vector3(1.5, 0.12, 0.18), Vector3(-15 + i * 4.2, 0.1, -10), Color(0.92, 0.92, 0.88))
	_box(airport, "AirportSign", Vector3(7, 1.2, 0.25), Vector3(0, 5.2, 4.3), Color(0.08, 0.28, 0.48))
	_box(airport, "ParkedAircraftBody", Vector3(7, 0.8, 1.1), Vector3(4, 1.5, -10), Color(0.88, 0.9, 0.92))
	_box(airport, "AircraftWing", Vector3(2.2, 0.12, 6), Vector3(4, 1.5, -10), Color(0.78, 0.82, 0.85))
	_box(airport, "AircraftTail", Vector3(1.2, 1.1, 0.2), Vector3(7, 2, -10), Color(0.8, 0.12, 0.08))

func _build_railway_station(origin: Vector3) -> void:
	var station := Node3D.new()
	station.name = "AgartalaRailwayStation"
	station.position = origin
	add_child(station)
	_box(station, "StationBuilding", Vector3(16, 4, 6), Vector3(0, 2, 0), Color(0.82, 0.72, 0.55))
	_box(station, "StationRoof", Vector3(17, 0.45, 7), Vector3(0, 4.2, 0), Color(0.55, 0.18, 0.12))
	_box(station, "StationSign", Vector3(8, 1.1, 0.2), Vector3(0, 4.7, 3.15), Color(0.05, 0.35, 0.18))
	for z_pos in [-6.0, -9.0]:
		_box(station, "Platform", Vector3(22, 0.35, 2.4), Vector3(0, 0.18, z_pos), Color(0.62, 0.63, 0.61))
		_box(station, "RailLine", Vector3(24, 0.12, 0.12), Vector3(0, 0.08, z_pos - 0.9), Color(0.18, 0.18, 0.2))
		_box(station, "RailLine", Vector3(24, 0.12, 0.12), Vector3(0, 0.08, z_pos + 0.9), Color(0.18, 0.18, 0.2))
	_box(station, "TrainEngine", Vector3(4, 2.1, 1.8), Vector3(-7, 1.3, -9), Color(0.08, 0.48, 0.24))
	_box(station, "TrainWindowBand", Vector3(4.1, 0.65, 1.86), Vector3(-7, 1.65, -9), Color(0.08, 0.18, 0.25))
	for i in range(3):
		_box(station, "TrainCoach_%02d" % i, Vector3(4.5, 1.8, 1.7), Vector3(-2.5 + i * 4.5, 1.15, -9), Color(0.78, 0.78, 0.72))
		_box(station, "CoachWindows_%02d" % i, Vector3(4.2, 0.55, 1.74), Vector3(-2.5 + i * 4.5, 1.45, -9), Color(0.08, 0.2, 0.28))
