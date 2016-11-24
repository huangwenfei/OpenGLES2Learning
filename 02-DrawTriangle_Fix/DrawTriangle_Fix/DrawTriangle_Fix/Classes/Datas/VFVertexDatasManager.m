//
//  VFVertexDatasManager.m
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFVertexDatasManager.h"
#import "VFBaseGeometricVertexData.h"
#import "VFShaderValueRexAnalyzer.h"
#import "VFMath.h"
@import GLKit;

@interface VFVertexDatasManager ()<OpenELESErrorHandle>
@property (assign, nonatomic) GLuint currentVBOIdentifier;
@property (strong, nonatomic) VFShaderValueRexAnalyzer *shaderCodeAnalyzer;
@end

@implementation VFVertexDatasManager

#pragma mark -
#pragma mark Getter:
#pragma mark -

- (VFShaderValueRexAnalyzer *)shaderCodeAnalyzer {
    return [VFShaderValueRexAnalyzer defaultShaderAnalyzer];
}

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
    
    self.currentVBOIdentifier = [self createVBO];
    [self bindVertexDatasWithVertexBufferID:self.currentVBOIdentifier];
    
    [self attachVertexArrays];
    
}

/**
 *  绘制三角形
 */
- (void)draw {
    
    glDrawArrays(VFPrimitiveModeTriangles,
                 StartIndex,
                 verticesCount());
    
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
 *  缩放使当前渲染内容适应当前显示屏幕
 *  uniform 变量一定要在 glUseProgram 之后再写入数据，不然没用
 */
- (void)makeScaleToFitCurrentWindowWithScale:(float)scale {
    
    NSDictionary *vertexShaderValueInfos = self.shaderCodeAnalyzer.shaderFileValueInfos[@"VFVertexShader"];
    ValueInfo_Dict *uniforms = vertexShaderValueInfos[UNIFORM_VALUE_DICT_KEY];
//    NSLog(@"uniforms %@", [uniforms allKeys]);
    
    // v_Projection 投影
//    VFMatrix4 scaleMat4 = VFMatrix4Identity;
    VFMatrix4 scaleMat4 = VFMatrix4MakeScaleY(scale);
    VFMatrix4 transMat4 = VFMatrix4Identity; //VFMatrix4MakeTranslationX(0.3)
    glUniformMatrix4fv((GLint)uniforms[@"v_Projection"].location,   // 定义的 uniform 变量的内存标识符
                       1,                                           // 不是 uniform 数组，只是一个 uniform -> 1
                       GL_FALSE,                                    // ES 下 只能是 False
                       (const GLfloat *)scaleMat4.m1D);             // 数据的首指针
    
    glUniformMatrix4fv((GLint)uniforms[@"v_Translation"].location,   // 定义的 uniform 变量的内存标识符
                       1,                                           // 不是 uniform 数组，只是一个 uniform -> 1
                       GL_FALSE,                                    // ES 下 只能是 False
                       (const GLfloat *)transMat4.m1D);             // 数据的首指针

}

/**
 *  装载顶点数据
 *
 *  @param vertexDataMode VAOs & VBOs 模式
 */
- (void)attachVertexArrays {
    
    // 重点是学习 glVertexAttribPointer 函数的 stride 和 ptr 参数的使用
    // 因为这里的 vertices 数据是 glDraw* 方法后，
    // 数据从 CPU 拷贝到 GPU 的 VBO 内存中，所以直接以数据的相对位置进行偏移即可
    
    // “I” 就是特指 指针 的运算（ + / - ）变化
    VFShaderValueInfo *positionInfo = [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:POSITION_STRING_KEY
                                                                                        shaderFileName:@"VFVertexShader"];
    glEnableVertexAttribArray((GLint)positionInfo.location);
    glVertexAttribPointer((GLint)positionInfo.location,      // 要处理的顶点数据的下标，如：Position 就是 0
                                                             // 0 是自己定的，反正 attribute [0, MAX]
                          
                          PositionCoordinateCount,      // 提供的顶点数据中，单个元素自身有多少个分量
                          
                          GL_FLOAT,                     // 如： Position, 有 {x, y , z} 三个分量
                                                        // 数据的基本数据类型是什么
                          
                          GL_FALSE,                     // 要不要进行，数据类型的转换
                                                        // OpenGL ES 只支持 float 类型的数据
                          
                          sizeof(VFVertex),             // 第 I 个元素，到 第 ( I + 1 ) 个元素的偏移量是多少
                          
                          (const GLvoid *) offsetof(VFVertex, Position));   // 元素的起始地址指针
    
    VFShaderValueInfo *colorInfo = [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:COLOR_STRING_KEY
                                                                                     shaderFileName:@"VFVertexShader"];
    glDisableVertexAttribArray((GLint)colorInfo.location);
    glVertexAttrib4fv((GLint)colorInfo.location, whiteColor);
    
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




