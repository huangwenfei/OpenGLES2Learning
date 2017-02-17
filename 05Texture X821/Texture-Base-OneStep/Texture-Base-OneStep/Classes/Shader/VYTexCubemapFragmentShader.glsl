
#version 100

//ERROR: Writed To sampler2D
uniform samplerCube us2d_texture;
//ERROR: Writed To vec4
varying highp vec3 v_normalCoord;

void main(void) {
//    gl_FragColor = vec4(1, 1, 0.5, 1);
    gl_FragColor = textureCube(us2d_texture, v_normalCoord);
}
