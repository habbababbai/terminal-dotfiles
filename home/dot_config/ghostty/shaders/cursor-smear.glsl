// Cursor smear — when the cursor moves, it stretches into a streak reaching
// back to where it was, then collapses into the cursor over ~0.2s.
//
// Ghostty custom shader, Shadertoy form. Uniforms used (Ghostty 1.3.1):
//   iChannel0           - the rendered terminal, RGBA
//   iCurrentCursor      - .xy = (min-X, max-Y) corner in px, .zw = width, height
//   iPreviousCursor     - same, for the position before the last move
//   iCurrentCursorColor - cursor color, RGBA
//   iTimeCursorChange   - value of iTime when the cursor last changed
//   iTime, iResolution
//
// Tuning: DURATION is how long the streak takes to catch up, INTENSITY is how
// strongly it is painted over the terminal. Both are safe to edit live —
// Ghostty recompiles shaders on config reload.

const float DURATION  = 0.20;
const float INTENSITY = 0.55;
const float SOFTNESS  = 1.5;   // edge feather, in pixels

// Signed distance to an axis-aligned box centred on the origin.
float sdBox(vec2 p, vec2 halfSize) {
    vec2 d = abs(p) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Centre of a Ghostty cursor rect. .xy is the min-X / max-Y corner and the
// coordinate space is Y-up, so the box extends right and downward from it.
vec2 cursorCenter(vec4 c) {
    return vec2(c.x + c.z * 0.5, c.y - c.w * 0.5);
}

float easeOutCubic(float t) {
    return 1.0 - pow(1.0 - t, 3.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);

    vec2 curCenter  = cursorCenter(iCurrentCursor);
    vec2 prevCenter = cursorCenter(iPreviousCursor);
    vec2 halfSize   = iCurrentCursor.zw * 0.5;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);

    // The tail slides from the old position to the new one, so the streak has
    // shrunk to exactly the cursor by the time the animation ends.
    vec2 tail = mix(prevCenter, curCenter, easeOutCubic(t));

    // Minkowski sum of the segment tail->curCenter with the cursor box. This
    // is the smear silhouette: the cursor rect swept along its own path.
    vec2 pa = fragCoord - tail;
    vec2 ba = curCenter - tail;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-6), 0.0, 1.0);
    float dist = sdBox(pa - ba * h, halfSize);

    float edge = 1.0 - smoothstep(0.0, SOFTNESS, dist);
    float fade = (1.0 - t) * INTENSITY;

    // Only smear on an actual move. Without this, anything else that updates
    // the cursor in place (blinking, style changes at the prompt) would pulse
    // a streak of zero length on the spot.
    float moved = smoothstep(0.5, 3.0, length(curCenter - prevCenter));

    fragColor = mix(base, vec4(iCurrentCursorColor.rgb, 1.0), edge * fade * moved);
}
