
#version 100

uniform sampler2D us2d_texture;

varying highp vec2 v_texCoord;

void main(void) {
//    gl_FragColor = vec4(1, 1, 0.5, 1);
    gl_FragColor = texture2D(us2d_texture, v_texCoord);
}
