shader_type canvas_item;
uniform int pixelSize = 1;
void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += cos(TIME) * (VERTEX.y - 10.0) * 0.3; 
}
void fragment() {
// Called for every pixel the material is visible on.
}

