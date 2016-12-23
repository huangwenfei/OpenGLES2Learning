//
//  VFGLCubeView.m
//  DrawCube_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFGLSquareView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import <GLKit/GLKit.h>

typedef NS_ENUM(NSUInteger, VFDrawableDepthMode) {
    
    VFDrawableDepthMode_None = 0,
    VFDrawableDepthMode_16,
    VFDrawableDepthMode_24,
    
};

@interface VFGLSquareView ()
@property (assign, nonatomic) VertexDataMode vertexMode;
@property (strong, nonatomic) EAGLContext *context;

@property (assign, nonatomic) GLuint frameBufferID;
@property (assign, nonatomic) GLuint colorRenderBufferID, depthRenderBufferID;
@property (assign, nonatomic) CGSize renderBufferSize;

@property (assign, nonatomic) VFDrawableDepthMode depthMode;

@property (assign, nonatomic) GLuint programID;

@property (assign, nonatomic) GLint projectionLoc, modelViewLoc;
@end

@implementation VFGLSquareView

#pragma mark - Setter

- (void)setVertexMode:(VertexDataMode)vertexMode {
    
    _vertexMode = vertexMode;
    
}

#pragma mark - Layer Class

+ (Class)layerClass {
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
    
    glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(YES), // retained unchange
                                   kEAGLDrawablePropertyColorFormat     : kEAGLColorFormatRGBA8 // 32-bits Color
                                   };
    
    glLayer.contentsScale = [UIScreen mainScreen].scale;
    glLayer.opaque = YES;
    
}

#pragma mark - Vertex Buffer Object

#define VertexBufferMemoryBlock    (1)

- (GLuint)createVBO {
    
    GLuint vertexBufferID;
    glGenBuffers(VertexBufferMemoryBlock, &vertexBufferID);
    
    return vertexBufferID;
    
}

#define PositionCoordinateCount      (3)

typedef struct {
    GLfloat position[PositionCoordinateCount];
} VFVertex;

static const VFVertex vertices[] = {
    {{-1.0f, -1.0f, 0.0}}, // lower left corner
    {{ 1.0f, -1.0f, 0.0}}, // lower right corner
    {{ 1.0f,  1.0f, 0.0}}, // upper left corner
    {{-1.0f,  1.0f, 0.0}}, // upper left corner
};

static const GLubyte indices[] = {
    
    0, 1, 2,
    2, 3, 0,
    
};

- (void)bindVertexDatasWithVertexBufferID:(GLuint)vertexBufferID bufferTarget:(GLenum)target dataSize:(GLsizeiptr)size data:(const GLvoid *)data elements:(BOOL)isElement {
    
    if ( ! isElement) {
        glBindBuffer(target, vertexBufferID);
    }
    
    // 创建 资源 ( context )
    glBufferData(target,            // 缓存块 类型
                 size,              // 创建的 缓存块 尺寸
                 data,              // 要绑定的顶点数据
                 GL_STATIC_DRAW);   // 缓存块 用途
    
}

#pragma mark - Shader

+ (GLchar *)vertexShaderCode {
    return  "#version 100 \n"
            "uniform highp mat4 u_Projection; \n"
            "uniform highp mat4 u_ModelView; \n"
            "attribute vec4 v_Position; \n"
            "void main(void) { \n"
                "gl_Position = u_Projection * u_ModelView * v_Position;\n"
            "}";
}

+ (GLchar *)fragmentShaderCode {
    return  "#version 100 \n"
            "void main(void) { \n"
                "gl_FragColor = vec4(1, 1, 1, 1); \n"
            "}";
}

#define ShaderMemoryBlock    (1)

- (GLuint)createShaderWithType:(GLenum)type {
    
    GLuint shaderID = glCreateShader(type);
    
    const GLchar * code = (type == GL_VERTEX_SHADER) ? [[self class] vertexShaderCode] : [[self class] fragmentShaderCode];
    glShaderSource(shaderID,
                   ShaderMemoryBlock,
                   &code,
                   NULL);
    
    return shaderID;
}

- (void)compileVertexShaderWithShaderID:(GLuint)shaderID type:(GLenum)type {
    
    glCompileShader(shaderID);
    
    GLint compileStatus;
    glGetShaderiv(shaderID, GL_COMPILE_STATUS, &compileStatus);
    if (compileStatus == GL_FALSE) {
        GLint infoLength;
        glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *infoLog = malloc(sizeof(GLchar) * infoLength);
            glGetShaderInfoLog(shaderID, infoLength, NULL, infoLog);
            NSLog(@"%s -> %s", (type == GL_VERTEX_SHADER) ? "vertex shader" : "fragment shader", infoLog);
            free(infoLog);
        }
    }
    
}

- (GLuint)createShaderProgram {
    
    return glCreateProgram();
    
}

- (void)attachShaderToProgram:(GLuint)programID vertextShader:(GLuint)vertexShaderID fragmentShader:(GLuint)fragmentShaderID {
    
    glAttachShader(programID, vertexShaderID);
    glAttachShader(programID, fragmentShaderID);
    
}

