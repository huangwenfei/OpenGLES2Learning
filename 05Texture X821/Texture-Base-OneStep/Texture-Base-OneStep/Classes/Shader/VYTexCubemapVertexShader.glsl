
#version 100

uniform mat4 u_modelViewMat4;
uniform mat4 u_projectionMat4;

attribute vec4 a_position;
attribute vec4 a_normalCoord;

varying highp vec4 v_normalCoord;

void main(void) {
    gl_Position = u_projectionMat4 * u_modelViewMat4 * a_position;
    v_normalCoord  = a_normalCoord;
}
