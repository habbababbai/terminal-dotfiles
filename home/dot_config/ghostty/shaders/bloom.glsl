// Bloom — bright glyphs bleed a soft halo into their surroundings.
//
// Deliberately restrained: at 12pt a strong bloom eats the counters of small
// glyphs and makes text mushy. Raise INTENSITY / RADIUS to taste, but check
// lowercase "e" and "a" at your font size before committing to it.
//
// Ghostty custom shader, Shadertoy form. Uniforms used: iChannel0, iResolution.

const int   TAPS      = 16;    // raise with RADIUS, or the spiral starts banding
const float THRESHOLD = 0.40;  // luminance above which a pixel starts glowing
const float INTENSITY = 0.60;  // how much glow is added back on top
const float RADIUS    = 4.5;   // glow reach, in pixels

const float GOLDEN_ANGLE = 2.39996323;

float luma(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 texel = 1.0 / iResolution.xy;
    vec2 uv    = fragCoord * texel;
    vec4 base  = texture(iChannel0, uv);

    // Golden-angle spiral: even coverage of the disc for very few samples,
    // without the banding a square kernel would give at this tap count.
    vec3  glow  = vec3(0.0);
    float total = 0.0;

    for (int i = 0; i < TAPS; i++) {
        float fi    = float(i) + 0.5;
        float r     = RADIUS * sqrt(fi / float(TAPS));
        float angle = fi * GOLDEN_ANGLE;

        // Not named `sample` — that is a reserved keyword in modern GLSL.
        vec4 samp = texture(iChannel0, uv + vec2(cos(angle), sin(angle)) * r * texel);

        float weight = 1.0 - (r / RADIUS) * 0.75;
        float bright = max(luma(samp.rgb) - THRESHOLD, 0.0) / max(1.0 - THRESHOLD, 1e-4);

        // Weighting by the sample's alpha keeps the translucent background
        // from bleeding into the glow on a transparent window.
        glow  += samp.rgb * bright * samp.a * weight;
        total += weight;
    }

    glow /= max(total, 1e-4);

    // Screen blend instead of straight addition. At this intensity plain
    // addition drives bright glyphs past 1.0 and clips them to flat white,
    // which throws away the Rose Pine hues; screening approaches 1.0 without
    // ever overshooting, so strong glow keeps its color.
    vec3 added = glow * INTENSITY;

    // Alpha is passed through untouched so background-opacity/blur survive.
    fragColor = vec4(base.rgb + added * (1.0 - base.rgb), base.a);
}
