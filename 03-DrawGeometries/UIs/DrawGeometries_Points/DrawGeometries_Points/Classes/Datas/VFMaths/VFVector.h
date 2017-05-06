//
//  VFVector.h
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/15.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFVector_h
#define VFVector_h

#include <stdio.h>
#include "VFMathTypes.h"

/* 初值 */
extern const VFVector2 VFVector2Identity;
extern const VFVector3 VFVector3Identity;
extern const VFVector4 VFVector4Identity;

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark -
#pragma mark VFVector2 foos
#pragma mark -
    
#pragma mark -
#pragma mark VFVector3 foos
#pragma mark -
    
    VFVector3 VFVector3Make(float x, float y, float z);
    
    VFVector3 VFVector3MakeWithArray(float v[VFVECTOR3_COMPONENTS]);
    
#pragma mark - 向量标准化
    
    /* 向量标准化 */
    VFVector3 VFVector3Normalied(VFVector3 v3);
    
    /* 向量的模 */
    float VFVector3Norm(VFVector3 v3);
    
#pragma mark - 向量的四则运算
    
    VFVector3 VFVector3Add(VFVector3 v3_1, VFVector3 v3_2);
    VFVector3 VFVector3Sub(VFVector3 v3_1, VFVector3 v3_2);
    
    /* 标量与向量的运算 */
    VFVector3 VFVector3MulScalar(VFVector3 v3, float scalar);
    VFVector3 VFVector3DivScalar(VFVector3 v3, float scalar);
    
    /* 取负 */
    VFVector3 VFVector3NegativeSign(VFVector3 v3);
    
#pragma mark - 点乘 和 叉乘
    
    float VFVector3DotProduct(VFVector3 v3_1, VFVector3 v3_2);
    VFVector3 VFVector3CrossProduct(VFVector3 v3_1, VFVector3 v3_2);
    
#pragma mark -
#pragma mark VFVector4 foos
#pragma mark -
    
#ifdef __cplusplus
}
#endif

#endif /* VFVector_h */
