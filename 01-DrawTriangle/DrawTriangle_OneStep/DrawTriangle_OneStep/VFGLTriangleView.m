//
//  VFGLTriangleView.m
//  DrawTriangle_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFGLTriangleView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@interface VFGLTriangleView ()
@property (assign, nonatomic) VertexDataMode vertexMode;
@property (strong, nonatomic) EAGLContext *context;
@end

@implementation VFGLTriangleView

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
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}, // upper left corner
};

- (void)bindVertexDatasWithVertexBufferID:(GLuint)vertexBufferID {
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    // 创建 资源 ( context )
    glBufferData(GL_ARRAY_BUFFER,   // 缓存块 类型
                 sizeof(vertices),  // 创建的 缓存块 尺寸
                 vertices,          // 要绑定的顶点数据
                 GL_STATIC_DRAW);   // 缓存块 用途
    
}

#pragma mark - Shader

+ (GLchar *)vertexShaderCode {
    return  "#version 100 \n"
            "attribute vec4 v_Position; \n"
            "void main(void) { \n"
                "gl_Position = v_Position;\n"
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

- (void)attachTriangleVertexArrays {
    
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

- (void)drawTriangle {
    
    glDrawArrays(GL_TRIANGLES,
                 PositionStartIndex,
                 DrawIndicesCount);
    
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

- (CGSize)renderBufferSize {
    
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

- (void)attachRenderBufferToFrameBufferWithRenderID:(GLuint)renderBufferID {
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBufferID);
    
}

#pragma mark - Layout Views

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1. Context
    [self settingContext];
    
    // 2. Render / Frame Buffer
    GLuint renderBufferID = [self createRenderBuffer];
    [self createFrameBuffer];
    
    [self attachRenderBufferToFrameBufferWithRenderID:renderBufferID];
    
    // 必须要在 glbindRenderBuffer 之后 （就是使用 Render Buffer 之后）, 再绑定渲染的图层
    [self bindDrawableObjectToRenderBuffer];
    
    // 要在 Render Context setCurrent 后, 再进行 OpenGL ES 的操作
    [self setRenderBackgroundColor:RGBAColorMake(0.4, 0.7, 0.9, 1.f)];
    
    // 2.? Vertex Buffer Object
    if (self.vertexMode == VertexDataMode_VBO) {
        GLuint vertexBufferID = [self createVBO];
        [self bindVertexDatasWithVertexBufferID:vertexBufferID];
    }
    
    // 3. Shader
    GLuint vertexShaderID = [self createShaderWithType:GL_VERTEX_SHADER];
    [self compileVertexShaderWithShaderID:vertexShaderID type:GL_VERTEX_SHADER];
    
    GLuint fragmentShaderID = [self createShaderWithType:GL_FRAGMENT_SHADER];
    [self compileVertexShaderWithShaderID:fragmentShaderID type:GL_FRAGMENT_SHADER];
    
    GLuint programID = [self createShaderProgram];
    [self attachShaderToProgram:programID
                  vertextShader:vertexShaderID
                 fragmentShader:fragmentShaderID];
    
    [self linkProgramWithProgramID:programID];
    
    // 4. Clear
    [self clearRenderBuffer];
    
    // 5. View Port
    [self setRenderViewPortWithCGRect:CGRectMake(OpenGLES_OriginX,
                                                 OpenGLES_OriginY,
                                                 self.renderBufferSize.width,
                                                 self.renderBufferSize.height)];
    
    // 6. Attach VAOs Or VBOs
    [self attachTriangleVertexArrays];
    
    // 7. Draw Triangle
    [self userShaderWithProgramID:programID];
    
    [self drawTriangle];
    
    [self render];
    
}

#pragma mark - Dealloc

- (void)dealloc {
    
    // 释放资源
    
}

@end
