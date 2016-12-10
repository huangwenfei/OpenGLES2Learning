//
//  VFRenderBufferManager.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

@interface VFRenderBufferManager : NSObject<OpenGLESFreeSource>
// 当前活跃的渲染缓存的标识
@property (assign, nonatomic, readonly) GLuint currentRBOIdentifier;

/**
 *  默认的渲染缓存对象管理者
 */
+ (instancetype)defaultRenderManager;

/**
 *  创建 RBO
 */
- (void)createRenderBufferObject;

/**
 *  使用 RBO
 */
- (void)useRenderBufferObject;

/**
 *  删除 RBO
 */
- (void)deleteRenderBufferObject;

/**
 *  渲染缓存的尺寸
 */
- (CGSize)renderBufferSize;

/**
 *  当前显示屏幕的像素比
 * （因为屏幕 Y 像素 > X 像素, 所以要缩小，不然显示就会向 Y 方向拉伸）
 */
- (CGFloat)windowScaleFactor;

@end
