//
//  VFDrawInfo.m
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFDrawInfo.h"

@interface VFDrawInfo ()
// VBO 模式下创建 VBO 对象的个数
@property (assign, nonatomic) NSUInteger createVBOTimes;
@end

@implementation VFDrawInfo

- (instancetype)initWithAttachDataInfos:(NSArray<VFAttachVertexInfo *> *)attachDataInfos
                         dataStoredType:(VFCPUDataStoredType)dataCPUStoredType
                          primitiveMode:(VFPrimitiveMode)primitiveMode
                         startDrawIndex:(GLint)startDrawIndex
                   verticesIndicesCount:(GLsizei)verticesIndicesCount
                    startElementDrawPtr:(const GLvoid *)startElementDrawPtr
                    elementIndicesCount:(GLsizei)elementIndicesCount {
    
    if (self = [super init]) {
        
        self.attachDataInfos        = attachDataInfos;
        self.dataCPUStoredType      = dataCPUStoredType;
        self.primitiveMode          = primitiveMode;
        self.startDrawIndex         = startDrawIndex;
        self.verticesIndicesCount   = verticesIndicesCount;
        self.startElementDrawPtr    = startElementDrawPtr;
        self.elementIndicesCount    = elementIndicesCount;
        
    }
    
    return self;
    
}

- (instancetype)initWithAttachDataInfos:(NSArray<VFAttachVertexInfo *> *)attachDataInfos
                         dataStoredType:(VFCPUDataStoredType)dataCPUStoredType
                          primitiveMode:(VFPrimitiveMode)primitiveMode
                         startDrawIndex:(GLint)startDrawIndex
                   verticesIndicesCount:(GLsizei)verticesIndicesCount {
    
    return [self initWithAttachDataInfos:attachDataInfos
                          dataStoredType:dataCPUStoredType
                           primitiveMode:primitiveMode
                          startDrawIndex:startDrawIndex
                    verticesIndicesCount:verticesIndicesCount
                     startElementDrawPtr:NULL
                     elementIndicesCount:0];
    
}

- (instancetype)initWithAttachDataInfos:(NSArray<VFAttachVertexInfo *> *)attachDataInfos
                         dataStoredType:(VFCPUDataStoredType)dataCPUStoredType
                          primitiveMode:(VFPrimitiveMode)primitiveMode
                    startElementDrawPtr:(const GLvoid *)startElementDrawPtr
                    elementIndicesCount:(GLsizei)elementIndicesCount {
    
    return [self initWithAttachDataInfos:attachDataInfos
                          dataStoredType:dataCPUStoredType
                           primitiveMode:primitiveMode
                          startDrawIndex:0
                    verticesIndicesCount:0
                     startElementDrawPtr:startElementDrawPtr
                     elementIndicesCount:elementIndicesCount];
    
}

@end
