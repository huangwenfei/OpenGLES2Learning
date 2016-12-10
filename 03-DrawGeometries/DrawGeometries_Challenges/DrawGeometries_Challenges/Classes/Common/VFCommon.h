//
//  VFCommon.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFCommon_h
#define VFCommon_h

#import "VFOpenGLES2XHeader.h"
#import "VFFreeSource.h"
#import "VFHandleError.h"
#import "VFShaderValueLocation.h"

@import QuartzCore;

static inline void EXIT_APPLICATION(void) { exit(1); }

// Color Struct

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
} RGBAColor;

static inline RGBAColor RGBAColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    
    RGBAColor color = {
        
        .red = red,
        .green = green,
        .blue = blue,
        .alpha = alpha,
        
    };
    
    return color;
    
}

// Bottom Left
#define OpenGLES_OriginX     (0)
#define OpenGLES_OriginY     (0)

// --- VertexBufferMode Switch --- //

#define _ON     (1)
#define _OFF    (0)

#define VertexBufferSwitchON    (_ON)
#define VertexBufferSwitchOFF   (_OFF)

#define VertexBufferSwitch(on)  (on)

// ------ //

#define InvaildRBOID        (0)
#define InvaildFBOID        (0)
#define InvaildVBOID        (0)

#define EmptyMessage        (0)

#define InvalidLength       (0)
#define InvalidShaderID     (0)
#define InvalidProgramID    (0)

#define Successfully        (YES)
#define Failure             (NO)

#define DEFAULT_START_ELEMENT_DRAWPTR   (NULL)
#define DEFAULT_START_DRAWINDEX         (0)

#define DrawIndicesCount(n)         (n)

#define DrawStartOffset     (0)
#define StrideCloser        (0)

#endif /* VFCommon_h */
