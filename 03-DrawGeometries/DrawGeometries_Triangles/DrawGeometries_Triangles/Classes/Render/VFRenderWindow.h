//
//  VFRenderWindow.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VFRenderContext.h"

@interface VFRenderWindow : UIView

/**
 *  返回当前活跃的渲染上下文
 *
 *  @return VFRenderContext 继承于 EAGLContext
 */
- (VFRenderContext *)currentContext;

/**
 *  显示前，准备顶点数据、着色器等
 */
- (void)prepareDisplay;

/**
 *  显示图形
 */
- (void)display;

@end
