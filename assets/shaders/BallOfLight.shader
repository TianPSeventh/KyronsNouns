shader_type spatial;
render_mode unshaded, cull_disabled, shadows_disabled;



// GlobalExpression:0
	uniform float lifeTime : hint_range(0,1) = 1.0;
	uniform vec4 albedo : hint_color = vec4(1.0,1.0,1.0,1.0);
	uniform float Saturation: hint_range(0.5,1) = 1.0;
	uniform float Opacity : hint_range(0,1) = 1.0;

void vertex() {
	float n_out4p0 = TIME;
	float checkLife = floor(lifeTime);
	vec3 pulse = VERTEX*((vec3(0.1 ,0.1 ,0.1)*((checkLife == 0.0)? (1.0 - lifeTime)*10.0+2.0 : sin(n_out4p0*2.0)))+vec3(1.0, 1.0, 1.0)+((albedo.rgb == vec3(0.0, 0.0, 0.0)? vec3(0.2, 0.2, 0.2) : vec3(0.0, 0.0, 0.0))));
	pulse.y += (sin(n_out4p0)*0.2)*checkLife;
	VERTEX = pulse;
}

void fragment() {
	ALBEDO = albedo.rbg;
	float normal_dot = dot(NORMAL, vec3(0,0,1));
	normal_dot = max(normal_dot, 0.0);
	float arc = asin(normal_dot*Saturation)/0.785398;
	arc = pow(arc,10);
	float alpha_value = arc*albedo.a*Opacity;
	alpha_value = min(Opacity, alpha_value);
	ALPHA = (alpha_value*lifeTime);
}
