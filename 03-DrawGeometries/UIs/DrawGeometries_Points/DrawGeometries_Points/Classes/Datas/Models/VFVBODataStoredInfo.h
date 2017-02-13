//
//  VFDataStoredInfo.h
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/4.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFOpenGLES2XHeader.h"

@class VFVBOSubDataStoredInfo;

typedef NS_ENUM(NSInteger, VFDataBindType) {
    
    VFDataBindType_CVOs     = 0,
    VFDataBindType_VAOs,
    VFDataBindType_VBOs,
    
};

typedef NS_ENUM(NSInteger, VFVBOType) {
    
    VFVBOType_UnDefine       = -1,
    VFVBOType_Array          = GL_ARRAY_BUFFER,
    VFVBOType_Element_Array  = GL_ELEMENT_ARRAY_BUFFER,
    
};

typedef NS_ENUM(NSInteger, VFVBOUsage) {
    
    VFVBOUsage_UnDefine     = -1,
    VFVBOUsage_StaticDraw   = GL_STATIC_DRAW,
    VFVBOUsage_DynamicDraw  = GL_DYNAMIC_DRAW,
    VFVBOUsage_StreamDraw   = GL_STREAM_DRAW,
    
};

#pragma mark - VFVBODataStoredInfo Class

@interface VFVBODataStoredInfo : NSObject

// SubVBO Datas
@property (copy,   nonatomic) NSArray<VFVBOSubDataStoredInfo *> *subVBODataInfos;

// VBO 对象的内存地址
@property (assign, nonatomic) GLuint vertexBufferID, vertexElementBufferId;

// 数据的绑定方式
@property (assign, nonatomic) VFDataBindType dataBindType;

// VBO 对象的类型
@property (assign, nonatomic) VFVBOType bufferType;

// 数据所占的内存大小
@property (assign, nonatomic) GLsizeiptr dataSize;
// 数据的内存首地址
@property (assign, nonatomic) const GLvoid *dataPtr;

// 下标数据所占的内存大小
@property (assign, nonatomic) GLsizeiptr elementDataSize;
// 下标内存首地址
@property (assign, nonatomic) const GLvoid *elementDataPtr;

// VBO 数据的使用方式
@property (assign, nonatomic) VFVBOUsage VBODataUsage;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage
                     subVBODataInfos:(NSArray<VFVBOSubDataStoredInfo *> *)subVBODataInfos;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage
                     subVBODataInfos:(NSArray<VFVBOSubDataStoredInfo *> *)subVBODataInfos;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage
                     subVBODataInfos:(NSArray<VFVBOSubDataStoredInfo *> *)subVBODataInfos;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                            dataSize:(GLsizeiptr)dataSize
                             dataPtr:(const GLvoid *)dataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType
                          bufferType:(VFVBOType)bufferType
                     elementDataSize:(GLsizeiptr)elementDataSize
                      elementDataPtr:(const GLvoid *)elementDataPtr
                        VBODataUsage:(VFVBOUsage)VBODataUsage;

- (instancetype)initWithDataBindType:(VFDataBindType)dataBindType;

@end

#pragma mark - VFVBOSubDataStoredInfo Class

@interface VFVBOSubDataStoredInfo : NSObject

// 数据所占的内存大小
@property (assign, nonatomic) GLsizeiptr dataSize;
// 数据的内存首地址
@property (assign, nonatomic) const GLvoid *dataPtr;
// VBO 数据的内存偏移量
@property (assign, nonatomic) GLintptr VBOOffsetSize;

- (instancetype)initWithVBOOffsetSize:(GLintptr)VBOOffsetSize
                             dataSize:(GLsizeiptr)dataSize
                              dataPtr:(const GLvoid *)dataPtr;

@end













