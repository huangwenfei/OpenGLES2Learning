//
//  VFBaseGeometricVertexData.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFBaseGeometricVertexData_h
#define VFBaseGeometricVertexData_h

#import "VFCommon.h"

typedef enum {
    
    VFPrimitiveModePoints           = GL_POINTS,
    
    VFPrimitiveModeLines            = GL_LINES,
    VFPrimitiveModeLineStrip        = GL_LINE_STRIP,
    VFPrimitiveModeLineLoop         = GL_LINE_LOOP,
    
    VFPrimitiveModeTriangles        = GL_TRIANGLES,
    VFPrimitiveModeTriangleStrip    = GL_TRIANGLE_STRIP,
    VFPrimitiveModeTriangleFan      = GL_TRIANGLE_FAN,
    
} VFPrimitiveMode;

typedef struct {
    
    GLfloat Position[PositionCoordinateCount]; // { x, y, z }
    GLfloat Color[ColorCoordinateCount];
    
} VFVertex;

#pragma mark - Points Datas

#pragma mark - Lines Datas

typedef struct {
    
    // 数据所占的内存大小
    GLsizeiptr dataSize;
    // 数据的内存首地址
    const GLvoid *dataPtr;
    // 需要绘制的点数量
    GLsizei verticesIndicesCount;
    // 图元的绘制类型
    VFPrimitiveMode primitiveMode;
    // 下标数据所占的内存大小
    GLsizeiptr elementDataSize;
    // 下标内存首地址
    const GLvoid *elementDataPtr;
    // 下标个数
    GLsizei elementIndicesCount;
    
} VFDrawInfo;

static inline VFDrawInfo VFDrawInfoMake ( GLsizeiptr dataSize,
                                          const GLvoid *dataPtr,
                                          GLsizei verticesIndicesCount,
                                          VFPrimitiveMode primitiveMode,
                                          GLsizeiptr elementDataSize,
                                          const GLvoid *elementDataPtr,
                                          GLsizei elementIndicesCount) {
    
    VFDrawInfo info = {
        
        .dataSize = dataSize,
        .dataPtr  = dataPtr,
        .verticesIndicesCount = verticesIndicesCount,
        .primitiveMode = primitiveMode,
        .elementDataSize = elementDataSize,
        .elementDataPtr = elementDataPtr,
        .elementIndicesCount = elementIndicesCount,
        
    };
    
    return info;
    
}

#define DEFAULT_LINE_WITH   (8)

// 三角形
static const VFVertex triangleTrianglesVertices[] = {
    // Point V0
	{0.000000, 0.500000, 0.000000},
    
    // Point V1
	{-0.433013, -0.250000, 0.000000},
    
    // Point V2
	{0.433013, -0.250000, 0.000000},
};

// 四边形（ 0，1，2，3，0，2 ）
static const VFVertex rectangleTrianglesVertices[] = {

    // GL_TRIANGLE_FAN
    // Point V0
	{-0.353553, 0.353553, 0.000000},    // V0
    
    // Point V1
	{-0.353553, -0.353553, 0.000000},   // V1
    
    // Point V2
	{0.353553, -0.353553, 0.000000},    // V2
    
    // Point V3
	{0.353553, 0.353553, 0.000000},     // V3
    
    // GL_TRIANGLE_STRIP
//    // Point V0
//    {-0.353553, 0.353553, 0.000000},    // V0
//    
//    // Point V1
//    {-0.353553, -0.353553, 0.000000},   // V1
//    
//    // Point V3
//    {0.353553, 0.353553, 0.000000},     // V3
//    
//    // Point V2
//    {0.353553, -0.353553, 0.000000},    // V2
};

// 五边形
static const VFVertex pentagonsTrianglesVertices[] = {
    
    // GL_TRIANGLE_FAN
//    // Point V0
//	{0.000000, 0.500000, 0.000000},
//    
//    // Point V1
//	{-0.475528, 0.154509, 0.000000},
//    
//    // Point V2
//	{-0.293893, -0.404509, 0.000000},
//    
//    // Point V3
//	{0.293893, -0.404509, 0.000000},
//    
//    // Point V4
//	{0.475528, 0.154509, 0.000000},
    
    // GL_TRIANGLE_STRIP
    // Point V1
    {-0.475528, 0.154509, 0.000000},
    
    // Point V2
    {-0.293893, -0.404509, 0.000000},
    
    // Point V0
    {0.000000, 0.500000, 0.000000},
    
    // Point V3
    {0.293893, -0.404509, 0.000000},
    
    // Point V4
    {0.475528, 0.154509, 0.000000},
    
};

