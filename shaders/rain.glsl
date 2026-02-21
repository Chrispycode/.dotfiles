// Rain shader for Ghostty terminal

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    float rain = 0.0;
    float wind = 0.15; // slight angle

    for (int layer = 0; layer < 3; layer++) {
        float fl = float(layer);
        float density = 30.0 + fl * 12.0;
        float baseSpeed = 350.0 + fl * 200.0;
        float baseBright = 0.10 - fl * 0.025;

        float cellW = iResolution.x / density;
        float cellH = 90.0 + fl * 30.0;

        // Scroll with wind offset
        float yScroll = fragCoord.y + iTime * baseSpeed;
        float xShift = fragCoord.x - iTime * baseSpeed * wind;

        float col = floor(xShift / cellW);
        float row = floor(yScroll / cellH);

        float fx = xShift / cellW - col;
        float fy = yScroll / cellH - row;

        // Per-drop randomization
        vec2 seed = vec2(col + fl * 73.0, row);
        float rx = hash(seed);
        float ry = hash(seed * 2.31);
        float rLen = hash(seed * 3.17);
        float rBright = hash(seed * 4.91);
        float present = step(0.7, hash(vec2(col * 17.3 + fl, row * 13.7)));

        // Vary streak length and brightness per drop
        float streakLen = mix(12.0, 35.0, rLen);
        float brightness = baseBright * mix(0.4, 1.0, rBright);

        // Drop center with jitter
        float cx = 0.25 + rx * 0.5;
        float dropStart = ry * (cellH - streakLen);
        float localY = fy * cellH - dropStart;

        // Pixel distance from streak center
        float dx = abs(fx - cx) * cellW;

        // Streak shape with smooth fade at both ends
        float inStreak = step(0.0, localY) * step(localY, streakLen);
        float fadeIn = smoothstep(0.0, streakLen * 0.2, localY);
        float fadeOut = smoothstep(streakLen, streakLen * 0.7, localY);
        float taper = fadeIn * fadeOut;

        // Width varies: thinner at tail, slightly wider at leading edge
        float w = mix(0.4, 1.0, localY / streakLen);
        float shape = smoothstep(w, w * 0.2, dx) * inStreak * taper;

        rain += shape * present * brightness;
    }

    vec3 rainColor = vec3(0.65, 0.75, 1.0);
    fragColor.rgb += rain * rainColor;
}
