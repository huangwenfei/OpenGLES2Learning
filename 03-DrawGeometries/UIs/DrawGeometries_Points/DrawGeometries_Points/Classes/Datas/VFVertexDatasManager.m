//
//  VFVertexDatasManager.m
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFVertexDatasManager.h"
#import "VFBaseGeometricVertexData.h"
#import "VFMath.h"
@import GLKit;

@interface VFVertexDatasManager ()<OpenELESErrorHandle>

@property (strong, nonatomic) VFShaderValueRexAnalyzer *shaderCodeAnalyzer;

@property (copy,   nonatomic) NSArray<VFDrawInfo *> *drawInfos;
@property (copy,   nonatomic) NSArray<VFVBODataStoredInfo * > *VBODataInfos;

@property (assign, nonatomic) GLsizei verticesIndicesCount;
@property (assign, nonatomic) VFPrimitiveMode primitiveMode;

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
  
    [self drawInfoMaker];
    
    for (VFVBODataStoredInfo *VBODataInfo in self.VBODataInfos) {
        
        BOOL isVBOType = VBODataInfo.dataBindType == VFDataBindType_VBOs;
        if ( ! isVBOType ) { return; }

        VBODataInfo.vertexBufferID = [self createVBO];
        [self bindVertexDatasWithVertexBufferID:VBODataInfo.vertexBufferID
                                     bufferType:VBODataInfo.bufferType
                                   verticesSize:VBODataInfo.dataSize
                                       datasPtr:VBODataInfo.dataPtr         // CPU 内存首地址
                                          usage:VBODataInfo.VBODataUsage];
        
        if (VBODataInfo.elementDataSize) {
            
            VBODataInfo.vertexElementBufferId = [self createVBO];
            [self bindVertexDatasWithVertexBufferID:VBODataInfo.vertexElementBufferId
                                         bufferType:VBODataInfo.bufferType
                                       verticesSize:VBODataInfo.elementDataSize
                                           datasPtr:VBODataInfo.elementDataPtr         // CPU 内存首地址
                                              usage:VBODataInfo.VBODataUsage];
            
        }
        
        BOOL haveSubDatas = VBODataInfo.subVBODataInfos != nil;
        if ( haveSubDatas ) {

            for (VFVBOSubDataStoredInfo *subDataInfo in VBODataInfo.subVBODataInfos) {
                
                [self bindVertexSubDatasWithBufferType:VBODataInfo.bufferType
                                          verticesSize:subDataInfo.dataSize
                                              datasPtr:subDataInfo.dataPtr
                                            offsetSize:subDataInfo.VBOOffsetSize];
                
                
            }
            
        }
        
    }
    
}

/**
 *  绘制图形
 */
- (void)draw {
    
    for (VFDrawInfo *drawInfo in self.drawInfos) {
        
        [self attachVertexArraysWithDrawInfo:drawInfo];
        
        if (drawInfo.primitiveMode == VFPrimitiveModeLines      ||
            drawInfo.primitiveMode == VFPrimitiveModeLineStrip  ||
            drawInfo.primitiveMode == VFPrimitiveModeLineLoop) {
            
            CGFloat linwWidth = drawInfo.lineWidth ? drawInfo.lineWidth : DEFAULT_LINE_WITH;
            glLineWidth(linwWidth);
            
        }
        
        if (drawInfo.elementIndicesCount) {
            
            glDrawElements(drawInfo.primitiveMode,
                           drawInfo.elementIndicesCount,
                           GL_UNSIGNED_BYTE,
                           drawInfo.startElementDrawPtr);  // GPU 内存中的首地址
            
        } else {
            
            glDrawArrays(drawInfo.primitiveMode,
                         drawInfo.startDrawIndex,
                         drawInfo.verticesIndicesCount);
            
        }
        
    }

}

#pragma mark -
#pragma mark Private:
#pragma mark -

/**
 *  绘制信息
 */
