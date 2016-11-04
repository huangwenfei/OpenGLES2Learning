//
//  VFErrorHandler.h
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFErrorUnitis.h"

@interface VFErrorHandler : NSObject

/**
 *  默认的错误处理器
 */
+ (instancetype)defaultErrorHandler;

/**
 *  处理错误
 *
 *  @param errorType 错误类型
 */
- (void)handleErrorWithErrorType:(VFErrorType)errorType;

@end
