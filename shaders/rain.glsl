// Rain shader for Ghostty terminal

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float hash13(vec3 p) {
    p = fract(p * vec3(0.1031, 0.1030, 0.0973));
    p += dot(p, p.yzx + 33.33);
    return fract((p.x + p.y) * p.z);
}

// Smooth noise for ripple displacement
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    float aspect = iResolution.x / iResolution.y;

    // --- Glass distortion from accumulated rain ---
    float distort = 0.0;
    distort += noise(uv * 30.0 + iTime * 0.3) * 0.0012;
    distort += noise(uv * 60.0 - iTime * 0.5) * 0.0006;
    vec2 sampleUV = uv + vec2(distort, distort * 0.5);
    fragColor = texture(iChannel0, sampleUV);

    // Slight darkening to simulate overcast / wet atmosphere
    fragColor.rgb *= mix(0.92, 1.0, uv.y);

    float rain = 0.0;
    float wind = 0.12;

    // --- Falling rain streaks (5 layers for depth) ---
    for (int layer = 0; layer < 5; layer++) {
        float fl = float(layer);
        float depth = fl / 4.0; // 0..1 near..far

        // Far layers: denser, dimmer, slower, thinner
        float density = mix(20.0, 80.0, depth);
        float speed = mix(800.0, 350.0, depth);
        float bright = mix(0.35, 0.10, depth);
        float streakLenBase = mix(25.0, 10.0, depth);
        float widthScale = mix(1.0, 0.4, depth);

        float cellW = iResolution.x / density;
        float cellH = mix(110.0, 60.0, depth);

        float yScroll = fragCoord.y - iTime * speed;
        float xShift = fragCoord.x - iTime * speed * wind;

        float col = floor(xShift / cellW);
        float row = floor(yScroll / cellH);
        float fx = xShift / cellW - col;
        float fy = yScroll / cellH - row;

        vec2 seed = vec2(col + fl * 73.0, row);
        float rx = hash(seed);
        float ry = hash(seed * 2.31);
        float rLen = hash(seed * 3.17);
        float rBright = hash(seed * 4.91);
        float rPhase = hash(seed * 5.63);
        float present = step(mix(0.55, 0.70, depth), hash(vec2(col * 17.3 + fl, row * 13.7)));

        // Vary streak length and brightness per drop
        float streakLen = streakLenBase * mix(0.6, 1.4, rLen);
        float brightness = bright * mix(0.5, 1.0, rBright);

        // Subtle speed variation per drop (gusts)
        float gustMod = 1.0 + 0.15 * sin(iTime * 2.0 + rPhase * 6.28);

        float cx = 0.2 + rx * 0.6;
        float dropStart = ry * (cellH - streakLen);
        float localY = fy * cellH - dropStart;

        float dx = abs(fx - cx) * cellW;

        // Streak with hard, solid appearance
        float inStreak = step(0.0, localY) * step(localY, streakLen);
        float progress = clamp(localY / streakLen, 0.0, 1.0);
        // Minimal fade — just soften the very tips
        float taper = smoothstep(0.0, 0.1, progress) * smoothstep(1.0, 0.85, progress);

        // Uniform width along the streak
        float w = 0.8 * widthScale;
        float shape = step(dx, w) * inStreak * taper;

        rain += shape * present * brightness * gustMod;
    }

    // Cool blue-white rain color with slight variation per-pixel
    vec3 rainColor = vec3(0.6, 0.72, 1.0);
    rainColor += 0.05 * noise(fragCoord.xy * 0.1 + iTime);

    fragColor.rgb += rain * rainColor;
}
