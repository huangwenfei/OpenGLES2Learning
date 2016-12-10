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
    
    VFDrawGeometryType_SingleLine = 0,
    VFDrawGeometryType_CrossLines,
    
    VFDrawGeometryType_MountainLines,
    
    VFDrawGeometryType_TriangleLines,
    VFDrawGeometryType_RectangleLines,
    VFDrawGeometryType_PentagonsLines,
    VFDrawGeometryType_HexagonsLines,
    VFDrawGeometryType_TrapezoidLines,
    VFDrawGeometryType_PentagramLines,
    VFDrawGeometryType_RoundLines,
    
    VFDrawGeometryType_LowPolyRectLines,
    VFDrawGeometryType_LowPolyPentLines,
    VFDrawGeometryType_LowPolyHexLines,
    VFDrawGeometryType_LowPolyTrazLines,
    VFDrawGeometryType_LowPolyStarLines,
    
    VFDrawGeometryType_BezierMountain,
    VFDrawGeometryType_BezierRound,
    VFDrawGeometryType_BezierOval,
    
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
