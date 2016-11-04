//
//  VFFrameBufferManager.h
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

@interface VFFrameBufferManager : NSObject<OpenGLESFreeSource>

// 当前活跃的帧缓存的标识
@property (assign, nonatomic, readonly) GLuint currentFBOIdentifier;

/**
 *  默认的帧缓存对象管理者
 */
+ (instancetype)defaultFrameManager;

/**
 *  创建 FBO
 */
- (void)createFrameBufferObject;

/**
 *  使用 FBO
 */
- (void)useFrameBufferObject;

/**
 *  删除 FBO
 */
- (void)deleteFrameBufferObject;

/**
 *  装载 Render Buffer 的内容到 Frame Buffer 内
 */
- (void)attachRenderBufferToFrameBuffer:(GLuint)renderBufferObjcetID;

@end
