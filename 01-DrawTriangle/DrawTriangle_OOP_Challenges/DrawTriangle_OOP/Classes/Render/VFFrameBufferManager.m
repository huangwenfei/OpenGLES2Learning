//
//  VFFrameBufferManager.m
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFFrameBufferManager.h"

@interface VFFrameBufferManager ()<OpenELESErrorHandle>
@property (assign, nonatomic) GLuint currentFBOIdentifier;
@end

@implementation VFFrameBufferManager

#pragma mark -
#pragma mark Public:
#pragma mark -

#pragma mark Share Manager

/**
 *  默认的帧缓存对象管理者
 */
+ (instancetype)defaultFrameManager {
    
    static dispatch_once_t onceToken;
    static VFFrameBufferManager * defaultManager;
    dispatch_once(&onceToken, ^{
        defaultManager = [[[self class] alloc] init];
    });
    
    return defaultManager;
    
}

#pragma mark - FBO

#define FrameBufferMemoryBlock(nSize)    (nSize)

/**
 *  创建 FBO
 */
- (void)createFrameBufferObject {
    
    glGenFramebuffers(FrameBufferMemoryBlock(1), &_currentFBOIdentifier);

    if (self.currentFBOIdentifier == InvaildFBOID) {
        // Error Handler
        [self errorHandleWithType:VFError_FBO_Identifier_Type];
    }
    
}

/**
 *  使用 FBO
 */
- (void)useFrameBufferObject {
    
    glBindFramebuffer(GL_FRAMEBUFFER, self.currentFBOIdentifier);
    
}

/**
 *  删除 FBO
 */
- (void)deleteFrameBufferObject {
    
    if (glIsFramebuffer(self.currentFBOIdentifier) && self.currentFBOIdentifier != InvaildFBOID) {
        glDeleteFramebuffers(FrameBufferMemoryBlock(1), &_currentFBOIdentifier);
        self.currentFBOIdentifier = InvaildFBOID;
    }
    
}

/**
 *  装载 Render Buffer 的内容到 Frame Buffer 内
 */
- (void)attachRenderBufferToFrameBuffer:(GLuint)renderBufferObjcetID {
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBufferObjcetID);
    
}


#pragma mark -
#pragma mark Private:
#pragma mark -


#pragma mark - <OpenGLESFreeSource>

- (void)releaseSource {
    
    [self deleteFrameBufferObject];

}

- (void)postReleaseSourceNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VFErrorHandleNotificationName
                                                        object:[self class]];
    
}

#pragma mark - <OpenELESErrorHandle>

- (void)errorHandleWithType:(void const *)errorType {
    
    [self postReleaseSourceNotification];
    
    if (_isEqual(VFError_FBO_Identifier_Type, errorType)) {
        [self handleFBOIdentifierError];
    }
    
    [self releaseSource];
    EXIT_APPLICATION();
    
}

#pragma mark - Error Handle

- (void)handleFBOIdentifierError {

    NSLog(@" FBO 分配失败 ！");
    
}


@end




