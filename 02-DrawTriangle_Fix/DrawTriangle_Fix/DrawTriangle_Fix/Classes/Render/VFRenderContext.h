//
//  VFRenderContext.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFCommon.h"

@interface VFRenderContext : EAGLContext

/**
 *  绑定进行渲染的窗口
 *
 *  @param deawableLayer 渲染的窗口
 */
- (void)bindDrawableLayer:(CAEAGLLayer *)drawableLayer;

/**
 *  设置渲染窗口的背景色
 *
 *  @param color RGBA 颜色值
 */
- (void)setRenderBackgroundColor:(RGBAColor)color;

/**
 *  重置（清空）渲染内存
 */
- (void)clearRenderBuffer;

/**
 *  设置视窗
 */
- (void)setRenderViewPortWithCGRect:(CGRect)rect;

/**
 *  开始渲染
 */
- (void)render;

@end
