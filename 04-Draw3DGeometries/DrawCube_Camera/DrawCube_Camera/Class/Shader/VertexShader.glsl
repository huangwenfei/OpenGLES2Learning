#version 100

uniform mat4 u_ProjectionMat4;
uniform mat4 u_ModelViewMat4;

attribute vec4 a_Position;
attribute vec4 a_Color;

varying highp vec4 v_Color;

void main(void) {

    v_Color = a_Color;
    gl_Position = u_ProjectionMat4 * u_ModelViewMat4 * a_Position;
    
}