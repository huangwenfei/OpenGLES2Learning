
#version 100

uniform mat4 u_modelViewMat4;
uniform mat4 u_projectionMat4;

attribute vec4 a_position;
//ERROR: Writed To vec4
attribute vec3 a_normalCoord;
//ERROR: Writed To vec4
varying highp vec3 v_normalCoord;

void main(void) {
    gl_Position = u_projectionMat4 * u_modelViewMat4 * a_position;
    v_normalCoord  = a_normalCoord;
}
