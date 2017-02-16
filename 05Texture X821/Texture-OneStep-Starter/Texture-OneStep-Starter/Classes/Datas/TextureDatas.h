//
//  TextureDatas.h
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/14.
//  Copyright © 2017年 Windy. All rights reserved.
//

#ifndef TextureDatas_h
#define TextureDatas_h

#import <OpenGLES/gltypes.h>

typedef struct {
    GLfloat position[3];
    GLfloat texCoord[2];
}VYVertex;

// MARK: Square

static const VYVertex tex2DSquareDatas[] = {
    {{-1.0, -1.0, 0.0}, {0.0, 0.0}},
    {{ 1.0, -1.0, 0.0}, {1.0, 0.0}},
    {{ 1.0,  1.0, 0.0}, {1.0, 1.0}},
    {{-1.0,  1.0, 0.0}, {0.0, 1.0}},
};

static const GLubyte squareIndices[] = {
    0, 1, 2,
    2, 3, 0,
};

static const GLfloat tex2DSquarePixelDatas[] = {
    255, 0.0, 255,
    0.0, 255, 0.0,
    255, 255, 0.0,
    0.0, 255, 255,
};

// MARK: Cube

static const VYVertex tex2DCubeDatas[] = {
    
};

static const GLubyte cubeIndices[] = {
    
};

#endif /* TextureDatas_h */