- (void)drawInfoMaker {
    
    NSArray<VFDrawInfo *> *drawInfos;
    
    switch (self.drawGeometry) {
        case VFDrawGeometryType_Test: {
            
            drawInfos = [self drawInfoForVFDrawGeometryTypeTestMode];
            
            break;
        }
        case VFDrawGeometryType_Tree: {
        
            drawInfos = [self drawInfoForVFDrawGeometryTypeTreeMode];
            
            break;
            
        }
        case VFDrawGeometryType_Card: {
            
            drawInfos = [self drawInfoForVFDrawGeometryTypeCardMode];
            
            break;
        }
        case VFDrawGeometryType_Grass: {
            
            drawInfos = [self drawInfoForVFDrawGeometryTypeGrassMode];
            
            break;
        }
    }
    
    self.drawInfos = drawInfos;
    
}

- (NSArray<VFDrawInfo *> *)drawInfoForVFDrawGeometryTypeTestMode {
    
    VFVBODataStoredInfo *positionColorVBOInfo =
        [[VFVBODataStoredInfo alloc] initWithDataBindType:VFDataBindType_VBOs
                                               bufferType:VFVBOType_Array
                                                 dataSize:sizeof(vertices)
                                                  dataPtr:vertices
                                             VBODataUsage:VFVBOUsage_StaticDraw];
    self.VBODataInfos = @[positionColorVBOInfo];
    
    // --------------------------- //
    
    NSMutableArray *drawInfoArray = [NSMutableArray array];
    
    VFShaderValueInfo *positionInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:POSITION_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    
    VFAttachVertexInfo *positionAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) offsetof(VFVertex, Position)];
    
    VFShaderValueInfo *colorInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:COLOR_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    
    VFAttachVertexInfo *colorAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:colorInfo
                                        coordinateComsCount:ColorCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) offsetof(VFVertex, Color)];
    NSArray *attachInfos = @[positionAttachInfo, colorAttachInfo];
    
    VFDrawInfo *drawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:attachInfos
                                     dataStoredType:VFCPUDataStoredType_SOAs
                                      primitiveMode:VFPrimitiveModeTriangles
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(vertices) / sizeof(vertices[0]))];
    
    [drawInfoArray addObject:drawInfo];
    
    return drawInfoArray;
    
}

- (NSArray<VFDrawInfo *> *)drawInfoForVFDrawGeometryTypeTreeMode {

    VFVBODataStoredInfo *linePositionVBOInfo =
        [[VFVBODataStoredInfo alloc] initWithDataBindType:VFDataBindType_VBOs
                                               bufferType:VFVBOType_Array
                                                 dataSize:sizeof(_Tree)
                                                  dataPtr:_Tree
                                             VBODataUsage:VFVBOUsage_StaticDraw];
    
    VFVBODataStoredInfo *bodyPositionVBOInfo =
        [[VFVBODataStoredInfo alloc] initWithDataBindType:VFDataBindType_VBOs
                                               bufferType:VFVBOType_Element_Array
                                                 dataSize:sizeof(_Tree)
                                                  dataPtr:_Tree
                                          elementDataSize:sizeof(_TreeTrianglesElements)
                                           elementDataPtr:_TreeTrianglesElements
                                             VBODataUsage:VFVBOUsage_StaticDraw];
    
    self.VBODataInfos = @[linePositionVBOInfo, bodyPositionVBOInfo];
    
    // --------------------------- //
    
    NSMutableArray *drawInfoArray = [NSMutableArray array];
    
    VFShaderValueInfo *positionInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:POSITION_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    
    VFAttachVertexInfo *positionAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) offsetof(VFVertex, Position)];
    
    VFShaderValueInfo *colorInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:COLOR_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    
    VFAttachVertexInfo *colorLineAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:colorInfo
                                                dataLoadPtr:(const GLvoid *) whiteColor];
    NSArray *lineAttachInfos = @[positionAttachInfo, colorLineAttachInfo];
    
    VFDrawInfo *lineDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:lineAttachInfos
                                     dataStoredType:VFCPUDataStoredType_SOAs
                                      primitiveMode:VFPrimitiveModeLineLoop
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Tree) / sizeof(_Tree[0]))];
    
    [drawInfoArray addObject:lineDrawInfo];
    
    VFAttachVertexInfo *colorBodyAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:colorInfo
                                                dataLoadPtr:(const GLvoid *) darkGreenColor];
    
    NSArray *bodyAttachInfos = @[positionAttachInfo, colorBodyAttachInfo];
    
    VFDrawInfo *bodyDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:bodyAttachInfos
                                     dataStoredType:VFCPUDataStoredType_SOAs
                                      primitiveMode:VFPrimitiveModeTriangles
                                startElementDrawPtr:DEFAULT_START_ELEMENT_DRAWPTR
                                elementIndicesCount:(GLsizei)(sizeof(_TreeTrianglesElements) /
                                                             sizeof(_TreeTrianglesElements[0]))];
    
    [drawInfoArray addObject:bodyDrawInfo];

    return drawInfoArray;
    
}

