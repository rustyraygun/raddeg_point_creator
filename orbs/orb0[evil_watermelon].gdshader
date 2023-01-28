shader_type spatial;
render_mode async_visible,blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D uv_offset_texture : hint_black;
uniform sampler2D albedo_texture : hint_albedo;
uniform vec4 albedo : hint_color;
uniform vec2 uv_offset_scale = vec2(-0.2, -0.1);
varying vec3 vertex_pos;
uniform float wave_speed: hint_range(0,1) = 0.1;
uniform vec2 uv_offset = vec2(-0.2, -0.1);
uniform sampler2D base_noise;
uniform vec2 time_base = vec2(0.3, 0.7);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
varying vec3 uv1_offset_movement;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;




void vertex() {
	vertex_pos = VERTEX;
	float vertex_y = UV.y/VERTEX.x * TIME;
	float noise = texture(uv_offset_texture, vertex_y * UV * 0.3).y;
	VERTEX.x += noise;
	VERTEX.y += noise/2.0;
	uv1_offset_movement += vec3(sin(TIME *0.10), uv1_offset.y/noise * sin(0.3) ,0.0);
	UV = UV*uv1_scale.xy+(uv1_offset.xy / uv1_offset_movement.xy) ;
}



void fragment() {
	vec2 uv_base_y = UV * uv_offset;
	uv_base_y += TIME * wave_speed;
	float red_ramp = texture(base_noise, wave_speed * uv_base_y).r;
	ALBEDO = vec3(red_ramp , sin(TIME * red_ramp) , 20.0);
	vec2 base_uv = UV;
    vec4 albedo_tex = texture(albedo_texture,base_uv);
    ALBEDO = albedo.rgb * albedo_tex.rgb;
//	albedo_tex += vec4(3.0,3.0,3.0, 1.0);
//	EMISSION = vec3(sin(TIME *0.0), 0.0, sin(TIME *0.3));
	ROUGHNESS =  0.5;

}
