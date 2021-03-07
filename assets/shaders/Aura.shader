shader_type spatial;
render_mode blend_mix,depth_draw_alpha_prepass,cull_disabled,diffuse_burley,specular_schlick_ggx,unshaded,shadows_disabled;

uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular = 0.5;
uniform float metallic;
uniform float roughness : hint_range(0,1) = 1;
uniform float point_size : hint_range(0,128) = 1;


void fragment() {
	vec2 base_uv = UV;
	base_uv.y *= clamp((sin(TIME)+1.0)/2.0, 0.6, 0.99);
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo.a * albedo_tex.a;
}
