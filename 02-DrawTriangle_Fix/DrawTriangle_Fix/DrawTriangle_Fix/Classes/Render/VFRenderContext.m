//
//  VFRenderContext.m
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFRenderContext.h"

@implementation VFRenderContext

#pragma mark -
#pragma mark Public:
#pragma mark -

#pragma mark Drawable

/**
 *  绑定进行渲染的窗口
 *
 *  @param drawableLayer 渲染的窗口
 */
- (void)bindDrawableLayer:(CAEAGLLayer *)drawableLayer {
    
    if ( ! [drawableLayer isKindOfClass:[CAEAGLLayer class]] ) {
        return;
    }
    
    [self renderbufferStorage:GL_RENDERBUFFER fromDrawable:drawableLayer];
    
}

#pragma mark - Clear

/**
 *  设置渲染窗口的背景色
 *
 *  @param color RGBA 颜色值
 */
- (void)setRenderBackgroundColor:(RGBAColor)color {
    
    glClearColor(color.red, color.green, color.blue, color.alpha);
    
}

/**
 *  重置（清空）渲染内存
 */
- (void)clearRenderBuffer {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
}

#pragma mark - View Port

/**
 *  设置视窗
 */
- (void)setRenderViewPortWithCGRect:(CGRect)rect {
    
    glViewport(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
}

#pragma mark - Render

/**
 *  开始渲染
 */
- (void)render {
    
    [self presentRenderbuffer:GL_RENDERBUFFER];
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

@end