- (void)linkProgramWithProgramID:(GLuint)programID {
    
    glLinkProgram(programID);
    
    GLint linkStatus;
    glGetProgramiv(programID, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        GLint infoLength;
        glGetProgramiv(programID, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *infoLog = malloc(sizeof(GLchar) * infoLength);
            glGetProgramInfoLog(programID, infoLength, NULL, infoLog);
            NSLog(@"%s", infoLog);
            free(infoLog);
        }
    }
    
}

- (void)userShaderWithProgramID:(GLuint)programID {
    
    glUseProgram(programID);
    
}

#pragma mark - Uniform

- (void)updateUniformsLocationsWithProgramID:(GLuint)programID {
    
    self.projectionLoc = glGetUniformLocation(programID, "u_Projection");
    self.modelViewLoc  = glGetUniformLocation(programID, "u_ModelView");
    
}


- (void)setProjectionMat4:(GLKMatrix4)projectMat4 {
    
    [self setUniformMat4:projectMat4 loc:self.projectionLoc];
    
}

- (void)setModelViewMat4:(GLKMatrix4)modelViewMat4 {
    
    [self setUniformMat4:modelViewMat4 loc:self.modelViewLoc];
    
}

- (void)setUniformMat4:(GLKMatrix4)mat4 loc:(GLint)loc {
    
    glUniformMatrix4fv(loc, 1, GL_FALSE, mat4.m);
    
}

#pragma mark - Transforms

- (GLKMatrix4)viewTransforms {
    
    GLKMatrix4 viewMat4 = GLKMatrix4Identity;
    
    viewMat4 = GLKMatrix4Translate(viewMat4, 0, 0, 0);
    
    return viewMat4;

}

- (GLKMatrix4)modelTransforms {
    
    GLKMatrix4 modelMat4 = GLKMatrix4Identity;
    
    modelMat4 = GLKMatrix4MakeTranslation(0, -0.5, -5);
    
    return modelMat4;
    
}

- (GLKMatrix4)projectionTransforms {
    
    GLKMatrix4 projectionMat4 = GLKMatrix4Identity;
    
    GLfloat scaleFix = self.bounds.size.width / self.bounds.size.height;
    projectionMat4 = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), scaleFix, 1, 150);
    
    return projectionMat4;
    
}


#pragma mark - Clear

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

- (void)setRenderBackgroundColor:(RGBAColor)color {
    
    glClearColor(color.red, color.green, color.blue, color.alpha);
    
}

- (void)clearRenderBuffer {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
}

#pragma mark - View Port

// Bottom Left
#define OpenGLES_OriginX     (0)
#define OpenGLES_OriginY     (0)

- (void)setRenderViewPortWithCGRect:(CGRect)rect {
    
    glViewport(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
}

#pragma mark - Attact Arrays

#define VertexAttributePosition     (0)
#define StrideCloser                (0)

- (void)attachCubeVertexArrays {
    
    glEnableVertexAttribArray(VertexAttributePosition);
    
    if (self.vertexMode == VertexDataMode_VBO) {
        
        glVertexAttribPointer(VertexAttributePosition,
                              PositionCoordinateCount,
                              GL_FLOAT,
                              GL_FALSE,
                              sizeof(VFVertex),
                              (const GLvoid *) offsetof(VFVertex, position));
        
    } else {
    
        glVertexAttribPointer(VertexAttributePosition,
                              PositionCoordinateCount,
                              GL_FLOAT,
                              GL_FALSE,
                              StrideCloser,
                              vertices);
        
    }

}

#pragma mark - Draw

#define PositionStartIndex          (0)
#define DrawIndicesCount            (3)

- (void)drawCube {
    
    glDrawElements(GL_TRIANGLE_FAN,
                   sizeof(indices) / sizeof(indices[0]),
                   GL_UNSIGNED_BYTE,
                   indices);
    
}

#pragma mark - Context

- (void)settingContext {
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:self.context];
    
}

- (void)bindDrawableObjectToRenderBuffer {
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
}

- (void)render {
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    
}

#pragma mark - Render Buffer 

#define RenderMemoryBlock    (1)

- (GLuint)createRenderBuffer {
    
    GLuint ID;
    
    glGenRenderbuffers(RenderMemoryBlock, &ID);
    glBindRenderbuffer(GL_RENDERBUFFER, ID);
    
    return ID;
    
}

- (CGSize)getRenderBufferSize {
    
    GLint renderbufferWidth, renderbufferHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    return CGSizeMake(renderbufferWidth, renderbufferHeight);
    
}

#pragma mark - Frame Buffer

#define FrameMemoryBlock    (1)

- (GLuint)createFrameBuffer {
    
    GLuint ID;
    
    glGenFramebuffers(FrameMemoryBlock, &ID);
    glBindFramebuffer(GL_FRAMEBUFFER, ID);
    
    return ID;
    
}

- (void)attachRenderBufferToFrameBufferWithRenderID:(GLuint)renderBufferID attachment:(GLenum)attachment {
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, attachment, GL_RENDERBUFFER, renderBufferID);
    
}

