//
//  VFBezierCurve.h
//  VFDynamicCalculateGeoPoints
//
//  Created by windy on 16/11/27.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ContentOPS
#define ContentOPS

#define OverrideContent "w"
#define AppendContent   "a"

#endif

#ifndef VFVertex_Point
#define VFVertex_Point

typedef union {
    
    struct {
        float x,y,z;
    };
    
    float Position[3]; // { x, y, z }
    
} VFVertex;

static inline VFVertex VFVertexMake(float x, float y, float z) {
    
    VFVertex _ver = {
        x, y, z
    };
    
    return  _ver;
    
}

#endif

/* 取值范围为 [0, 10000] */
#define _Precision(p)    ((p) / 10000.l)

@interface VFBezierCurve : NSObject

/**
 *  把 VFVertex 点封装成 NSValue 对象
 */
- (NSValue *)BEZ3DPointToValue:(VFVertex *)point;

/**
 *  把 VFVertex 点从 NSValue 对象中提取出来
 */
- (void)valueToBEZ3DPoint:(NSValue *)point storedPoint:(VFVertex *)storedPoint;

- (NSArray *)makeMountainPoints:(const VFVertex *)Points segmentPointsCount:(uint)count segments:(uint)segments;

- (NSArray *)makeRoundPointsWithRadii:(float)radii originPoint:(CGPoint)originPoint;

- (NSArray *)makeOvalPointsWithRadiiX:(float)radiiX radiiY:(float)radiiY originPoint:(CGPoint)originPoint;

/**
 *  生成平均分布的线
 */
- (NSArray *)makeLinesWithRect:(CGRect)rect lines:(NSUInteger)lines firstLineW:(CGFloat)fW offsetPoint:(CGPoint)offsetP bottomH:(CGFloat)bottomH;

/**
 *  生成 BEZ 曲线的所有点
 *
 *  @param Points    所有的点（包括起点、终点、以及所有控制点）
 *  @param count     点的数量
 *  @param precision 精度
 *
 */
- (NSArray<NSValue *> *)BEZ3DPointBuildWithPoints:(VFVertex *)Points pointsCount:(uint)count precision:(long double)precision;

/**
 *  VFVertex Value 数组转换成 VFVertex 字符串数组
 */
- (NSArray<NSString *> *)BEZ3DPointsToFormatStringPoint:(NSArray<NSValue *> *)BEZPoints headName:(NSString *)name;

- (void)buildDatasInFileWithMode:(const char *)mode content:(NSArray<NSString *> *)contentData;

@end
