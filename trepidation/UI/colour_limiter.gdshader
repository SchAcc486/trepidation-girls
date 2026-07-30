shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float PIXEL_SIZE = 512.0;

void fragment() {
	//highp vec2 pos = floor(UV * PIXEL_SIZE) / PIXEL_SIZE;
	vec2 pos = UV;
	pos.x = floor(pos.x * 1024.0) / 1024.0;
	pos.y = floor(pos.y * 576.0) / 576.0;
	COLOR.rgb = texture(SCREEN_TEXTURE, pos).rgb;
	COLOR = floor(COLOR * 16.0) / 16.0;
	}