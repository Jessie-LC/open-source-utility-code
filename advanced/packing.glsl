// Octahedral Unit Vector encoding
// Intuitive, fast, and has very little error.
vec2 encodeUnitVector(vec3 vector) {
	// Scale down to octahedron, project onto XY plane
	vector.xy /= abs(vector.x) + abs(vector.y) + abs(vector.z);
	// Reflect -Z hemisphere folds over the diagonals
	return vector.z <= 0.0 ? (1.0 - abs(vector.yx)) * vec2(vector.x >= 0.0 ? 1.0 : -1.0, vector.y >= 0.0 ? 1.0 : -1.0) : vector.xy;
}

vec3 decodeUnitVector(vec2 encoded) {
	// Exctract Z component
	vec3 vector = vec3(encoded, 1.0 - abs(encoded.x) - abs(encoded.y));
	// Reflect -Z hemisphere folds over the diagonals
	float t = max(-vector.z, 0.0);
	vector.xy += vec2(vector.x >= 0.0 ? -t : t, vector.y >= 0.0 ? -t : t);
	// Normalize and return
	return normalize(vector);
}

vec4 encodeRGBE8(vec3 rgb) {
    float exponentPart = floor(log2(max(max(rgb.r, rgb.g), max(rgb.b, exp2(-127.0))))); // can remove the clamp to above exp2(-127) if you're sure you're not going to input any values below that
    vec3  mantissaPart = clamp((128.0 / 255.0) * exp2(-exponentPart) * rgb, 0.0, 1.0);
          exponentPart = clamp(exponentPart / 255.0 + (127.0 / 255.0), 0.0, 1.0);

    return vec4(mantissaPart, exponentPart);
}

vec3 decodeRGBE8(vec4 rgbe) {
    cFloat add = log2(255.0 / 128.0) - 127.0;
    return exp2(rgbe.a * 255.0 + add) * rgbe.rgb;
}



float packUnorm2x4(vec2 xy) {
	return dot(floor(15.0 * xy + 0.5), vec2(1.0 / 255.0, 16.0 / 255.0));
}
float packUnorm2x4(float x, float y) { return packUnorm2x4(vec2(x, y)); }
vec2 unpackUnorm2x4(float pack) {
	vec2 xy; xy.x = modf(pack * 255.0 / 16.0, xy.y);
	return xy * vec2(16.0 / 15.0, 1.0 / 15.0);
}
float unpackUnorm2x4X(float pack) { return fract(pack * 255.0 / 16.0) * 16.0 / 15.0; }
float unpackUnorm2x4Y(float pack) { return floor(pack * 255.0 / 16.0) / 15.0; }

float packUnorm2x8(vec2 xy) {
	return dot(floor(255.0 * xy + 0.5), vec2(1.0 / 65535.0, 256.0 / 65535.0));
}
float packUnorm2x8(float x, float y) { return packUnorm2x8(vec2(x, y)); }
vec2 unpackUnorm2x8(float pack) {
	vec2 xy; xy.x = modf(pack * 65535.0 / 256.0, xy.y);
	return xy * vec2(256.0 / 255.0, 1.0 / 255.0);
}
float unpackUnorm2x8X(float pack) { return fract(pack * 65535.0 / 256.0) * 256.0 / 255.0; }
float unpackUnorm2x8Y(float pack) { return floor(pack * 65535.0 / 256.0) / 255.0; }

float packSnorm2x8(vec2 xy) {
	vec2 xy2 = floor(mix(128.5 + 127.0 * xy, 127.5 + 127.0 * xy, greaterThan(xy, vec2(0.0))));
	return dot(xy2, vec2(1.0 / 65535.0, 256.0 / 65535.0));
}
float packSnorm2x8(float x, float y) { return packSnorm2x8(vec2(x, y)); }
vec2 UnpackSnorm2x8(float pack) {
	vec2 xy; xy.x = modf(pack * 65535.0 / 256.0, xy.y);
	return xy * vec2(256.0 / 127.0, 1.0 / 127.0) - mix(vec2(1.0), vec2(128.0 / 127.0), greaterThan(xy, vec2(127.5 / 256.0, 127.5)));
}
float unpackSnorm2x8X(float pack) { return unpackSnorm2x8(pack).x; }
float unpackSnorm2x8Y(float pack) { return unpackSnorm2x8(pack).y; }