- (NSArray<VFDrawInfo *> *)drawInfoForVFDrawGeometryTypeCardMode {

    VFVBODataStoredInfo *positionVBOInfo =
        [[VFVBODataStoredInfo alloc] initWithDataBindType:VFDataBindType_VBOs
                                               bufferType:VFVBOType_Array
                                                 dataSize:sizeof(_Card_Left) + sizeof(_Card_Right) + sizeof(_Card_CenterLine)
                                                  dataPtr:NULL
                                             VBODataUsage:VFVBOUsage_StaticDraw];
    
    VFVBOSubDataStoredInfo *leftPositionVBOInfo =
        [[VFVBOSubDataStoredInfo alloc] initWithVBOOffsetSize:0
                                                     dataSize:sizeof(_Card_Left)
                                                      dataPtr:_Card_Left];
    
    VFVBOSubDataStoredInfo *rightPositionVBOInfo =
        [[VFVBOSubDataStoredInfo alloc] initWithVBOOffsetSize:sizeof(_Card_Left)
                                                     dataSize:sizeof(_Card_Right)
                                                      dataPtr:_Card_Right];
    
    VFVBOSubDataStoredInfo *centerLinePositionVBOInfo =
        [[VFVBOSubDataStoredInfo alloc] initWithVBOOffsetSize:sizeof(_Card_Left) + sizeof(_Card_Right)
                                                     dataSize:sizeof(_Card_CenterLine)
                                                      dataPtr:_Card_CenterLine];
    
    positionVBOInfo.subVBODataInfos = @[leftPositionVBOInfo, rightPositionVBOInfo, centerLinePositionVBOInfo];
    
    self.VBODataInfos = @[positionVBOInfo];
    
    // --------------------------- //
    
    NSMutableArray *drawInfoArray = [NSMutableArray array];
    
    VFShaderValueInfo *positionInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:POSITION_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    VFShaderValueInfo *colorInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:COLOR_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    
    VFAttachVertexInfo *positionLeftAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) 0];
    
    VFAttachVertexInfo *colorLeftAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:colorInfo
                                                dataLoadPtr:(const GLvoid *) darkGreenColor];
    
    VFDrawInfo *leftDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:@[positionLeftAttachInfo, colorLeftAttachInfo]
                                     dataStoredType:VFCPUDataStoredType_AOSs
                                      primitiveMode:VFPrimitiveModeTriangleFan
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Card_Left) / sizeof(_Card_Left[0]))];
    
    [drawInfoArray addObject:leftDrawInfo];

    VFAttachVertexInfo *positionRightAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) sizeof(_Card_Left)];
    
    VFAttachVertexInfo *colorRightAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:colorInfo
                                                dataLoadPtr:(const GLvoid *) _CardPageColor];
    
    VFDrawInfo *rightDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:@[positionRightAttachInfo, colorRightAttachInfo]
                                     dataStoredType:VFCPUDataStoredType_AOSs
                                      primitiveMode:VFPrimitiveModeTriangleStrip
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Card_Right) / sizeof(_Card_Right[0]))];
    
    [drawInfoArray addObject:rightDrawInfo];
    
    VFAttachVertexInfo *positionCenterLineAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) sizeof(_Card_Left) + sizeof(_Card_Right)];
    
    VFAttachVertexInfo *colorCenterLineAttachInfo = colorLeftAttachInfo;
    
    VFDrawInfo *centerLineDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:@[positionCenterLineAttachInfo, colorCenterLineAttachInfo]
                                     dataStoredType:VFCPUDataStoredType_AOSs
                                      primitiveMode:VFPrimitiveModeLines
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Card_CenterLine) / sizeof(_Card_CenterLine[0]))];
    centerLineDrawInfo.lineWidth = 3.0;
    
    [drawInfoArray addObject:centerLineDrawInfo];
    
    return drawInfoArray;
    
}

