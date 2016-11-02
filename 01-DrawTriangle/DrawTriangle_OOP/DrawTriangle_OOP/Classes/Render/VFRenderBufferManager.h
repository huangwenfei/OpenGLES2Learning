//
//  VFRenderBufferManager.h
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
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

@end
