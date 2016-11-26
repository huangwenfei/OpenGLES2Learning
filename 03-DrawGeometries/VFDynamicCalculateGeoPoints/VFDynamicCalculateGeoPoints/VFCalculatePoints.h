//
//  VFCalculatePoints.h
//  VFDynamicCalculateGeoPoints
//
//  Created by windy on 16/11/26.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OverrideContent "w"
#define AppendContent   "a"

@interface VFCalculatePoints : NSObject

- (void)logVertexPointsWithPoints:(NSArray *)points;

- (void)buildDatasInFileWithMode:(const char *)mode content:(NSArray *)contentData;

/**
 *  计算正几何图形
 *
 *  @param radii 外圆的半径
 *  @param lines 多个几边形边数
 */
- (void)makeRegularVertexPointsReadToFileWithRadii:(CGFloat)radii
                                          geolines:(NSArray<NSNumber *> *)geolines;

/**
 *  计算正几何图形
 *
 *  @param radii 外圆的半径
 *  @param lines 几边形
 */
- (NSArray *)makeRegularVertexPointsWithRadii:(CGFloat)radii
                                        lines:(NSUInteger)lines;

/**
 *  计算梯形
 *
 *  @param width     包围梯形的长方形的宽
 *  @param height    包围梯形的长方形的高
 *  @param topOff    上面两个顶点向原点的偏移量
 *  @param bottomOff 下面两个顶点向原点的偏移量
 */
- (NSArray *)makeTrapezoidVertexPointsWithWidth:(CGFloat)width
                                         height:(CGFloat)height
                                      topOffset:(CGPoint)topOff
                                    bottomOffet:(CGPoint)bottomOff;

/**
 *  计算星形
 *
 *  @param iRadii 内圆的半径
 *  @param oRadii 外圆的半径
 */
- (NSArray *)makeStarVertexPointsWithInnerRadii:(CGFloat)iRadii
                                    outterRadii:(CGFloat)oRadii;

@end
