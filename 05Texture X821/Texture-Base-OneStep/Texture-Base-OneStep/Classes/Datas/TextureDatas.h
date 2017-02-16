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
    1.000, 1.000, 0.108,//[UIColor colorWithRed:1.000 green:1.000 blue:0.108 alpha:1.000]
    0.458, 1.000, 0.404,//[UIColor colorWithRed:0.458 green:1.000 blue:0.404 alpha:1.000]
    0.458, 1.000, 0.770,//[UIColor colorWithRed:0.458 green:1.000 blue:0.770 alpha:1.000]
    0.729, 0.350, 0.770,//[UIColor colorWithRed:0.729 green:0.350 blue:0.770 alpha:1.000]
};

// MARK: Cube

static const VYVertex tex2DCubeDatas[] = {
    
};

static const GLubyte cubeIndices[] = {
    
};

#endif /* TextureDatas_h */
