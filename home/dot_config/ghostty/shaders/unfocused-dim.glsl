// Unfocused dim — the surface recedes when it loses focus and eases back on
// return, so the active window is obvious at a glance.
//
// Ghostty custom shader, Shadertoy form. Uniforms used:
//   iChannel0   - the rendered terminal, RGBA
//   iFocus      - 1 when this surface is focused, 0 when it is not
//   iTimeFocus  - value of iTime when focus last changed
//   iTime, iResolution
//
// Keep this LAST in the custom-shader chain so it dims everything the earlier
// passes drew, cursor trail and bloom included.

const float DIM        = 0.45;  // brightness kept while unfocused (1.0 = none)
const float DESATURATE = 0.50;  // 0 = keep color, 1 = fully grey while unfocused
const float FADE       = 0.25;  // transition length, in seconds

float luma(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);

    // iTimeFocus marks the moment focus flipped, so this eases in both
    // directions: start from the previous state, settle on the current one.
    float t      = clamp((iTime - iTimeFocus) / FADE, 0.0, 1.0);
    float eased  = t * t * (3.0 - 2.0 * t);
    float target = (iFocus > 0) ? 1.0 : 0.0;
    float amount = 1.0 - mix(1.0 - target, target, eased);  // 0 focused, 1 unfocused

    vec3 col = mix(base.rgb, vec3(luma(base.rgb)), DESATURATE * amount);
    col *= mix(1.0, DIM, amount);

    // Alpha untouched: dimming must not make the window more or less opaque.
    fragColor = vec4(col, base.a);
}
