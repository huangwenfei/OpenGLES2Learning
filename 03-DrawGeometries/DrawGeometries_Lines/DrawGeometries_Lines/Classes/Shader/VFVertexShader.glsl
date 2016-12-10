
#version 100

attribute vec4 v_Position;
uniform mat4 v_Projection;

attribute vec4 v_Color;
varying mediump vec4 f_color;

void main(void) {
    f_color = v_Color;
    gl_Position = v_Projection * v_Position; // True, Left Dot Mul
}

//void main(void) {uniform mat4 v_Translation;
//    f_color = v_Color;
//    // A · (B · v) === (A · B) · v (A、B is Matrix, v is Vector)
//    gl_Position = v_Translation * v_Projection * v_Position;    // True, Left Dot Mul
////    gl_Position = v_Projection * v_Translation * v_Position;    // True, Left Dot Mul
////    gl_Position = v_Position * v_Projection * v_Translation;  // False, Right Dot Mul
////    gl_Position = v_Position * v_Translation * v_Projection;  // False, Right Dot Mul
//}