// 六边形
static const VFVertex hexagonsTrianglesVertices[] = {
    
    // GL_TRIANGLE_FAN
    // Point V0
	{0.000000, 0.500000, 0.000000},
    
    // Point V1
	{-0.433013, 0.250000, 0.000000},
    
    // Point V2
	{-0.433013, -0.250000, 0.000000},
    
    // Point V3
	{-0.000000, -0.500000, 0.000000},
    
    // Point V4
    {0.433013, -0.250000, 0.000000},
    
    // Point V5
    {0.433013, 0.250000, 0.000000},
    
    // GL_TRIANGLE_STRIP
//    // Point V1
//    {-0.433013, 0.250000, 0.000000},
//    
//    // Point V2
//    {-0.433013, -0.250000, 0.000000},
//    
//    // Point V0
//    {0.000000, 0.500000, 0.000000},
//    
//    // Point V3
//    {-0.000000, -0.500000, 0.000000},
//    
//    // Point V4
//    {0.433013, -0.250000, 0.000000},
//    
//    // Point V5
//    {0.433013, 0.250000, 0.000000},
//    
//    // Point V0
//    {0.000000, 0.500000, 0.000000},
    
};

// 梯形
static const VFVertex trapezoidTrianglesVertices[] = {
    
    // GL_TRIANGLE_FAN
//    // Point V0
//	{0.430057, 0.350000, 0.000000},
//    
//    // Point V1
//	{-0.430057, 0.350000, 0.000000},
//    
//    // Point V2
//	{-0.180057, -0.350000, 0.000000},
//    
//    // Point V3
//	{0.180057, -0.350000, 0.000000},
    
    // GL_TRIANGLE_STRIP
    // Point V0
    {0.430057, 0.350000, 0.000000},
    
    // Point V1
    {-0.430057, 0.350000, 0.000000},
    
    // Point V3
    {0.180057, -0.350000, 0.000000},
    
    // Point V2
    {-0.180057, -0.350000, 0.000000},
    
};

// 五角星形 10 = (n - 2) -> n = 12
static const VFVertex pentagramTrianglesVertices[] = {
    
    // GL_TRIANGLE_FAN
    // Point V0
    {0.000000, 0.000000, 0.000000}, // 在原来的基础上，增加的起点
    
    // Point V1
	{0.000000, 0.500000, 0.000000},
    
    // Point V2
	{-0.176336, 0.242705, 0.000000},
    
    // Point V3
	{-0.475528, 0.154509, 0.000000},
    
    // Point V4
	{-0.285317, -0.092705, 0.000000},
    
    // Point V5
    {-0.293893, -0.404509, 0.000000},
    
    // Point V6
	{-0.000000, -0.300000, 0.000000},
    
    // Point V7
    {0.293893, -0.404509, 0.000000},
    
    // Point V8
    {0.285317, -0.092705, 0.000000},
    
    // Point V9
    {0.475528, 0.154509, 0.000000},
    
    // Point V10
    {0.176336, 0.242705, 0.000000},
    
    // Point V11
	{0.000000, 0.500000, 0.000000},// 在原来的基础上，增加的终点

};

#define DEFAULT_LINE_LENGTH                 (0.3f)
#define DEFAULT_GEOMETRY_ANGLE(nLines)      (360 / (nLines))
#define DEFAULT_ROUND_RADII(nLines)         (sqrt((DEFAULT_LINE_LENGTH / (2*(1-cos(DEFAULT_GEOMETRY_ANGLE(nLines)))))))

#pragma mark - Triangle Datas (Structure of Arrays [ SOAs ])

// Base Triangle
static const VFVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}, {0.343, 0.187, 0.630, 1.000}}, // lower left corner       // 紫色
    {{ 0.5f, -0.5f, 0.0}, {0.987, 0.134, 0.733, 1.000}}, // lower right corner      // 紫红色
    {{-0.5f,  0.5f, 0.0}, {0.987, 0.667, 0.341, 1.000}}, // upper left corner       // 橙色
};

static const GLfloat whiteColor[]       = {1, 1, 1, 1};
static const GLfloat greenColor[]       = {0.796, 1.000, 0.102, 1.000};  // 淡黄色
static const GLfloat darkGreenColor[]   = {0.180, 0.600, 0.486, 1.000};  // 暗绿色

#pragma mark - Inline Method

static inline GLuint verticesCount() {
    
    return (sizeof(vertices) / sizeof(vertices[0]));
    
}

static inline GLuint drawPrimitiveCountWithPrimitiveMode(VFPrimitiveMode mode, GLsizei dataSize, void* dataType) {
    
    GLuint verticesCount = (dataSize / sizeof(dataType));
    
    // Primitive Point-Sprites
    if (VFPrimitiveModePoints == mode) {
        return verticesCount;
    }
    
    // Primitive Lines
    if (VFPrimitiveModeLines == mode) {
        return (verticesCount / 2);
    }
    
    if (VFPrimitiveModeLineStrip == mode) {
        return (verticesCount - 1);
    }
    
    if (VFPrimitiveModeLineLoop == mode) {
        return verticesCount;
    }
    
    // Primitive Triangles
    if (VFPrimitiveModeTriangles == mode) {
        return (verticesCount / 3);
    }
    
    if (VFPrimitiveModeTriangleStrip == mode || VFPrimitiveModeTriangleFan == mode) {
        return (verticesCount - 2);
    }
    
    return 0;
    
}

#endif /* VFBaseGeometricVertexData_h */



