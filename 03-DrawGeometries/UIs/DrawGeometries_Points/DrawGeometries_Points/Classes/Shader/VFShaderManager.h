//
//  VFShaderManager.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

@interface VFShaderManager : NSObject<OpenGLESFreeSource>

/**
 *  默认的着色器管理者
 */
+ (instancetype)defaultShaderManager;

/**
 *  装载着色器
 *
 *  @param vertexStringFileName     顶点着色器代码文件
 *  @param fragmentStringFileName   片元着色器代码文件
 */
- (void)attachVertexShader:(NSString *)vertexStringFileName fragmentShader:(NSString *)fragmentStringFileName;

/**
 *  使用着色器
 */
- (void)useShader;

@end
