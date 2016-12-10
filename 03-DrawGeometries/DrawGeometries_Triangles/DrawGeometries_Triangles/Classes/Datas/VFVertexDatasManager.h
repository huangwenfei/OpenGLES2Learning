//
//  VFVertexDatasManager.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

typedef NS_ENUM(NSUInteger, VFDrawGeometryType) {
    
    VFDrawGeometryType_TriangleTriangles = 0,
    VFDrawGeometryType_RectangleTriangles,
    VFDrawGeometryType_PentagonsTriangles,
    VFDrawGeometryType_HexagonsTriangles,
    VFDrawGeometryType_TrapezoidTriangles,
    VFDrawGeometryType_PentagramTriangles,
    VFDrawGeometryType_RoundTriangles,
    
};

@interface VFVertexDatasManager : NSObject<OpenGLESFreeSource>

/**
 *  绘制的几何图形类型
 */
@property (assign, nonatomic) VFDrawGeometryType drawGeometry;

/**
 *  默认的顶点数据管理者
 */
+ (instancetype)defaultVertexManager;

/**
 *  缩放使当前渲染内容适应当前显示屏幕
 */
- (void)makeScaleToFitCurrentWindowWithScale:(float)scale;

/**
 *  装载数据
 */
- (void)attachVertexDatas;

/**
 *  绘制图形
 */
- (void)draw;

@end
