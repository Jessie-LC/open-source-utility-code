vec3 srgbToLinear(in vec3 srgb) {
    return pow(srgb, vec3(2.2));
}

vec3 linearToSRGB(in vec3 linear) {
    return pow(linear, vec3(1.0/2.2));
}