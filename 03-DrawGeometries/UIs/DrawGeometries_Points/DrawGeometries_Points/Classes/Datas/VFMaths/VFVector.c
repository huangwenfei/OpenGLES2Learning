//
//  VFVector.c
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/15.
//  Copyright © 2016年 windy. All rights reserved.
//

#include "VFVector.h"

/* 单位方阵 */
const VFVector2 VFVector2Identity = { 0, 0 };

const VFVector3 VFVector3Identity = { 0, 0, 0 };

const VFVector4 VFVector4Identity = { 0, 0, 0, 0 };

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark -
#pragma mark VFVector2 foos
#pragma mark -
    
#pragma mark -
#pragma mark VFVector3 foos
#pragma mark -
    
    VFVector3 VFVector3Make(float x, float y, float z) {
    
        VFVector3 _v3 = { x, y, z };
        
        return _v3;
        
    };
    
    VFVector3 VFVector3MakeWithArray(float v[VFVECTOR3_COMPONENTS]) {
    
        VFVector3 _v3 = { v[0], v[1], v[2] };
        
        return _v3;
        
    };
    
#pragma mark - 向量标准化
    
    /* 向量标准化 */
    VFVector3 VFVector3Normalied(VFVector3 v3) {
        
        float norm = VFVector3Norm(v3);
        VFVector3 normalied = VFVector3DivScalar(v3, norm);
        
        return normalied;
        
    };
    
    /* 向量的模 */
    float VFVector3Norm(VFVector3 v3) {
        
        float x2 = powf(v3.x, 2);
        float y2 = powf(v3.y, 2);
        float z2 = powf(v3.z, 2);
        
        return sqrtf(x2 + y2 + z2);
        
    };
    
#pragma mark - 向量的四则运算
    
    VFVector3 VFVector3Add(VFVector3 v3_1, VFVector3 v3_2) {
        
        VFVector3 v_add = {
            v3_1.x + v3_2.x,
            v3_1.y + v3_2.y,
            v3_1.z + v3_2.z,
        };
        
        return v_add;
        
    };
    
    VFVector3 VFVector3Sub(VFVector3 v3_1, VFVector3 v3_2) {
        
        VFVector3 v_sub = {
            v3_1.x - v3_2.x,
            v3_1.y - v3_2.y,
            v3_1.z - v3_2.z,
        };
        
        return v_sub;
        
    };
    
    /* 标量与向量的运算 */
    VFVector3 VFVector3MulScalar(VFVector3 v3, float scalar) {
        
        VFVector3 v_mul = {
            v3.x * scalar,
            v3.y * scalar,
            v3.z * scalar,
        };
        
        return v_mul;
        
    };
    
    VFVector3 VFVector3DivScalar(VFVector3 v3, float scalar) {
        
        VFVector3 v_div = {
            v3.x / scalar,
            v3.y / scalar,
            v3.z / scalar,
        };
        
        return v_div;
        
    };
    
    /* 取负 */
    VFVector3 VFVector3NegativeSign(VFVector3 v3) {
        
        return VFVector3MulScalar(v3, -1);
        
    };
    
#pragma mark - 点乘 和 叉乘
    
    float VFVector3DotProduct(VFVector3 v3_1, VFVector3 v3_2) {
        
        float v_dot =   v3_1.x * v3_2.x +
                        v3_1.y * v3_2.y +
                        v3_1.z * v3_2.z ;
        
        return v_dot;
        
    };
    
    /*
     用伪行列式来算, i j k 是单位向量
     |   i      j      k  |
     | p(x)   p(y)   p(z) |
     | Q(x)   Q(y)   Q(z) |
     
     -> i(p(y)Q(z) - p(z)Q(y)) +
        j(p(z)Q(x) - p(x)Q(z)) +
        k(p(x)Q(y) - p(y)Q(x));

     */
    VFVector3 VFVector3CrossProduct(VFVector3 v3_1, VFVector3 v3_2) {
        
        VFVector3 v_cross = {
            (v3_1.y * v3_2.z) - (v3_1.z * v3_2.y),
            (v3_1.z * v3_2.x) - (v3_1.x * v3_2.z),
            (v3_1.x * v3_2.y) - (v3_1.y * v3_2.x),
        };
        
        return v_cross;
        
    };

#pragma mark -
#pragma mark VFVector4 foos
#pragma mark -

#ifdef __cplusplus
}
#endif