- (NSArray<VFDrawInfo *> *)drawInfoForVFDrawGeometryTypeGrassMode {
    
    VFVBODataStoredInfo *positionVBOInfo =
        [[VFVBODataStoredInfo alloc] initWithDataBindType:VFDataBindType_VBOs
                                               bufferType:VFVBOType_Array
                                                 dataSize:sizeof(_Grass_Main) + sizeof(_Grass_Left) + sizeof(_Grass_Right)
                                                  dataPtr:NULL
                                             VBODataUsage:VFVBOUsage_StaticDraw];
    
    VFVBOSubDataStoredInfo *mainPositionVBOInfo =
        [[VFVBOSubDataStoredInfo alloc] initWithVBOOffsetSize:0
                                                     dataSize:sizeof(_Grass_Main)
                                                      dataPtr:_Grass_Main];
    
    VFVBOSubDataStoredInfo *leftPositionVBOInfo =
        [[VFVBOSubDataStoredInfo alloc] initWithVBOOffsetSize:sizeof(_Grass_Main)
                                                     dataSize:sizeof(_Grass_Left)
                                                      dataPtr:_Grass_Left];
    
    VFVBOSubDataStoredInfo *rightPositionVBOInfo =
        [[VFVBOSubDataStoredInfo alloc] initWithVBOOffsetSize:sizeof(_Grass_Main) + sizeof(_Grass_Left)
                                                     dataSize:sizeof(_Grass_Right)
                                                      dataPtr:_Grass_Right];
    
    positionVBOInfo.subVBODataInfos = @[mainPositionVBOInfo, leftPositionVBOInfo, rightPositionVBOInfo];
    
    self.VBODataInfos = @[positionVBOInfo];
    
    // --------------------------- //
    
    NSMutableArray *drawInfoArray = [NSMutableArray array];
    
    VFShaderValueInfo *positionInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:POSITION_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    VFShaderValueInfo *colorInfo =
        [self.shaderCodeAnalyzer getAttributeValueInfoEntryWithValueName:COLOR_STRING_KEY
                                                          shaderFileName:@"VFVertexShader"];
    
    VFAttachVertexInfo *colorAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:colorInfo
                                                dataLoadPtr:(const GLvoid *) darkGreenColor];
    
    VFAttachVertexInfo *positionMainAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) 0];
    
    VFDrawInfo *mainDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:@[positionMainAttachInfo, colorAttachInfo]
                                     dataStoredType:VFCPUDataStoredType_AOSs
                                      primitiveMode:VFPrimitiveModeLineStrip
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Grass_Main) / sizeof(_Grass_Main[0]))];
    
    [drawInfoArray addObject:mainDrawInfo];
    
    VFAttachVertexInfo *positionLeftAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) sizeof(_Grass_Main)];
    
    VFDrawInfo *leftDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:@[positionLeftAttachInfo, colorAttachInfo]
                                     dataStoredType:VFCPUDataStoredType_AOSs
                                      primitiveMode:VFPrimitiveModeLineStrip
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Grass_Left) / sizeof(_Grass_Left[0]))];
    
    [drawInfoArray addObject:leftDrawInfo];
    
    VFAttachVertexInfo *positionRightAttachInfo =
        [[VFAttachVertexInfo alloc] initWithShaderValueInfo:positionInfo
                                        coordinateComsCount:PositionCoordinateCount
                                           exchangeDataType:GL_FALSE
                                                   dataType:GL_FLOAT
                                                 dataStride:sizeof(VFVertex)
                                                dataLoadPtr:(const GLvoid *) sizeof(_Grass_Main) + sizeof(_Grass_Left)];
    
    VFDrawInfo *rightDrawInfo =
        [[VFDrawInfo alloc] initWithAttachDataInfos:@[positionRightAttachInfo, colorAttachInfo]
                                     dataStoredType:VFCPUDataStoredType_AOSs
                                      primitiveMode:VFPrimitiveModeLineStrip
                                     startDrawIndex:DEFAULT_START_DRAWINDEX
                               verticesIndicesCount:(GLsizei)(sizeof(_Grass_Right) / sizeof(_Grass_Right[0]))];
    
    [drawInfoArray addObject:rightDrawInfo];
    
    return drawInfoArray;
    
}

