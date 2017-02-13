//
//  VFVertex.h
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFVertex_h
#define VFVertex_h

#import "NSValue+Struct2Value.h"

#define PositionCoordinateCount     (3)
#define NormalCoordinateCount       (3)
#define TextureCoordinateCount      (2)

#define ColorCoordinateCount        (4)

#pragma mark - VFVertex

typedef struct {
    
    GLfloat Position[PositionCoordinateCount]; // { x, y, z }
    GLfloat Color[ColorCoordinateCount];
    
} VFVertex;

typedef NSValue VFVertexValue;

static inline VFVertex VFVertexMake(GLfloat Position[PositionCoordinateCount],
                                    GLfloat Color[ColorCoordinateCount]) {
    
    VFVertex _ver;
    for (NSUInteger i = 0; i < PositionCoordinateCount; i++) {
        _ver.Position[i] = Position[i];
    }
    
    for (NSUInteger i = 0; i < ColorCoordinateCount; i++) {
        _ver.Color[i] = Color[i];
    }
    
    return _ver;
    
};

/**
 *  把 VFVertex 点封装成 NSValue 对象
 */
VFVertexValue * VFVertexToValue(VFVertex *info) {
    return [NSValue valueObjByStructPtr:info objType:@encode(VFVertex)];
}

/**
 *  把 VFVertex 点从 NSValue 对象中提取出来
 */
void valueToVFVertex(VFVertexValue *infoV, VFVertex *storedInfo) {
    [NSValue structFromValueObj:infoV structPtr:storedInfo];
}

#endif /* VFVertex_h */
