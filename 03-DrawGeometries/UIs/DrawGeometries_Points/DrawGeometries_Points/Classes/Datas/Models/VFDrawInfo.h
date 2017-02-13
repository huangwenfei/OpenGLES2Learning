//
//  VFDrawInfo.h
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCommon.h"

@class VFAttachVertexInfo;

typedef enum {
    
    VFPrimitiveModePoints           = GL_POINTS,
    
    VFPrimitiveModeLines            = GL_LINES,
    VFPrimitiveModeLineStrip        = GL_LINE_STRIP,
    VFPrimitiveModeLineLoop         = GL_LINE_LOOP,
    
    VFPrimitiveModeTriangles        = GL_TRIANGLES,
    VFPrimitiveModeTriangleStrip    = GL_TRIANGLE_STRIP,
    VFPrimitiveModeTriangleFan      = GL_TRIANGLE_FAN,
    
} VFPrimitiveMode;

typedef NS_ENUM(NSUInteger, VFCPUDataStoredType) {
    
    VFCPUDataStoredType_SOAs = 0, // Structure of Arrays 结构体数组
    VFCPUDataStoredType_AOSs,     // Array of Structures
    
};

@interface VFDrawInfo : NSObject

// 数据绑定的所有信息
@property (copy,   nonatomic) NSArray<VFAttachVertexInfo *> *attachDataInfos;
// 数据的储存方式
@property (assign, nonatomic) VFCPUDataStoredType dataCPUStoredType;
// 需要绘制的数据的起始下标
@property (assign, nonatomic) GLint startDrawIndex;
// 需要绘制的点数量
@property (assign, nonatomic) GLsizei verticesIndicesCount;
// 下标的起始内存首地址
@property (assign, nonatomic) const GLvoid *startElementDrawPtr;
// 下标个数
@property (assign, nonatomic) GLsizei elementIndicesCount;
// 图元的绘制类型
@property (assign, nonatomic) VFPrimitiveMode primitiveMode;

// 线宽 ( Line 模式下可用 )
@property (assign, nonatomic) GLfloat lineWidth;

// 点大小 ( 点模式下可用 )
@property (assign, nonatomic) CGFloat pointSize;

- (instancetype)initWithAttachDataInfos:(NSArray<VFAttachVertexInfo *> *)attachDataInfos
                         dataStoredType:(VFCPUDataStoredType)dataCPUStoredType
                          primitiveMode:(VFPrimitiveMode)primitiveMode
                         startDrawIndex:(GLint)startDrawIndex
                   verticesIndicesCount:(GLsizei)verticesIndicesCount
                    startElementDrawPtr:(const GLvoid *)startElementDrawPtr
                    elementIndicesCount:(GLsizei)elementIndicesCount;

- (instancetype)initWithAttachDataInfos:(NSArray<VFAttachVertexInfo *> *)attachDataInfos
                         dataStoredType:(VFCPUDataStoredType)dataCPUStoredType
                          primitiveMode:(VFPrimitiveMode)primitiveMode
                         startDrawIndex:(GLint)startDrawIndex
                   verticesIndicesCount:(GLsizei)verticesIndicesCount;

- (instancetype)initWithAttachDataInfos:(NSArray<VFAttachVertexInfo *> *)attachDataInfos
                         dataStoredType:(VFCPUDataStoredType)dataCPUStoredType
                          primitiveMode:(VFPrimitiveMode)primitiveMode
                    startElementDrawPtr:(const GLvoid *)startElementDrawPtr
                    elementIndicesCount:(GLsizei)elementIndicesCount;

@end





