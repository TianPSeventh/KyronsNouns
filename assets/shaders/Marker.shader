shader_type spatial;

render_mode blend_mix,depth_draw_alpha_prepass,cull_disabled,diffuse_burley,specular_schlick_ggx,unshaded,shadows_disabled,ambient_light_disabled;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular = 0.5;
uniform float metallic = 0;
uniform float distance_fade_min = 2;
uniform float distance_fade_max = 5.0;
uniform float roughness : hint_range(0,1) = 1;
uniform float point_size : hint_range(0,128) = 1;
uniform vec2 number_of_frame = vec2(1,1);
uniform vec2 current_frame = vec2(0,0);
uniform bool bounce = true;
uniform bool rotate = false;
uniform bool visible = true;

vec2 rotate2D(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(vec2(c,-s),vec2(s,c)) * v;
}

void vertex() {
	if (!visible)
		UV = vec2(0.0);
	else{
		MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],WORLD_MATRIX[1],vec4(normalize(cross(CAMERA_MATRIX[0].xyz,WORLD_MATRIX[1].xyz)), 0.0),WORLD_MATRIX[3]);
		MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(1.0, 0.0, 0.0, 0.0),vec4(0.0, 1.0/length(WORLD_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0),vec4(0.0, 0.0, 0.0 ,1.0));
		if (bounce) VERTEX.y -= abs(sin(TIME))*0.5;
		if (rotate) VERTEX.xz = rotate2D(VERTEX.xz, TIME);
	}
}


void fragment() {
	if (visible){
		vec2 base_uv = (UV + current_frame) / number_of_frame;
		vec4 albedo_tex = texture(texture_albedo, base_uv) * COLOR * albedo;
		
		ALBEDO = albedo_tex.rgb;
		METALLIC = metallic;
		ROUGHNESS = roughness;
		SPECULAR = specular;
		ALPHA = albedo_tex.a * clamp(smoothstep(distance_fade_min,distance_fade_max,-VERTEX.z),0.0,1.0);
	}else
		ALPHA = 0.0;
}
