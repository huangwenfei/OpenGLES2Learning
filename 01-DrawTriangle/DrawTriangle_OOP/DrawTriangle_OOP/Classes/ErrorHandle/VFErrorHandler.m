//
//  VFErrorHandler.m
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFErrorHandler.h"

@implementation VFErrorHandler

#pragma mark - 
#pragma mark Pbulic:
#pragma mark -

/**
 *  默认的错误处理器
 */
+ (instancetype)defaultErrorHandler {
    
    static dispatch_once_t onceToken;
    static VFErrorHandler * defaultHandler;
    dispatch_once(&onceToken, ^{
        defaultHandler = [[[self class] alloc] init];
    });
    
    return defaultHandler;
    
}

/**
 *  处理错误
 *
 *  @param errorType 错误类型
 */
- (void)handleErrorWithErrorType:(VFErrorType)errorType {
    
    switch (errorType) {
        case VFErrorType_RBOIdentifier: {
            [self handleRenderBufferObjectIDError];
            break;
        }
        case VFErrorType_FBOIdentifier: {
            [self handleFrameBufferObjectIDError];
            break;
        }
    }
    
    [self exit];
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

/**
 *  退出程序
 */
- (void)exit {
    
    exit(1);
    
}

/**
 *  处理 RBO 内存分配失败
 */
- (void)handleRenderBufferObjectIDError {
    
    
    
}

/**
 *  处理 FBO 内存分配失败
 */
- (void)handleFrameBufferObjectIDError {
    
    
    
}

@end
