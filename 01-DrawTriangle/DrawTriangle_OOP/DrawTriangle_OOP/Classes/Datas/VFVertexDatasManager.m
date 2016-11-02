//
//  VFVertexDatasManager.m
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFVertexDatasManager.h"
#import "VFBaseGeometricVertexData.h"

@interface VFVertexDatasManager ()<OpenELESErrorHandle>
@property (assign, nonatomic) GLuint currentVBOIdentifier;
@end

@implementation VFVertexDatasManager

#pragma mark -
#pragma mark Public:
#pragma mark -

#pragma mark - Share

/**
 *  默认的顶点数据管理者
 */
+ (instancetype)defaultVertexManager {
    
    static dispatch_once_t onceToken;
    static VFVertexDatasManager * defaultManager;
    dispatch_once(&onceToken, ^{
        defaultManager = [[[self class] alloc] init];
    });
    
    return defaultManager;
    
}

#pragma mark - Data Op

/**
 *  装载数据
 */
- (void)attachVertexDatas {
    
    if (self.vertexDataMode == VFVertexDataMode_VBOs) {
        self.currentVBOIdentifier = [self createVBO];
        [self bindVertexDatasWithVertexBufferID:self.currentVBOIdentifier];
    }
    
    [self attachVertexArraysWithVertexDataMode:self.vertexDataMode];
    
}

/**
 *  绘制三角形
 */
- (void)draw {
    
    glDrawArrays(GL_TRIANGLES,
                 VFVertexPositionAttribute,
                 DrawIndicesCount(3));
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

#define VertexBufferMemoryBlock(nSize)    (nSize)

/**
 *  创建顶点缓存对象
 */
- (GLuint)createVBO {
    
    GLuint vertexBufferID;
    glGenBuffers(VertexBufferMemoryBlock(1), &vertexBufferID);
    
    return vertexBufferID;
    
}

/**
 *  使用顶点缓存对象
 *
 *  @param vertexBufferID 顶点缓存对象标识
 */
- (void)bindVertexDatasWithVertexBufferID:(GLuint)vertexBufferID {
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    // 创建 资源 ( context )
    glBufferData(GL_ARRAY_BUFFER,   // 缓存块 类型
                 sizeof(vertices),  // 创建的 缓存块 尺寸
                 vertices,          // 要绑定的顶点数据
                 GL_STATIC_DRAW);   // 缓存块 用途
    
}

/**
 *  删除顶点缓存对象
 */
- (void)deleteVertexBufferObject {
    
    if (glIsBuffer(self.currentVBOIdentifier) && self.currentVBOIdentifier != InvaildVBOID) {
        glDeleteBuffers(VertexBufferMemoryBlock(1), &_currentVBOIdentifier);
        self.currentVBOIdentifier = InvaildVBOID;
    }
    
}

#pragma mark - Attact Arrays

/**
 *  装载顶点数据
 *
 *  @param vertexDataMode VAOs & VBOs 模式
 */
- (void)attachVertexArraysWithVertexDataMode:(VFVertexDataMode)vertexDataMode {
    
    glEnableVertexAttribArray(VFVertexPositionAttribute);
    
    if (vertexDataMode == VFVertexDataMode_VBOs) {
        
        glVertexAttribPointer(VFVertexPositionAttribute,
                              PositionCoordinateCount,
                              GL_FLOAT,
                              GL_FALSE,
                              sizeof(VFVertex),
                              (const GLvoid *) offsetof(VFVertex, Position));
        
    } else {
        
        glVertexAttribPointer(VFVertexPositionAttribute,
                              PositionCoordinateCount,
                              GL_FLOAT,
                              GL_FALSE,
                              StrideCloser,
                              vertices);
        
    }
    
}

#pragma mark - <OpenGLESFreeSource>

- (void)releaseSource {
    
    [self deleteVertexBufferObject];
    
}

- (void)postReleaseSourceNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VFErrorHandleNotificationName
                                                        object:[self class]];
    
}

#pragma mark - <OpenELESErrorHandle>

- (void)errorHandleWithType:(void const *)errorType {
    
    [self postReleaseSourceNotification];
    
    if (_isEqual(VFError_VBO_Identifier_Type, errorType)) {
        [self handleVBOIdentifierError];
    }
    
    [self releaseSource];
    EXIT_APPLICATION();
    
}

#pragma mark - Error Handle

- (void)handleVBOIdentifierError {
    
    NSLog(@" VBO 分配失败 ！");
    
}

@end




