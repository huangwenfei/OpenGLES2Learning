//
//  VFAttachVertexInfo.m
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFAttachVertexInfo.h"

@interface VFAttachVertexInfo ()

@end

@implementation VFAttachVertexInfo


- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
                    coordinateComsCount:(GLint)coordinateComsCount
                       exchangeDataType:(GLboolean)exchangeDataType
                               dataType:(GLenum)dataType
                             dataStride:(GLsizei)dataStride
                            dataLoadPtr:(const GLvoid *)dataLoadPtr {
    
    if (self = [super init]) {
        
        self.shaderValueInfo        = shaderValueInfo;
        self.coordinateComsCount    = coordinateComsCount;
        self.exchangeDataType       = exchangeDataType;
        self.dataType               = dataType;
        self.dataStride             = dataStride;
        self.dataLoadPtr            = dataLoadPtr;
        
    }
    
    return self;
    
}

// CVOs
- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
                            dataLoadPtr:(const GLvoid *)dataLoadPtr {
    
    if (self = [super init]) {
        
        self.shaderValueInfo        = shaderValueInfo;
        self.dataLoadPtr            = dataLoadPtr;
        
    }
    
    return self;
    
}

//- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
//                    coordinateComsCount:(GLint)coordinateComsCount
//                           dataBindType:(VFDataBindType)dataBindType
//                           VBODataUsage:(GLenum)VBODataUsage
//                    VBODataOffsetSwitch:(BOOL)VBODataOffsetSwitch
//                              VBOOffset:(GLintptr)VBOOffset
//                       exchangeDataType:(GLboolean)exchangeDataType
//                               dataType:(GLenum)dataType
//                             dataStride:(GLsizei)dataStride
//                            dataLoadPtr:(const GLvoid *)dataLoadPtr {
//    
//    if (self = [super init]) {
//        
//        self.shaderValueInfo        = shaderValueInfo;
//        self.coordinateComsCount    = coordinateComsCount;
//        self.dataBindType           = dataBindType;
//        self.VBODataUsage           = VBODataUsage;
//        self.VBODataOffsetSwitch    = VBODataOffsetSwitch;
//        self.VBOOffset              = VBOOffset;
//        self.exchangeDataType       = exchangeDataType;
//        self.dataType               = dataType;
//        self.dataStride             = dataStride;
//        self.dataLoadPtr            = dataLoadPtr;
//        
//    }
//    
//    return self;
//    
//}
//
//- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
//                    coordinateComsCount:(GLint)coordinateComsCount
//                           dataBindType:(VFDataBindType)dataBindType
//                           VBODataUsage:(GLenum)VBODataUsage
//                       exchangeDataType:(GLboolean)exchangeDataType
//                               dataType:(GLenum)dataType
//                             dataStride:(GLsizei)dataStride
//                            dataLoadPtr:(const GLvoid *)dataLoadPtr {
//    
//    if (self = [super init]) {
//        
//        self.shaderValueInfo        = shaderValueInfo;
//        self.coordinateComsCount    = coordinateComsCount;
//        self.dataBindType           = dataBindType;
//        self.VBODataUsage           = VBODataUsage;
//        self.exchangeDataType       = exchangeDataType;
//        self.dataType               = dataType;
//        self.dataStride             = dataStride;
//        self.dataLoadPtr            = dataLoadPtr;
//        
//    }
//    
//    return self;
//    
//}


//- (instancetype)initWithShaderValueInfo:(VFShaderValueInfo *)shaderValueInfo
//                            dataLoadPtr:(const GLvoid *)dataLoadPtr {
//
//    if (self = [super init]) {
//        
//        self.shaderValueInfo        = shaderValueInfo;
//        self.dataBindType           = VFDataBindType_CVOs;
//        self.dataLoadPtr            = dataLoadPtr;
//        
//    }
//    
//    return self;
//    
//}

@end


