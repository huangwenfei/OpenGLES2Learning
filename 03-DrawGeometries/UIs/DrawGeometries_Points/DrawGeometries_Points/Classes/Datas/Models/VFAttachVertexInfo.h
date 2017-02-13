//
//  VFAttachVertexInfo.h
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

@class VFShaderValueInfo;

@interface VFAttachVertexInfo : NSObject

// 着色器的变量信息
@property (strong, nonatomic) VFShaderValueInfo *shaderValueInfo;
// 数据的坐标分量数
@property (assign, nonatomic) GLint coordinateComsCount;
// 数据类型转换
@property (assign, nonatomic) GLboolean exchangeDataType;
// 储存的数据单个变量的分量的数据类型
@property (assign, nonatomic) GLenum dataType;
// 相邻数据的间隔
@property (assign, nonatomic) GLsizei dataStride;
// 数据加载的内存首地址
@property (assign, nonatomic) const GLvoid * dataLoadPtr;

- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
                    coordinateComsCount:(GLint)coordinateComsCount
                       exchangeDataType:(GLboolean)exchangeDataType
                               dataType:(GLenum)dataType
                             dataStride:(GLsizei)dataStride
                            dataLoadPtr:(const GLvoid *)dataLoadPtr;

// CVOs
- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
                            dataLoadPtr:(const GLvoid *)dataLoadPtr;
@end
