
#version 100

uniform mat4 u_modelViewMat4;
uniform mat4 u_projectionMat4;

attribute vec4 a_position;
attribute vec2 a_texCoord;

varying highp vec2 v_texCoord;

void main(void) {
    gl_Position = u_projectionMat4 * u_modelViewMat4 * a_position;
    v_texCoord  = a_texCoord;
}
