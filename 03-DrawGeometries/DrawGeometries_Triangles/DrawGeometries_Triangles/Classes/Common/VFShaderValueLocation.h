//
//  VFShaderValueLocation.h
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/11.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFShaderValueLocation_h
#define VFShaderValueLocation_h

/* Info Key */
static NSString * POSITION_STRING_KEY   = @"Position";
static NSString * COLOR_STRING_KEY      = @"Color";
static NSString * NORMAL_STRING_KEY     = @"Normal";
static NSString * TEXTURE0_STRING_KEY    = @"Texture0";

typedef enum {
    
    VFVertexPositionAttribute = 0,
    VFVertexColorAttribute,
    
} VFVertexAttribute;

#endif /* VFShaderValueLocation_h */
