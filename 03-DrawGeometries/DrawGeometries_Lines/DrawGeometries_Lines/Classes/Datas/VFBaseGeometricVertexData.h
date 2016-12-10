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

// 单线段
static const VFVertex singleLineVertices[] = {
    { 0.5f,  0.5f, 0.0f},
    {-0.5f, -0.5f, 0.0f},
};
// 交叉线
static const VFVertex crossLinesVertices[] = {
    // Line one
    { 0.5f,  0.5f, 0.0f},
    {-0.5f, -0.5f, 0.0f},
    // Line Two
    {-0.53f, 0.48f, 0.0f},
    { 0.55f, -0.4f, 0.0f},
};
// 折线（山丘）
static const VFVertex mountainLinesVertices[] = {
    // Point one
    {-0.9f, -0.8f, 0.0f},
    
    // Point Two
    {-0.6f, -0.4f, 0.0f},
    
    // Point Three
    {-0.4f, -0.6f, 0.0f},
    
    // Point Four
    { 0.05f, -0.05f, 0.0f},
    
    // Point Five
    {0.45f, -0.65f, 0.0f},
    
    // Point Six
    { 0.55f,  -0.345f, 0.0f},
    
    // Point Seven
    { 0.95f, -0.95f, 0.0f},
};
// 三角形
static const VFVertex triangleLinesVertices[] = {
    // Point one
	{0.000000, 0.500000, 0.000000},
    
    // Point Two
	{-0.433013, -0.250000, 0.000000},
    
    // Point Three
	{0.433013, -0.250000, 0.000000},
};

// 四边形（ 0，1，2，3，0，2 ）
static const VFVertex rectangleLinesVertices[] = {
    // Point one
	{-0.353553, 0.353553, 0.000000},    // V0
    
    // Point Two
	{-0.353553, -0.353553, 0.000000},   // V1
    
    // Point Three
	{0.353553, -0.353553, 0.000000},    // V2
    
    // Point Four
	{0.353553, 0.353553, 0.000000},     // V3
};

static const GLubyte rectangleElementIndeices[] = {
    
    0, 1, 2,
    3, 0, 2,
    
};

// 五边形
static const VFVertex pentagonsLinesVertices[] = {
    // Line one
	{0.000000, 0.500000, 0.000000},
    
    // Line Two
	{-0.475528, 0.154509, 0.000000},
    
    // Line Three
	{-0.293893, -0.404509, 0.000000},
    
    // Line Four
	{0.293893, -0.404509, 0.000000},
    
    // Line Five
	{0.475528, 0.154509, 0.000000},
};

static const GLubyte pentagonsElementIndeices[] = {
    
    4, 1, 0, 4,
    3, 1, 2, 3,
    
};

// 六边形
static const VFVertex hexagonsLinesVertices[] = {
    // Point one
	{0.000000, 0.500000, 0.000000},
    
    // Point Two
	{-0.433013, 0.250000, 0.000000},
    
    // Point Three
	{-0.433013, -0.250000, 0.000000},
    
    // Point Four
	{-0.000000, -0.500000, 0.000000},
    
    // Point Five
    {0.433013, -0.250000, 0.000000},
    
    // Point Six
    {0.433013, 0.250000, 0.000000},
};

static const GLubyte hexagonsElementIndeices[] = {
    
    5, 1, 0, 5,
    4, 1, 2, 4,
    3, 2,
    
};

// 梯形
static const VFVertex trapezoidLinesVertices[] = {
    // Point one
	{0.430057, 0.350000, 0.000000},
    
    // Point Two
	{-0.430057, 0.350000, 0.000000},
    
    // Point Three
	{-0.180057, -0.350000, 0.000000},
    
    // Point Four
	{0.180057, -0.350000, 0.000000},
};

static const GLubyte trapezoidElementIndeices[] = {
    
    1, 2, 3, 0,
    1, 3,
    
};

// 五角星形
static const VFVertex pentagramLinesVertices[] = {
    // Point one
	{0.000000, 0.500000, 0.000000},
    
    // Point Two
	{-0.176336, 0.242705, 0.000000},
    
    // Point Three
	{-0.475528, 0.154509, 0.000000},
    
    // Point Four
	{-0.285317, -0.092705, 0.000000},
    
    // Point Five
    {-0.293893, -0.404509, 0.000000},
    
    // Point Six
	{-0.000000, -0.300000, 0.000000},
    
    // Point Seven
    {0.293893, -0.404509, 0.000000},
    
    // Point Eight
    {0.285317, -0.092705, 0.000000},
    
    // Point Nine
    {0.475528, 0.154509, 0.000000},
    
    // Point Ten
    {0.176336, 0.242705, 0.000000},
};

static const GLubyte pentagramElementIndeices[] = {
    
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 0, 1,
    9, 7, 5, 3, 1,
    5, 7, 1
    
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

static const GLfloat whiteColor[]  = {1, 1, 1, 1};
static const GLfloat greenColor[]  = {0.796, 1.000, 0.102, 1.000};  // 淡黄色

#pragma mark - Inline Method

static inline GLuint verticesCount() {
    
    return (sizeof(vertices) / sizeof(vertices[0]));
    
}

static inline GLuint drawPrimitiveCountWithPrimitiveMode(VFPrimitiveMode mode) {
    
    GLuint verticesCount = (sizeof(vertices) / sizeof(vertices[0]));
    
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