- (NSArray<VFDrawInfo *> *)drawInfoForVFDrawGeometryTypePointGrassMode {
    
    NSMutableArray *drawInfoArray = [NSMutableArray array];
    
    
    return drawInfoArray;
    
}

#pragma mark - VBO Create

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
 */
- (void)bindVertexDatasWithVertexBufferID:(GLuint)vertexBufferID
                               bufferType:(GLenum)bufferType
                             verticesSize:(GLsizeiptr)size
                                 datasPtr:(const GLvoid*)dataPtr
                                    usage:(GLenum)usage {
    
    glBindBuffer(bufferType, vertexBufferID);
    // 创建 资源 ( context )
    glBufferData(bufferType,        // 缓存块 类型
                 size,              // 创建的 缓存块 尺寸
                 dataPtr,           // 要绑定的顶点数据
                 usage);            // 缓存块 用途
    
}

/**
 *  使用顶点缓存对象追加数据
 *
 */
- (void)bindVertexSubDatasWithBufferType:(GLenum)bufferType
                            verticesSize:(GLsizeiptr)size
                                datasPtr:(const GLvoid*)dataPtr
                              offsetSize:(GLintptr)offsetSize {
    
    // 调整 资源的内存地址 ( context )
    glBufferSubData(bufferType, // 缓存块 类型
                    offsetSize, // 数据偏移的内存地址
                    size,       // 资源的 缓存块 尺寸
                    dataPtr);   // 要绑定的顶点数据
    
}


/**
 *  删除顶点缓存对象
 */
- (void)deleteVertexBufferObject {
    
    for (VFVBODataStoredInfo *storedDataInfo in self.VBODataInfos) {
        
        GLuint VBOId = (GLuint)storedDataInfo.vertexBufferID;
        if (glIsBuffer(VBOId) && VBOId != InvaildVBOID) {
            glDeleteBuffers(VertexBufferMemoryBlock(1), &VBOId);
        }
        
        GLuint VBOEleId = (GLuint)storedDataInfo.vertexElementBufferId;
        if (glIsBuffer(VBOEleId) && VBOEleId != InvaildVBOID) {
            glDeleteBuffers(VertexBufferMemoryBlock(1), &VBOEleId);
        }
        
    }
    
    self.VBODataInfos = nil;
    
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
- (void)attachVertexArraysWithDrawInfo:(VFDrawInfo *)info {
    
    for (VFAttachVertexInfo *attachInfo in info.attachDataInfos) {
        
        VFShaderValueInfo *shaderInfo = attachInfo.shaderValueInfo;
        
        // 只有在 VAOs 或 VBOs 模式下才有这个值
        if (attachInfo.coordinateComsCount) {
            
            glEnableVertexAttribArray((GLint)shaderInfo.location);
            glVertexAttribPointer((GLint)shaderInfo.location,           // 要处理的顶点数据的下标，如：Position 就是 0
                                                                        // 0 是自己定的，反正 attribute [0, MAX]
                                  
                                  attachInfo.coordinateComsCount,       // 提供的顶点数据中，单个元素自身有多少个分量
                                  
                                  attachInfo.dataType,                  // 如： Position, 有 {x, y , z} 三个分量
                                                                        // 数据的基本数据类型是什么
                                  
                                  attachInfo.exchangeDataType,          // 要不要进行，数据类型的转换
                                                                        // OpenGL ES 只支持 float 类型的数据
                                  
                                  attachInfo.dataStride,                // 第 I 个元素，到 第 ( I + 1 ) 个元素的偏移量是多少
                                  
                                  attachInfo.dataLoadPtr);              // 元素的起始地址指针
            
        } else {
            
            glDisableVertexAttribArray((GLint)shaderInfo.location);
            glVertexAttrib4fv((GLint)shaderInfo.location, attachInfo.dataLoadPtr);
            
        }
        
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




