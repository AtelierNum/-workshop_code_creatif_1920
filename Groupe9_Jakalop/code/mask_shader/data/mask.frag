#ifdef GL_ES
  precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

    
// viewport resolution (in pixels)
uniform vec2  sketchSize;   
// Resolution of the textures
uniform vec2 topLayerResolution;
uniform vec2 maskResolution;

// Textures to blend
uniform sampler2D topLayer;    // Source (top layer)
uniform sampler2D maskImage;    // Destination (bottom layer)



void main(void)
{

 

  	vec2 uv = gl_FragCoord.xy / sketchSize.xy * vec2(1.0,-1.0) + vec2(0.0, 1.0);

 
	vec2 sPos = vec2( gl_FragCoord.x / topLayerResolution.x, (gl_FragCoord.y / topLayerResolution.y) );
	vec4 s = texture2D(topLayer, sPos ).rgba;
	
    vec2 dPos = vec2( gl_FragCoord.x / maskResolution.x,  (gl_FragCoord.y / maskResolution.y) );
	vec4 d = texture2D(maskImage, dPos ).rgba;


	vec4 color = vec4(0.0);

	color = mix(s.rgba, vec4(0., 0., 0., d.a), 1. - (d.r+d.g+d.b)*0.33333);


  	gl_FragColor = vec4(color.rgb ,1.0); 
}