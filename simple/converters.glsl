vec3 screenSpaceToViewSpace(vec3 screenPosition, mat4 projectionInverse) {
	screenPosition = screenPosition * 2.0 - 1.0;

	vec3 viewPosition  = vec3(vec2(projectionInverse[0].x, projectionInverse[1].y) * screenPosition.xy + projectionInverse[3].xy, projectionInverse[3].z);

    viewPosition /= projectionInverse[2].w * screenPosition.z + projectionInverse[3].w;

	return viewPosition;
}

float screenSpaceToViewSpace(float depth, mat4 projectionInverse) {
	depth = depth * 2.0 - 1.0;
	return projectionInverse[3].z / (projectionInverse[2].w * depth + projectionInverse[3].w);
}

vec3 viewSpaceToScreenSpace(vec3 viewPosition, mat4 projection) {
	vec3 screenPosition  = vec3(projection[0].x, projection[1].y, projection[2].z) * viewPosition + projection[3].xyz;
	     screenPosition /= -viewPosition.z;

	return screenPosition * 0.5 + 0.5;
}

float viewSpaceToScreenSpace(float depth, mat4 projection) {
	return ((projection[2].z * depth + projection[3].z) / -depth) * 0.5 + 0.5;
}

vec3 viewSpaceToSceneSpace(in vec3 viewPosition, in mat4 modelViewInverse) {
    return mat3(modelViewInverse) * viewPosition + modelViewInverse[3].xyz;
}

vec3 sceneSpaceToShadowView(in vec3 scenePosition, in mat4 shadowMV) {
    return mat3(shadowMV) * scenePosition + shadowMV[3].xyz;
}

vec3 shadowViewToShadowClip(in vec3 shadowView, in mat4 shadowProj) {
    return mat3(shadowProj) * shadowView + shadowProj[3].xyz;
}