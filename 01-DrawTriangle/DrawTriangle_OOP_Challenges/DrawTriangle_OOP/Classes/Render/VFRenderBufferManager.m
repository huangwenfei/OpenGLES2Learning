//
//  VFRenderBufferManager.m
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFRenderBufferManager.h"

@interface VFRenderBufferManager ()<OpenELESErrorHandle>
@property (assign, nonatomic) GLuint currentRBOIdentifier;
@end

@implementation VFRenderBufferManager

#pragma mark -
#pragma mark Public:
#pragma mark -

#pragma mark Share Manager

/**
 *  默认的渲染缓存对象管理者
 */
+ (instancetype)defaultRenderManager {
    
    static dispatch_once_t onceToken;
    static VFRenderBufferManager * defaultManager;
    dispatch_once(&onceToken, ^{
        defaultManager = [[[self class] alloc] init];
    });
    
    return defaultManager;
    
}

#pragma mark - RBO

#define RenderBufferMemoryBlock(nSize)    (nSize)

/**
 *  创建 RBO
 */
- (void)createRenderBufferObject {
    
    glGenRenderbuffers(RenderBufferMemoryBlock(1), &_currentRBOIdentifier);
    
    if (self.currentRBOIdentifier == InvaildRBOID) {
        // Error Handler
        [self errorHandleWithType:VFError_RBO_Identifier_Type];
    }
    
}

/**
 *  使用 RBO
 */
- (void)useRenderBufferObject {
    
    glBindRenderbuffer(GL_RENDERBUFFER, self.currentRBOIdentifier);
    
}

/**
 *  删除 RBO
 */
- (void)deleteRenderBufferObject {
    
    if (glIsRenderbuffer(self.currentRBOIdentifier) && self.currentRBOIdentifier != InvaildRBOID) {
        glDeleteRenderbuffers(RenderBufferMemoryBlock(1), &_currentRBOIdentifier);
        self.currentRBOIdentifier = InvaildRBOID;
    }
    
}

#pragma mark - RBO Frame

/**
 *  渲染缓存的尺寸
 */
- (CGSize)renderBufferSize {
    
    GLint renderbufferWidth, renderbufferHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    return CGSizeMake(renderbufferWidth, renderbufferHeight);
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

#pragma mark - <OpenGLESFreeSource>

- (void)releaseSource {
    
    [self deleteRenderBufferObject];
    
}

- (void)postReleaseSourceNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VFErrorHandleNotificationName
                                                        object:[self class]];
    
}

#pragma mark - <OpenELESErrorHandle>

- (void)errorHandleWithType:(void const *)errorType {
    
    [self postReleaseSourceNotification];
    
    if (_isEqual(VFError_RBO_Identifier_Type, errorType)) {
        [self handleRBOIdentifierError];
    }
    
    [self releaseSource];
    EXIT_APPLICATION();
    
}

#pragma mark - Error Handle

- (void)handleRBOIdentifierError {
    
    NSLog(@" RBO 分配失败 ！");
    
}

@end




