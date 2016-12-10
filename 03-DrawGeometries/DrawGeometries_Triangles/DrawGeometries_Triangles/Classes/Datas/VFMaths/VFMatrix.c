//
//  VFMatrix.c
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/15.
//  Copyright © 2016年 windy. All rights reserved.
//

#include "VFMatrix.h"
#include "VFVector.h"

/* 单位方阵 */
const VFMatrix2 VFMatrix2Identity = {
    1, 0,
    0, 1,
};

const VFMatrix3 VFMatrix3Identity = {
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
};

const VFMatrix4 VFMatrix4Identity = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
};

// __cplusplus 防止在 C++ 和 C 混编的时候，
// C++ 由于多态的存在，而修改函数名，导致出现不必要的错误；
#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark -
#pragma mark VFMatrix2 foos
#pragma mark -
    
    
#pragma mark - VFMatrix2 线性变换（Linear Transformation）
    
#pragma mark -
#pragma mark VFMatrix3 foos
#pragma mark -
    
    VFMatrix3 VFMatrix3Make(float m11, float m12, float m13,
                            float m21, float m22, float m23,
                            float m31, float m32, float m33) {
        
        VFMatrix3 _mat3 = {
        
            m11, m12, m13,
            m21, m22, m23,
            m31, m32, m33,
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeWith1DArray(float mat3[VFMATRIX3_1D_COMPONENTS]) {
        
        VFMatrix3 _mat3 = {
            
            mat3[0], mat3[1], mat3[2],
            mat3[3], mat3[4], mat3[5],
            mat3[6], mat3[7], mat3[8],
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeWith2DArray(float mat3[VFMATRIX3_2D_ROWS_COMPONENTS][VFMATRIX3_2D_COLUMNS_COMPONENTS]) {
        
        VFMatrix3 _mat3 = {
            
            mat3[0][0], mat3[0][1], mat3[0][2],
            mat3[1][0], mat3[1][1], mat3[1][2],
            mat3[2][0], mat3[2][1], mat3[2][2],
            
        };
        
        return _mat3;
        
    };
    
#pragma mark - VFMatrix3 线性变换（Linear Transformation）
    
    /* 旋转 */
    VFMatrix3 VFMatrix3MakeRotate(float angle, float rx, float ry, float rz) {
        
        float radian = RadianByAngle(angle);
        float sin    = sinf(radian);
        float cos    = cosf(radian);
        float cosp   = (1.f - cos);
        
        VFVector3 normaliedVec3 = VFVector3Normalied(VFVector3Make(rx, ry, rz));
        
        float m11 = normaliedVec3.x * normaliedVec3.x * cosp + cos;
        float m12 = normaliedVec3.x * normaliedVec3.y * cosp + normaliedVec3.z * sin;
        float m13 = normaliedVec3.x * normaliedVec3.z * cosp - normaliedVec3.y * sin;
        
        float m21 = normaliedVec3.x * normaliedVec3.y * cosp - normaliedVec3.z * sin;
        float m22 = normaliedVec3.y * normaliedVec3.y * cosp + cos;
        float m23 = normaliedVec3.y * normaliedVec3.z * cosp + normaliedVec3.x * sin;
        
        float m31 = normaliedVec3.x * normaliedVec3.z * cosp + normaliedVec3.y * sin;
        float m32 = normaliedVec3.y * normaliedVec3.z * cosp - normaliedVec3.x * sin;
        float m33 = normaliedVec3.z * normaliedVec3.z * cosp + cos;
        
        VFMatrix3 _mat3 = {
            
            m11, m12, m13,
            m21, m22, m23,
            m31, m32, m33,
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeRotateX(float angle) {
        
        float radian = RadianByAngle(angle);
        float sin    = sinf(radian);
        float cos    = cosf(radian);
        
        VFMatrix3 _mat3 = {
            
            1,   0 ,  0 ,
            0,  cos, sin,
            0, -sin, cos,
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeRotateY(float angle) {
    
        float radian = RadianByAngle(angle);
        float sin    = sinf(radian);
        float cos    = cosf(radian);
        
        VFMatrix3 _mat3 = {
            
            cos, 0, -sin,
             0 , 1,   0 ,
            sin, 0,  cos,
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeRotateZ(float angle) {
        
        float radian = RadianByAngle(angle);
        float sin    = sinf(radian);
        float cos    = cosf(radian);
        
        VFMatrix3 _mat3 = {
            
             cos, sin, 0,
            -sin, cos, 0,
              0 ,  0 , 1,
            
        };
        
        return _mat3;
        
    };
    
    /* 缩放 */
    VFMatrix3 VFMatrix3MakeScale(float scaleFactor, float x, float y, float z) {
        
        VFVector3 normaliedVec3 = VFVector3Normalied(VFVector3Make(x, y, z));
        
        float sx = normaliedVec3.x;
        float sy = normaliedVec3.y;
        float sz = normaliedVec3.z;
        
        float k = scaleFactor;
        
        VFMatrix3 _mat3 = {
            
            1 + (k - 1) * sx * sx,   (k - 1) * sx * sy,      (k - 1) * sx * sz,
              (k - 1) * sx * sy,   1 + (k - 1) * sy * sy,    (k - 1) * sy * sz,
              (k - 1) * sx * sz,     (k - 1) * sz * sy,    1 + (k - 1) * sz * sz,
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeXYZScale(float sx, float sy, float sz) {
        
        VFMatrix3 _mat3 = {
            
            sx,  0,  0,
            0, sy,  0,
            0,  0, sz,
            
        };
        
        return _mat3;
        
    };
    
    VFMatrix3 VFMatrix3MakeScaleX(float sx) {
        
        return VFMatrix3MakeXYZScale(sx, 1.f, 1.f);
        
    };
    
    VFMatrix3 VFMatrix3MakeScaleY(float sy) {
        
        return VFMatrix3MakeXYZScale(1.f, sy, 1.f);
        
    };
    
    VFMatrix3 VFMatrix3MakeScaleZ(float sz) {
        
        return VFMatrix3MakeXYZScale(1.f, 1.f, sz);
        
    };
    
#pragma mark -
#pragma mark VFMatrix4 foos
#pragma mark -
    
    VFMatrix4 VFMatrix4Make(float m11, float m12, float m13, float m14,
                            float m21, float m22, float m23, float m24,
                            float m31, float m32, float m33, float m34,
                            float m41, float m42, float m43, float m44) {
        
        VFMatrix4 _mat4 = {
            
            m11, m12, m13, m14,
            m21, m22, m23, m24,
            m31, m32, m33, m34,
            m41, m42, m43, m44,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeWith1DArray(float mat4[VFMATRIX4_1D_COMPONENTS]) {
        
        VFMatrix4 _mat4 = {
            
            mat4[0],  mat4[1],  mat4[2],  mat4[3],
            mat4[4],  mat4[5],  mat4[6],  mat4[7],
            mat4[8],  mat4[9],  mat4[10], mat4[11],
            mat4[12], mat4[13], mat4[14], mat4[15],
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeWith2DArray(float mat4[VFMATRIX4_2D_ROWS_COMPONENTS][VFMATRIX4_2D_COLUMNS_COMPONENTS]) {
        
        VFMatrix4 _mat4 = {
            
            mat4[0][0],  mat4[0][1],  mat4[0][2],  mat4[0][3],
            mat4[1][0],  mat4[1][1],  mat4[1][2],  mat4[1][3],
            mat4[2][0],  mat4[2][1],  mat4[2][2],  mat4[2][3],
            mat4[3][0],  mat4[3][1],  mat4[3][2],  mat4[3][3],
            
        };
        
        return _mat4;
        
    };
    
#pragma mark - VFMatrix4 四元数（Quaternion）
    
    
#pragma mark - VFMatrix4 线性变换（Linear Transformation）
    
    /* 旋转 */
    VFMatrix4 VFMatrix4MakeRotate(float angle, float rx, float ry, float rz) {
        
        VFMatrix3 r3 = VFMatrix3MakeRotate(angle, rx, ry, rz);
        
        VFMatrix4 _mat4 = {
            
            r3.m11, r3.m12, r3.m13, 0.f,
            r3.m21, r3.m22, r3.m23, 0.f,
            r3.m31, r3.m32, r3.m33, 0.f,
              0.f ,   0.f ,   0.f , 1.f,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeRotateX(float angle) {
        
        VFMatrix3 r3 = VFMatrix3MakeRotateX(angle);
        
        VFMatrix4 _mat4 = {
            
            r3.m11, r3.m12, r3.m13, 0.f,
            r3.m21, r3.m22, r3.m23, 0.f,
            r3.m31, r3.m32, r3.m33, 0.f,
              0.f ,   0.f ,   0.f , 1.f,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeRotateY(float angle) {
        
        VFMatrix3 r3 = VFMatrix3MakeRotateY(angle);
        
        VFMatrix4 _mat4 = {
            
            r3.m11, r3.m12, r3.m13, 0.f,
            r3.m21, r3.m22, r3.m23, 0.f,
            r3.m31, r3.m32, r3.m33, 0.f,
              0.f ,   0.f ,   0.f , 1.f,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeRotateZ(float angle) {
        
        VFMatrix3 r3 = VFMatrix3MakeRotateZ(angle);
        
        VFMatrix4 _mat4 = {
            
            r3.m11, r3.m12, r3.m13, 0.f,
            r3.m21, r3.m22, r3.m23, 0.f,
            r3.m31, r3.m32, r3.m33, 0.f,
              0.f ,   0.f ,   0.f , 1.f,
            
        };
        
        return _mat4;
        
    };
    
    /* 缩放 */
    VFMatrix4 VFMatrix4MakeScale(float scaleFactor, float x, float y, float z) {
        
        VFMatrix4 _mat4i = VFMatrix4Identity;
        
        VFMatrix3 _mat3 = VFMatrix3MakeScale(scaleFactor, x, y, z);
        
        VFMatrix4 _mat4 = {
            
            _mat3.m11,  _mat3.m12,  _mat3.m13,  _mat4i.m14,
            _mat3.m21,  _mat3.m22,  _mat3.m23,  _mat4i.m24,
            _mat3.m31,  _mat3.m32,  _mat3.m33,  _mat4i.m34,
            _mat4i.m41, _mat4i.m42, _mat4i.m43, _mat4i.m44,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeXYZScale(float sx, float sy, float sz) {
        
        VFMatrix4 r4 = VFMatrix4Identity;
        
        
        VFMatrix4 _mat4 = {
            
              sx  , r4.m12, r4.m13, r4.m14,
            r4.m21,   sy  , r4.m23, r4.m24,
            r4.m31, r4.m32,   sz  , r4.m34,
            r4.m41, r4.m42, r4.m43, r4.m44,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeScaleX(float sx) {
        
        return VFMatrix4MakeXYZScale(sx, 1.f, 1.f);
        
    };
    
    VFMatrix4 VFMatrix4MakeScaleY(float sy) {
        
        return VFMatrix4MakeXYZScale(1.f, sy, 1.f);
        
    };
    
    VFMatrix4 VFMatrix4MakeScaleZ(float sz) {
        
        return VFMatrix4MakeXYZScale(1.f, 1.f, sz);
        
    };
    
#pragma mark - VFMatrix4 平移（Translate）
    
    VFMatrix4 VFMatrix4MakeTranslation(float tx, float ty, float tz) {
        
        VFMatrix4 r4 = VFMatrix4Identity;
        
        VFMatrix4 _mat4 = {
            
            r4.m11, r4.m12, r4.m13, r4.m14,
            r4.m21, r4.m22, r4.m23, r4.m24,
            r4.m31, r4.m32, r4.m33, r4.m34,
              tx  ,   ty  ,   tz  , r4.m44,
            
        };
        
        return _mat4;
        
    };
    
    VFMatrix4 VFMatrix4MakeTranslationX(float tx) {
        
        return VFMatrix4MakeTranslation(tx, 0.f, 0.f);
        
    };
    
    VFMatrix4 VFMatrix4MakeTranslationY(float ty) {
        
        return VFMatrix4MakeTranslation(0.f, ty, 0.f);
        
    };
    
    VFMatrix4 VFMatrix4MakeTranslationZ(float tz) {
        
        return VFMatrix4MakeTranslation(0.f, 0.f, tz);
        
    };
    
#pragma mark - VFMatrix4 投影
    
#ifdef __cplusplus
}
#endif





