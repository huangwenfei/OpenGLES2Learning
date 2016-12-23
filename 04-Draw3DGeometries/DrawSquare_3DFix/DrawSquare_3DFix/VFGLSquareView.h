//
//  VFGLTriangleView.h
//  DrawTriangle_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VertexDataMode) {
    VertexDataMode_VAO = 0,
    VertexDataMode_VBO,
};

@interface VFGLSquareView : UIView

- (void)setVertexMode:(VertexDataMode)vertexMode;

- (void)prepareDisplay;
- (void)drawAndRender;

- (void)updateContentsWithSeconds:(NSTimeInterval)seconds;

@end
