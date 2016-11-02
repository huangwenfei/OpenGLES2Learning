//
//  VFVertexDatasManager.h
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

typedef NS_ENUM(NSUInteger, VFVertexDataMode) {
    
    VFVertexDataMode_VAOs = 0,
    VFVertexDataMode_VBOs,
    
};

@interface VFVertexDatasManager : NSObject<OpenGLESFreeSource>
/**
 *  顶点数据的加载方式
 */
@property (assign, nonatomic) VFVertexDataMode vertexDataMode;

/**
 *  默认的顶点数据管理者
 */
+ (instancetype)defaultVertexManager;

/**
 *  装载数据
 */
- (void)attachVertexDatas;

/**
 *  绘制图形
 */
- (void)draw;

@end
