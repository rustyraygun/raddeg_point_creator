shader_type spatial;
render_mode unshaded;
uniform vec4 _screen_uv;
varying vec2 p;
uniform float dx;
uniform float dy;
varying float d;
varying float luma;
uniform sampler2D albedo_texture : hint_albedo;

//
//float lookup(vec2 p, float dx, float dy)
//{
//    vec2 uv = (p.xy + vec2(dx * d, dy * d)) / scree.xy;
//    vec4 c = texture(iChannel0, uv.xy);
//
//	// return as luma
//    return 0.2126*c.r + 0.7152*c.g + 0.0722*c.b;
//}
void _luma() {
	
}
void fragment () {
	vec2 uv = (p.xy + vec2(dx * d, dy * d)) / SCREEN_UV.xy;
	vec4 c = texture(albedo_texture, uv.xy);
	luma = 0.2126*c.r + 0.7152*c.g + 0.0722*c.b;
	
	d = sin(TIME * 5.0)*0.5 + 1.5;
    p = FRAGCOORD.xy;
	
	float frag_coord;
	vec2 luma_r_texture;
	vec4 luma_texture;
	float luma_rgb;
	//____
	float gx = 0.0;
	//+++GX+++++
	luma_r_texture = (FRAGCOORD.xy + vec2(-1.0 * d, -1.0 * d)) / SCREEN_UV.xy ;
	luma_texture = texture(albedo_texture, uv.xy);
	luma_rgb = 0.2126*luma_texture.r + 0.7152*luma_texture.g + 0.0722*luma_texture.b;
    gx += -1.0 * luma_rgb;
	
	luma_r_texture = (FRAGCOORD.xy + vec2(-1.0 * d, 0.0 * d)) / SCREEN_UV.xy ;
	luma_texture = texture(albedo_texture, uv.xy);
	luma_rgb = 0.2126*luma_texture.r + 0.7152*luma_texture.g + 0.0722*luma_texture.b;
    gx += -1.0 * luma_rgb;
	
	luma_r_texture = (FRAGCOORD.xy + vec2(-1.0 * d, 1.0 * d)) / SCREEN_UV.xy ;
	luma_texture = texture(albedo_texture, uv.xy);
	luma_rgb = 0.2126*luma_texture.r + 0.7152*luma_texture.g + 0.0722*luma_texture.b;
    gx += -1.0 * luma_rgb;
	//+++GY+++++
	float gy = 0.0;
	luma_r_texture = (FRAGCOORD.xy + vec2(-1.0 * d, -1.0 * d)) / SCREEN_UV.xy ;
	luma_texture = texture(albedo_texture, uv.xy);
	luma_rgb = 0.2126*luma_texture.r + 0.7152*luma_texture.g + 0.0722*luma_texture.b;
    gy += -2.0 * luma_rgb;
	//___
	float g = gx*gx + gy*gy;
    float g2 = g * (sin(TIME) / 2.0 + 0.5);
    
    vec4 col = texture(albedo_texture, p / SCREEN_UV.xy);
    col += vec4(0.0, g, g2, 1.0);

	ALBEDO = vec3(col.r, col.g, col.b);
	
}