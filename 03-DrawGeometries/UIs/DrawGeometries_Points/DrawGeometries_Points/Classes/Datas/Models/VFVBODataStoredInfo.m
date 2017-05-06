//
//  VFDataStoredInfo.m
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/4.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFVBODataStoredInfo.h"

#pragma mark - VFVBODataStoredInfo Class

@implementation VFVBODataStoredInfo

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage
                     subVBODataInfos:(NSArray<VFVBOSubDataStoredInfo *> *)subVBODataInfos {
    
    if (self = [super init]) {
        
        self.vertexBufferID         = -1;
        self.vertexElementBufferId  = -1;
        self.dataBindType           = dataBindType;
        self.bufferType             = bufferType;
        self.dataSize               = dataSize;
        self.dataPtr                = dataPtr;
        self.elementDataSize        = elementDataSize;
        self.elementDataPtr         = elementDataPtr;
        self.VBODataUsage           = VBODataUsage;
        self.subVBODataInfos        = subVBODataInfos;
        
    }
    
    return self;
    
}

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage
                     subVBODataInfos:(NSArray<VFVBOSubDataStoredInfo *> *)subVBODataInfos {
    
    return [self initWithDataBindType:dataBindType
                           bufferType:bufferType
                             dataSize:dataSize
                              dataPtr:dataPtr
                      elementDataSize:0
                       elementDataPtr:NULL
                         VBODataUsage:VBODataUsage
                      subVBODataInfos:subVBODataInfos];
    
}

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage
                     subVBODataInfos:(NSArray<VFVBOSubDataStoredInfo *> *)subVBODataInfos {
    
    return [self initWithDataBindType:dataBindType
                           bufferType:bufferType
                             dataSize:0
                              dataPtr:NULL
                      elementDataSize:elementDataSize
                       elementDataPtr:elementDataPtr
                         VBODataUsage:VBODataUsage
                      subVBODataInfos:subVBODataInfos];
    
}

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage {
    
    return [self initWithDataBindType:dataBindType
                           bufferType:bufferType
                             dataSize:dataSize
                              dataPtr:dataPtr
                      elementDataSize:elementDataSize
                       elementDataPtr:elementDataPtr
                         VBODataUsage:VBODataUsage
                      subVBODataInfos:nil];
    
}

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage {
    
    return [self initWithDataBindType:dataBindType
                           bufferType:bufferType
                             dataSize:dataSize
                              dataPtr:dataPtr
                      elementDataSize:0
                       elementDataPtr:NULL
                         VBODataUsage:VBODataUsage
                      subVBODataInfos:nil];
    
}

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage {
    
    return [self initWithDataBindType:dataBindType
                           bufferType:bufferType
                             dataSize:0
                              dataPtr:NULL
                      elementDataSize:elementDataSize
                       elementDataPtr:elementDataPtr
                         VBODataUsage:VBODataUsage
                      subVBODataInfos:nil];
    
}

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType {
    
    return [self initWithDataBindType:dataBindType
                           bufferType:VFVBOType_UnDefine
                             dataSize:0
                              dataPtr:NULL
                      elementDataSize:0
                       elementDataPtr:NULL
                         VBODataUsage:VFVBOUsage_UnDefine
                      subVBODataInfos:nil];
    
}

@end

#pragma mark - VFVBOSubDataStoredInfo Class

@implementation VFVBOSubDataStoredInfo

- (instancetype)initWithVBOOffsetSize:(GLintptr)VBOOffsetSize
                             dataSize:(GLsizeiptr)dataSize
                              dataPtr:(const GLvoid *)dataPtr {
    
    if (self = [super init]) {
        
        self.VBOOffsetSize  = VBOOffsetSize;
        self.dataSize       = dataSize;
        self.dataPtr        = dataPtr;
        
    }
    
    return self;
    
}

@end


