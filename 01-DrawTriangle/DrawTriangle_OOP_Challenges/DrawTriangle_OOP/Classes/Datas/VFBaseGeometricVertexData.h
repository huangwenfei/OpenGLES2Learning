//
//  VFBaseGeometricVertexData.h
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
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

// Base Triangle
static const VFVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}, {0.343, 0.187, 0.630, 1.000}}, // lower left corner       // 紫色
    {{ 0.5f, -0.5f, 0.0}, {0.987, 0.134, 0.733, 1.000}}, // lower right corner      // 紫红色
    {{-0.5f,  0.5f, 0.0}, {0.987, 0.667, 0.341, 1.000}}, // upper left corner       // 橙色
};

static const GLfloat whiteColor[]  = {1, 1, 1, 1};
static const GLfloat greenColor[] = {0.796, 1.000, 0.102, 1.000};  // 淡黄色

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