#pragma mark - Layout Views

- (void)prepareDisplay {
    
    // 1. Context
    [self settingContext];
    
    // 2. Render / Frame Buffer
    
    // 2.0 创建 Frame Buffer
    self.frameBufferID = [self createFrameBuffer];
    
    // 2.1 Color Render Buffer
    self.colorRenderBufferID = [self createRenderBuffer];
    
    // 必须要在 glbindRenderBuffer 之后 （就是使用 Render Buffer 之后）, 再绑定渲染的图层
    [self bindDrawableObjectToRenderBuffer];
    
    [self attachRenderBufferToFrameBufferWithRenderID:self.colorRenderBufferID
                                           attachment:GL_COLOR_ATTACHMENT0];
    
    // 2.? Depth Render Buffer
    self.renderBufferSize = [self getRenderBufferSize];
    
    // 2.3 要在 Render Context setCurrent 后, 再进行 OpenGL ES 的操作
    [self setRenderBackgroundColor:RGBAColorMake(0.4, 0.7, 0.9, 1.f)];
    
    // 2.4 Vertex Buffer Object
    if (self.vertexMode == VertexDataMode_VBO) {
        
        GLuint vertexBufferID = [self createVBO];
        [self bindVertexDatasWithVertexBufferID:vertexBufferID
                                   bufferTarget:GL_ARRAY_BUFFER
                                       dataSize:sizeof(vertices)
                                           data:vertices
                                       elements:NO];
        
        GLuint elementBufferID = [self createVBO];
        [self bindVertexDatasWithVertexBufferID:elementBufferID
                                   bufferTarget:GL_ELEMENT_ARRAY_BUFFER
                                       dataSize:sizeof(indices)
                                           data:indices
                                       elements:YES];
        
    }
    
    // 3. Shader
    GLuint vertexShaderID = [self createShaderWithType:GL_VERTEX_SHADER];
    [self compileVertexShaderWithShaderID:vertexShaderID type:GL_VERTEX_SHADER];
    
    GLuint fragmentShaderID = [self createShaderWithType:GL_FRAGMENT_SHADER];
    [self compileVertexShaderWithShaderID:fragmentShaderID type:GL_FRAGMENT_SHADER];
    
    self.programID = [self createShaderProgram];
    [self attachShaderToProgram:_programID
                  vertextShader:vertexShaderID
                 fragmentShader:fragmentShaderID];
    
    [self linkProgramWithProgramID:_programID];
    
    [self updateUniformsLocationsWithProgramID:_programID];
    
    // 4. Attach VAOs Or VBOs
    [self attachCubeVertexArrays];
    
}

- (void)drawAndRender {
    
    // 5. Draw Cube
    // 5.0 使用 Shader
    [self userShaderWithProgramID:_programID];
    
    // 5.1
    // 第一次变换，modelTransform [模型空间 --> 世界空间]
    // 第二次变换，viewTransform  [世界空间 --> 摄像机空间]
    GLKMatrix4 modelViewMat4 = GLKMatrix4Multiply([self modelTransforms], [self viewTransforms]);
    [self setModelViewMat4:modelViewMat4];
    //    NSLog(@"modelViewMat4 = %@", NSStringFromGLKMatrix4(modelViewMat4));
    
    // 5.2 第三次变换，projectionTransforms [摄像机空间 --> 裁剪空间]
    GLKMatrix4 projectionMat4 = [self projectionTransforms];
    [self setProjectionMat4:projectionMat4];
    //    NSLog(@"projectionMat4 = %@", NSStringFromGLKMatrix4(projectionMat4));
    
    // Test Start
//    GLKMatrix4 modelViewProjectionMat4 = GLKMatrix4Multiply(modelViewMat4, projectionMat4);
//    NSLog(@"modelViewProjectionMat4 = %@", NSStringFromGLKMatrix4(modelViewProjectionMat4));
//
//    for (NSUInteger i = 0; i < 4; i++) {
//
//        GLKVector4 positionV = GLKVector4Make(vertices[i].position[0], vertices[i].position[1], vertices[i].position[2], 1.0);
//        GLKVector4 position  = GLKMatrix4MultiplyVector4(modelViewProjectionMat4, positionV);
//        NSLog(@"position = %@", NSStringFromGLKVector4(position));
//
//    }
    // Test End
    
    // 5.3 Clear
    [self clearRenderBuffer];
    
    // 5.4 View Port
    // 第四次变换，viewportTransforms [裁剪空间 --> 屏幕空间]
    [self setRenderViewPortWithCGRect:CGRectMake(OpenGLES_OriginX,
                                                 OpenGLES_OriginY,
                                                 self.renderBufferSize.width,
                                                 self.renderBufferSize.height)];
    
    // 5.5 绘制图形
    [self drawCube];
    
    // 5.6 渲染图形
    [self render];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - Update

- (void)updateContentsWithSeconds:(NSTimeInterval)seconds {

    
    
}

#pragma mark - Dealloc

- (void)dealloc {
    
    // 释放资源
    
}

@end
