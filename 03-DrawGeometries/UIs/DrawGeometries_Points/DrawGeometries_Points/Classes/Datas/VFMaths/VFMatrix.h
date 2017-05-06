//
//  VFMatrix.h
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/15.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFMatrix_h
#define VFMatrix_h

#include <stdio.h>
#include "VFMathTypes.h"

/* 初值 */
extern const VFMatrix2 VFMatrix2Identity;
extern const VFMatrix3 VFMatrix3Identity;
extern const VFMatrix4 VFMatrix4Identity;

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
                            float m31, float m32, float m33);
    
    VFMatrix3 VFMatrix3MakeWith1DArray(float mat3[VFMATRIX3_1D_COMPONENTS]);
    
    VFMatrix3 VFMatrix3MakeWith2DArray(float mat3[VFMATRIX3_2D_ROWS_COMPONENTS][VFMATRIX3_2D_COLUMNS_COMPONENTS]);
    
#pragma mark - VFMatrix3 线性变换（Linear Transformation）
    
    /* 旋转 */
    VFMatrix3 VFMatrix3MakeRotate(float angle, float rx, float ry, float rz);
    
    VFMatrix3 VFMatrix3MakeRotateX(float angle);
    VFMatrix3 VFMatrix3MakeRotateY(float angle);
    VFMatrix3 VFMatrix3MakeRotateZ(float angle);
    
    /* 缩放 */
    VFMatrix3 VFMatrix3MakeScale(float scaleFactor, float x, float y, float z);
    
    VFMatrix3 VFMatrix3MakeScaleX(float sx);
    VFMatrix3 VFMatrix3MakeScaleY(float sy);
    VFMatrix3 VFMatrix3MakeScaleZ(float sz);
    
#pragma mark -
#pragma mark VFMatrix4 foos
#pragma mark -
    
    VFMatrix4 VFMatrix4Make(float m11, float m12, float m13, float m14,
                            float m21, float m22, float m23, float m24,
                            float m31, float m32, float m33, float m34,
                            float m41, float m42, float m43, float m44);
    
    VFMatrix4 VFMatrix4MakeWith1DArray(float mat4[VFMATRIX4_1D_COMPONENTS]);
    
    VFMatrix4 VFMatrix4MakeWith2DArray(float mat4[VFMATRIX4_2D_ROWS_COMPONENTS][VFMATRIX4_2D_COLUMNS_COMPONENTS]);
    
#pragma mark - VFMatrix4 四元数（Quaternion）
    
    
#pragma mark - VFMatrix4 线性变换（Linear Transformation）
    
    /* 旋转 */
    VFMatrix4 VFMatrix4MakeRotate(float angle, float rx, float ry, float rz);
    
    VFMatrix4 VFMatrix4MakeRotateX(float angle);
    VFMatrix4 VFMatrix4MakeRotateY(float angle);
    VFMatrix4 VFMatrix4MakeRotateZ(float angle);
    
    /* 缩放 */
    VFMatrix4 VFMatrix4MakeScale(float scaleFactor, float x, float y, float z);
    
    VFMatrix4 VFMatrix4MakeScaleX(float sx);
    VFMatrix4 VFMatrix4MakeScaleY(float sy);
    VFMatrix4 VFMatrix4MakeScaleZ(float sz);
    
#pragma mark - VFMatrix4 平移（Translate）
    
    VFMatrix4 VFMatrix4MakeTranslation(float tx, float ty, float tz);
    
    VFMatrix4 VFMatrix4MakeTranslationX(float tx);
    VFMatrix4 VFMatrix4MakeTranslationY(float ty);
    VFMatrix4 VFMatrix4MakeTranslationZ(float tz);
    
#pragma mark - VFMatrix4 投影
    
#ifdef __cplusplus
}
#endif

#endif /* VFMatrix_h */
