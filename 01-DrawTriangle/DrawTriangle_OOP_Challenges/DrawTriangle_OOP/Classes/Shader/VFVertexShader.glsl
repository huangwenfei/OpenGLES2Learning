
#version 100

attribute vec4 v_Position;
attribute vec4 v_Color;

varying mediump vec4 f_color;

void main(void) {
    f_color = v_Color;
    gl_Position = v_Position;
}