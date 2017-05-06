//
//  VFMathTypes.h
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/15.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFMathTypes_h
#define VFMathTypes_h

#include <stdio.h>
#include <math.h>

// __STRICT_ANSI__ 是为了防止定义，函数名和新定义的类型名相同; 是编译器宏（GCC G++）;

#pragma mark - 
#pragma mark Unitis
#pragma mark -

#define VF_INLINE   static __inline__

#ifndef PI
#define PI  3.14159265358979323846264338327950288f
#endif

#define RadianByAngle(angle)     ( (angle) / 180.f * PI )
#define AngleByRadian(radian)    ( (radian) / PI * 180.f )

#pragma mark -
#pragma mark Matrix
#pragma mark -

/**
 *  Matrix, 1D -> 一维； 2D -> 二维； 3D -> 三维
 */

/* 2 X 2 方阵 */
typedef union {
    
    struct {
        float m11, m12;
        float m21, m22;
    };
    
    float m2D[2][2];
    float m1D[4];
    
} VFMatrix2;

#define VFMATRIX2_1D_COMPONENTS             (4)
#define VFMATRIX2_2D_ROWS_COMPONENTS        (2)
#define VFMATRIX2_2D_COLUMNS_COMPONENTS     (2)

/* 3 X 3 方阵 */
typedef union {
    
    struct {
        float m11, m12, m13;
        float m21, m22, m23;
        float m31, m32, m33;
    };
    
    float m2D[3][3];
    float m1D[9];
    
} VFMatrix3;

#define VFMATRIX3_1D_COMPONENTS             (9)
#define VFMATRIX3_2D_ROWS_COMPONENTS        (3)
#define VFMATRIX3_2D_COLUMNS_COMPONENTS     (3)

/* 4 X 4 方阵 */
typedef union {
    
    struct {
        float m11, m12, m13, m14;
        float m21, m22, m23, m24;
        float m31, m32, m33, m34;
        float m41, m42, m43, m44;
    };
    
    float m2D[4][4];
    float m1D[16];
    
} VFMatrix4;

#define VFMATRIX4_1D_COMPONENTS             (16)
#define VFMATRIX4_2D_ROWS_COMPONENTS        (4)
#define VFMATRIX4_2D_COLUMNS_COMPONENTS     (4)

#pragma mark -
#pragma mark Vector
#pragma mark -

typedef union {

    struct { float x, y; };
    float v[2];
    
} __attribute__((aligned(8))) VFVector2;

#define VFVECTOR2_COMPONENTS                (2)

typedef union {
    
    struct { float x, y, z; };
    float v[3];
    
} VFVector3;

#define VFVECTOR3_COMPONENTS                (3)

typedef union {
    
    struct { float x, y, z, w; };
    float v[4];
    
} __attribute__((aligned(16))) VFVector4;

#define VFVECTOR4_COMPONENTS                (4)

#endif /* VFMathTypes_h */





