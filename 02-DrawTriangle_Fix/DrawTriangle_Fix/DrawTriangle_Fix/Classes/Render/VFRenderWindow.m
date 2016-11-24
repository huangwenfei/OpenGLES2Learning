//
//  VFRenderWindow.m
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFRenderWindow.h"
#import "VFCommon.h"
#import "VFRenderBufferManager.h"
#import "VFFrameBufferManager.h"
#import "VFShaderManager.h"
#import "VFVertexDatasManager.h"

static const RGBAColor DefaultBackgroundColor = {0.4, 0.7, 0.9, 1.f}; // 淡蓝色

@interface VFRenderWindow ()<OpenELESErrorHandleNotification>
@property (strong, nonatomic) VFRenderContext *renderContext;

@property (strong, nonatomic) VFFrameBufferManager  *fboManager;
@property (strong, nonatomic) VFRenderBufferManager *rboManager;
@property (strong, nonatomic) VFShaderManager       *shaderManager;
@property (strong, nonatomic) VFVertexDatasManager  *vertexManager;
@end

@implementation VFRenderWindow

#pragma mark -
#pragma mark Override: Getters
#pragma mark -

- (VFFrameBufferManager *)fboManager {
    
    if ( ! _fboManager ) {
        _fboManager = [[VFFrameBufferManager alloc] init];
    }
    
    return _fboManager;
    
}

- (VFRenderBufferManager *)rboManager {
    
    if ( ! _rboManager ) {
        _rboManager = [[VFRenderBufferManager alloc] init];
    }
    
    return _rboManager;
    
}

- (VFShaderManager *)shaderManager {
    
    if ( ! _shaderManager ) {
        _shaderManager = [[VFShaderManager alloc] init];
    }
    
    return _shaderManager;
    
}

- (VFVertexDatasManager *)vertexManager {
    
    if ( ! _vertexManager ) {
        _vertexManager = [[VFVertexDatasManager alloc] init];
    }
    
    return _vertexManager;
    
}

#pragma mark -
#pragma mark Override:
#pragma mark -

#pragma mark Layer Class

/**
 *  使默认的 CALayer 变成 CAEAGLLayer , 专门用于 OpenGL | ES 内容的显示
 */
+ (Class)layerClass { // Step 1
    return [CAEAGLLayer class];
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commit];
    }
    return self;
}

- (void)commit {
    
    CAEAGLLayer *glLayer = (CAEAGLLayer *)self.layer;
    
    // Drawable Property Keys
    /*
     // a. kEAGLDrawablePropertyRetainedBacking
     // The key specifying whether the drawable surface retains its contents after displaying them.
     // b. kEAGLDrawablePropertyColorFormat
     // The key specifying the internal color buffer format for the drawable surface.
     */
    
    // Step 2
    glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(YES), // retained unchange
                                   kEAGLDrawablePropertyColorFormat     : kEAGLColorFormatRGBA8 // 32-bits Color
                                   };
    
    glLayer.contentsScale = [UIScreen mainScreen].scale;
    glLayer.opaque = YES;
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark -
#pragma mark Public:
#pragma mark -

/**
 *  返回当前活跃的渲染上下文
 *
 *  @return VFRenderContext 继承于 EAGLContext
 */
- (VFRenderContext *)currentContext {
    
    return (VFRenderContext *)[VFRenderContext currentContext];
    
}

/**
 *  显示前，准备顶点数据、着色器等
 */
- (void)prepareDisplay {
    
    // 添加一个资源释放的监听
    [self addReleaseSourceNotification];
    
    // Step 3, 设置当前活跃的渲染上下文
    [self settingContext];
    
    // Step 4, 设置背景色
//    RGBAColor backgroundColor = RGBAColorMake(0.449, 0.487, 0.669, 1.000);
    [self.renderContext setRenderBackgroundColor:DefaultBackgroundColor];
    
    // Step 5, 配置渲染缓存对象、帧缓存对象
    [self settingRenderBufferObject];
    [self settingFrameBufferObject];
    [self attachRenderBufferToFrameBuffer];
    
    [self.renderContext bindDrawableLayer:(CAEAGLLayer *)self.layer];
    
    // Step 6, 配置着色器程序
    [self settingShaderProgram];
    
    // Step 7, 清空旧渲染内存
    [self.renderContext clearRenderBuffer];
    
    // Step 8, 设置窗口位置和尺寸
    CGRect viewPort = CGRectMake(OpenGLES_OriginX, OpenGLES_OriginY,
                                 self.rboManager.renderBufferSize.width,
                                 self.rboManager.renderBufferSize.height);
    [self.renderContext setRenderViewPortWithCGRect:viewPort];
    
    // Step 9, 装载顶点数据
    [self prepareVertexDatas];
    
}

/**
 *  显示图形
 */
- (void)display {
    
    // Step 10, 绘制、渲染三角形
    [self drawTriangle];
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

#pragma mark Context

/**
 *  配置当前的渲染上下文，并使其成为当前活跃的渲染上下文
 */
- (void)settingContext {
    
    self.renderContext = [[VFRenderContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [VFRenderContext setCurrentContext:self.renderContext];
    
}

#pragma mark - Render Buffer

/**
 *  配置渲染缓存对象
 */
- (void)settingRenderBufferObject {
    
    [self.rboManager createRenderBufferObject];
    [self.rboManager useRenderBufferObject];
    
}

#pragma mark - Frame Buffer

/**
 *  配置帧缓存对象
 */
- (void)settingFrameBufferObject {
    
    [self.fboManager createFrameBufferObject];
    [self.fboManager useFrameBufferObject];
    
}

/**
 *  装载渲染缓存的内容到帧缓存中
 */
- (void)attachRenderBufferToFrameBuffer {
    
    [self.fboManager attachRenderBufferToFrameBuffer:self.rboManager.currentRBOIdentifier];
    
}

#pragma mark - Shader

/**
 *  装载着色器
 */
- (void)settingShaderProgram {
    
    [self.shaderManager attachVertexShader:@"VFVertexShader.glsl"
                            fragmentShader:@"VFFragmentShader.glsl"];
    
}

#pragma mark - Vertex Data 

/**
 *  装载顶点数据
 */
- (void)prepareVertexDatas {
    
    [self.vertexManager attachVertexDatas];
    
}

#pragma mark - Draw & Render 

/**
 *  绘制并渲染图形
 */
- (void)drawTriangle {

    [self.shaderManager useShader];
    [self.vertexManager makeScaleToFitCurrentWindowWithScale:[self.rboManager windowScaleFactor]];
    [self.vertexManager draw];
    [self.renderContext render];
    
}

#pragma mark - <OpenELESErrorHandleNotification>

- (void)addReleaseSourceNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(releaseSourceCallBack:)
                                                 name:VFErrorHandleNotificationName
                                               object:nil];
    
}

- (void)removeReleaseSourceNotification {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:VFErrorHandleNotificationName
                                                  object:nil];

}

- (void)releaseSourceCallBack:(NSNotification *)info {

    id object = info.object;

    if ([object isEqual:[VFRenderBufferManager class]]) {
        [self.fboManager releaseSource];
    }
    
    if ([object isEqual:[VFShaderManager class]]) {
        [self.fboManager releaseSource];
        [self.rboManager releaseSource];
    }
    
    if ([object isEqual:[VFVertexDatasManager class]]) {
        [self.fboManager    releaseSource];
        [self.rboManager    releaseSource];
        [self.shaderManager releaseSource];
    }
    
}

#pragma mark - Draw Rect

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Dealloc

- (void)dealloc {
    
    [self removeReleaseSourceNotification];
    
}

@end
