extends Node3D
## Lightweight moving traffic prototype. Cars loop along two lanes on the generated road.
var traffic_cars: Array[Dictionary] = []
var road_length: float = 82.0

func _ready() -> void:
	_build_roads()
	_spawn_traffic()

func _process(delta: float) -> void:
	for item in traffic_cars:
		var car: Node3D = item["node"]
		car.position.x += float(item["speed"]) * delta
		if car.position.x > road_length * 0.5:
			car.position.x = -road_length * 0.5

func _build_roads() -> void:
	var road_mat := StandardMaterial3D.new()
	road_mat.albedo_color = Color(0.12, 0.13, 0.15)
	var line_mat := StandardMaterial3D.new()
	line_mat.albedo_color = Color(0.95, 0.82, 0.24)
	for z_pos in [-15.0, 15.0]:
		var road := MeshInstance3D.new()
		var road_mesh := BoxMesh.new()
		road_mesh.size = Vector3(road_length, 0.08, 8.0)
		road.mesh = road_mesh
		road.position = Vector3(0, 0.03, z_pos)
		road.material_override = road_mat
		add_child(road)
		var line := MeshInstance3D.new()
		var line_mesh := BoxMesh.new()
		line_mesh.size = Vector3(road_length, 0.09, 0.12)
		line.mesh = line_mesh
		line.position = Vector3(0, 0.09, z_pos)
		line.material_override = line_mat
		add_child(line)

func _spawn_traffic() -> void:
	var colors: Array[Color] = [Color(0.8, 0.12, 0.08), Color(0.12, 0.35, 0.85), Color(0.9, 0.9, 0.86), Color(0.12, 0.55, 0.25), Color(0.85, 0.55, 0.08), Color(0.16, 0.16, 0.18)]
	for i in range(6):
		var car := Node3D.new()
		car.name = "TrafficCar_%02d" % i
		var body := MeshInstance3D.new()
		var body_mesh := BoxMesh.new()
		body_mesh.size = Vector3(3.0, 1.0, 1.6)
		body.mesh = body_mesh
		body.position.y = 0.65
		var body_mat := StandardMaterial3D.new()
		body_mat.albedo_color = colors[i]
		body.material_override = body_mat
		car.add_child(body)
		var cabin := MeshInstance3D.new()
		var cabin_mesh := BoxMesh.new()
		cabin_mesh.size = Vector3(1.5, 0.65, 1.3)
		cabin.mesh = cabin_mesh
		cabin.position = Vector3(-0.15, 1.35, 0)
		var glass := StandardMaterial3D.new()
		glass.albedo_color = Color(0.08, 0.16, 0.22)
		cabin.material_override = glass
		car.add_child(cabin)
		var wheel_mat := StandardMaterial3D.new()
		wheel_mat.albedo_color = Color(0.06, 0.06, 0.07)
		for wx in [-0.9, 0.9]:
			for wz in [-0.83, 0.83]:
				var wheel := MeshInstance3D.new()
				var wheel_mesh := CylinderMesh.new()
				wheel_mesh.top_radius = 0.28
				wheel_mesh.bottom_radius = 0.28
				wheel_mesh.height = 0.18
				wheel.mesh = wheel_mesh
				wheel.rotation_degrees.z = 90
				wheel.position = Vector3(wx, 0.32, wz)
				wheel.material_override = wheel_mat
				car.add_child(wheel)
		var lane_z := -15.0 if i % 2 == 0 else 15.0
		var lane_x := -36.0 + float(i) * 12.0
		car.position = Vector3(lane_x, 0, lane_z + (1.5 if i % 2 == 0 else -1.5))
		add_child(car)
		traffic_cars.append({"node": car, "speed": 5.0 + float(i % 3) * 1.5})
