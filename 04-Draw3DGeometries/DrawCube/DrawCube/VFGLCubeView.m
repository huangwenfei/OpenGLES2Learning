//
//  VFGLCubeView.m
//  DrawCube_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFGLCubeView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import <GLKit/GLKit.h>

#import "VFRedisplay.h"

#define RubikCubeColor // 魔方色

static const NSUInteger kInvaildBufferID = 0;

typedef NS_ENUM(NSUInteger, VFDrawableDepthMode) {
        
    VFDrawableDepthMode_None = 0,
    VFDrawableDepthMode_16,
    VFDrawableDepthMode_24,
    
};

@interface VFGLCubeView ()<VFRedisplayDelegate>

@property (strong, nonatomic) VFRedisplay *displayUpdate;

@property (strong, nonatomic) EAGLContext *context;

@property (assign, nonatomic) GLuint frameBufferID;
@property (assign, nonatomic) GLuint colorRenderBufferID, depthRenderBufferID;
@property (assign, nonatomic) CGSize renderBufferSize;

@property (assign, nonatomic) VFDrawableDepthMode depthMode;

@property (assign, nonatomic) GLuint vboBufferID;

@property (assign, nonatomic) GLuint programID;

@property (assign, nonatomic) GLint projectionLoc, modelViewLoc;

/**
 *  Start
 */

@property (assign, nonatomic) GLKVector3 modelPosition, modelRotate, modelScale;
@property (assign, nonatomic) GLKVector3 viewPosition , viewRotate , viewScale ;
@property (assign, nonatomic) GLfloat projectionFov, projectionScaleFix, projectionNearZ, projectionFarZ;

/**
 *  End
 */

@end

@implementation VFGLCubeView

#pragma mark - Getter


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
    
    [self setDefault];
    
}

- (void)setDefault {
    
    self.depthMode  = VFDrawableDepthMode_None;
    
    self.projectionLoc = -1;
    self.modelViewLoc  = -1;
    
    self.modelPosition = GLKVector3Make(0, 0, 0);
    self.viewPosition  = self.modelPosition;
    
    self.modelRotate   = GLKVector3Make(0, 0, 0);
    self.viewRotate    = self.modelRotate;
    
    self.modelScale    = GLKVector3Make(1, 1, 1);
    self.viewScale     = self.modelScale;
    
    self.projectionFov = GLKMathDegreesToRadians(85.0);
    self.projectionScaleFix = 1;
    self.projectionNearZ = 0;
    self.projectionFarZ  = 1500;
    
}

#pragma mark - Vertex Datas

#define PositionCoordinateCount         (3)
#define ColorCoordinateCount            (4)

typedef struct {
    GLfloat position[PositionCoordinateCount];
    GLfloat color[ColorCoordinateCount];
} VFVertex;

//static const VFVertex vertices[] = {
//    {{-1.0f, -1.0f, 0.0}}, // lower left corner
//    {{ 1.0f, -1.0f, 0.0}}, // lower right corner
//    {{ 1.0f,  1.0f, 0.0}}, // upper left corner
//    {{-1.0f,  1.0f, 0.0}}, // upper left corner
//};
//
//static const GLubyte indices[] = {
//
//    0, 1, 2,
//    2, 3, 0,
//
//};

static const VFVertex vertices[] = {
    
#ifdef RubikCubeColor
    // Front
    // [UIColor colorWithRed:0.000 green:0.586 blue:1.000 alpha:1.000] // 湖蓝
    {{ 1.0, -1.0,  1.0}, {0.000, 0.586, 1.000, 1.000}}, // -- 0
    {{ 1.0,  1.0,  1.0}, {0.000, 0.586, 1.000, 1.000}}, // -- 1
    {{-1.0,  1.0,  1.0}, {0.000, 0.586, 1.000, 1.000}}, // -- 2
    {{-1.0, -1.0,  1.0}, {0.000, 0.586, 1.000, 1.000}}, // -- 3
    
    // Back
    // [UIColor colorWithRed:0.119 green:0.519 blue:0.142 alpha:1.000] // 暗绿
    {{-1.0, -1.0, -1.0}, {0.119, 0.519, 0.142, 1.000}}, // -- 4
    {{-1.0,  1.0, -1.0}, {0.119, 0.519, 0.142, 1.000}}, // -- 5
    {{ 1.0,  1.0, -1.0}, {0.119, 0.519, 0.142, 1.000}}, // -- 6
    {{ 1.0, -1.0, -1.0}, {0.119, 0.519, 0.142, 1.000}}, // -- 7
    
    // Left
    // [UIColor colorWithRed:1.000 green:0.652 blue:0.000 alpha:1.000] // 橙
    {{-1.0, -1.0,  1.0}, {1.000, 0.652, 0.000, 1.000}}, // -- 8
    {{-1.0,  1.0,  1.0}, {1.000, 0.652, 0.000, 1.000}}, // -- 9
    {{-1.0,  1.0, -1.0}, {1.000, 0.652, 0.000, 1.000}}, // -- 10
    {{-1.0, -1.0, -1.0}, {1.000, 0.652, 0.000, 1.000}}, // -- 11
    
    // Right
    // [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000] // 红色
    {{ 1.0, -1.0, -1.0}, {1.000, 0.000, 0.000, 1.000}}, // -- 12
    {{ 1.0,  1.0, -1.0}, {1.000, 0.000, 0.000, 1.000}}, // -- 13
    {{ 1.0,  1.0,  1.0}, {1.000, 0.000, 0.000, 1.000}}, // -- 14
    {{ 1.0, -1.0,  1.0}, {1.000, 0.000, 0.000, 1.000}}, // -- 15
    
    // Top
    // [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:1.000] // 黄色
    {{ 1.0,  1.0,  1.0}, {1.000, 1.000, 0.000, 1.000}}, // -- 16
    {{ 1.0,  1.0, -1.0}, {1.000, 1.000, 0.000, 1.000}}, // -- 17
    {{-1.0,  1.0, -1.0}, {1.000, 1.000, 0.000, 1.000}}, // -- 18
    {{-1.0,  1.0,  1.0}, {1.000, 1.000, 0.000, 1.000}}, // -- 19
    
    // Bottom
    // [UIColor colorWithWhite:1.000 alpha:1.000]                      // 白色
    {{ 1.0, -1.0, -1.0}, {1.000, 1.000, 1.000, 1.000}}, // -- 20
    {{ 1.0, -1.0,  1.0}, {1.000, 1.000, 1.000, 1.000}}, // -- 21
    {{-1.0, -1.0,  1.0}, {1.000, 1.000, 1.000, 1.000}}, // -- 22
    {{-1.0, -1.0, -1.0}, {1.000, 1.000, 1.000, 1.000}}, // -- 23
#else
    // Front
    // 0 [UIColor colorWithRed:0.438 green:0.786 blue:1.000 alpha:1.000]
    {{ 1.0, -1.0,  1.0}, {0.438, 0.786, 1.000, 1.000}}, // 淡（蓝） -- 0
    
    // 1 [UIColor colorWithRed:1.000 green:0.557 blue:0.246 alpha:1.000]
    {{ 1.0,  1.0,  1.0}, {1.000, 0.557, 0.246, 1.000}}, // 淡（橙） -- 1
    
    // 2 [UIColor colorWithRed:0.357 green:0.927 blue:0.690 alpha:1.000]
    {{-1.0,  1.0,  1.0}, {0.357, 0.927, 0.690, 1.000}}, // 蓝（绿） -- 2
    
    // 3 [UIColor colorWithRed:0.860 green:0.890 blue:0.897 alpha:1.000]
    {{-1.0, -1.0,  1.0}, {0.860, 0.890, 0.897, 1.000}}, // 超淡蓝 偏（白） -- 3
    
    // Back
    // 4 [UIColor colorWithRed:0.860 green:0.890 blue:0.897 alpha:1.000]
    {{-1.0, -1.0, -1.0}, {0.860, 0.890, 0.897, 1.000}}, // 超淡蓝 偏（白） -- 4
    
    // 5 [UIColor colorWithRed:0.357 green:0.927 blue:0.690 alpha:1.000]
    {{-1.0,  1.0, -1.0}, {0.357, 0.927, 0.690, 1.000}}, // 蓝（绿） -- 5
    
    // 6 [UIColor colorWithRed:1.000 green:0.557 blue:0.246 alpha:1.000]
    {{ 1.0,  1.0, -1.0}, {1.000, 0.557, 0.246, 1.000}}, // 淡（橙） -- 6
    
    // 7 [UIColor colorWithRed:0.438 green:0.786 blue:1.000 alpha:1.000]
    {{ 1.0, -1.0, -1.0}, {0.438, 0.786, 1.000, 1.000}}, // 淡（蓝） -- 7
#endif
};

static const GLubyte indices[] = {
    
#ifdef RubikCubeColor
    // Front
    0, 1, 2,
    2, 3, 0,
    // Right
    4, 5, 6,
    6, 7, 4,
    // Back
    8 , 9 , 10,
    10, 11, 8 ,
    // Left
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20,
#else
    // Front  ------------- 蓝橙绿白 中间线（蓝绿）
    0, 1, 2, // 蓝橙绿
    2, 3, 0, // 绿白蓝
    // Back   ------------- 蓝橙绿白 中间线（白橙）
    4, 5, 6, // 白绿橙
    6, 7, 4, // 橙蓝白
    // Left   ------------- 白绿
    3, 2, 5, // 白绿绿
    5, 4, 3, // 绿白白
    // Right  ------------- 蓝橙
    7, 6, 1, // 蓝橙橙
    1, 0, 7, // 橙蓝蓝
    // Top    ------------- 橙绿
    1, 6, 5, // 橙橙绿
    5, 2, 1, // 绿绿橙
    // Bottom ------------- 白蓝
    3, 4, 7, // 白白蓝
    7, 0, 3  // 蓝蓝白
#endif
};

#pragma mark - Vertex Buffer Object

#define VertexBufferMemoryBlock    (1)

- (GLuint)createVBO {
    
    GLuint vertexBufferID;
    glGenBuffers(VertexBufferMemoryBlock, &vertexBufferID);
    
    return vertexBufferID;
    
}

- (void)rebindVertexBuffer:(NSArray<NSNumber *> *)vbos {
    
    for (NSNumber *vboN in vbos) {
        GLuint vboID = (GLuint)[vboN integerValue];
        if (vboID != kInvaildBufferID) {
            glBindBuffer(GL_ARRAY_BUFFER, vboID);
        }
    }
    
}

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

- (void)deleteVBO:(NSArray<NSNumber *> *)vbos {
    
    for (NSNumber *vboIDN in vbos) {
        GLuint vboID = (GLuint)[vboIDN integerValue];
        if (vboID != kInvaildBufferID) {
            glDeleteBuffers(1, &vboID);
        }
    }
    
}

#pragma mark - Shader

#define VertexAttributePosition     (0)
#define VertexAttributeColor        (1)

+ (GLchar *)vertexShaderCode {
    return  "#version 100 \n"
            "uniform highp mat4 u_Projection; \n"
            "uniform highp mat4 u_ModelView; \n"
            "attribute vec4 a_Position; \n"
            "attribute vec4 a_Color; \n"
            "varying mediump vec4 v_Color; \n"
            "void main(void) { \n"
                "v_Color = a_Color; \n"
                "gl_Position = u_Projection * u_ModelView * a_Position;\n"
            "}";
}

+ (GLchar *)fragmentShaderCode {
    return  "#version 100 \n"
            "varying mediump vec4 v_Color; \n"
            "void main(void) { \n"
                "gl_FragColor = v_Color; \n"
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

- (void)bindPositionAttributeWithProgramID:(GLuint)programID {
    
    [self bindAttributesWithProgramID:programID location:VertexAttributePosition attributeName:"a_Position"];
    
}

- (void)bindColorAttributeWithProgramID:(GLuint)programID {

    [self bindAttributesWithProgramID:programID location:VertexAttributeColor attributeName:"v_Color"];
    
}

- (void)bindAttributesWithProgramID:(GLuint)programID location:(GLuint)location attributeName:(const GLchar *)name {
    
    glBindAttribLocation(programID, location, name);
    
}

- (void)linkProgramWithProgramID:(GLuint)programID {
    
    [self bindPositionAttributeWithProgramID:self.programID];
    [self bindColorAttributeWithProgramID:self.programID];
    
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
    
    viewMat4 = GLKMatrix4Translate(viewMat4, self.viewPosition.x, self.viewPosition.y, self.viewPosition.z);
    viewMat4 = GLKMatrix4Rotate(viewMat4, self.viewRotate.x, 1, 0, 0);
    viewMat4 = GLKMatrix4Rotate(viewMat4, self.viewRotate.y, 0, 1, 0);
    viewMat4 = GLKMatrix4Rotate(viewMat4, self.viewRotate.z, 0, 0, 1);
    viewMat4 = GLKMatrix4Scale(viewMat4, self.viewScale.x, self.viewScale.y, self.viewScale.z);
    
    return viewMat4;

}

- (GLKMatrix4)modelTransforms {
    
    GLKMatrix4 modelMat4 = GLKMatrix4Identity;
    
    modelMat4 = GLKMatrix4Translate(modelMat4, self.modelPosition.x, self.modelPosition.y, self.modelPosition.z);
    modelMat4 = GLKMatrix4Rotate(modelMat4, self.modelRotate.x, 1, 0, 0);
    modelMat4 = GLKMatrix4Rotate(modelMat4, self.modelRotate.y, 0, 1, 0);
    modelMat4 = GLKMatrix4Rotate(modelMat4, self.modelRotate.z, 0, 0, 1);
    modelMat4 = GLKMatrix4Scale(modelMat4, self.modelScale.x, self.modelScale.y, self.modelScale.z);
    
    return modelMat4;
    
}

- (GLKMatrix4)projectionTransforms {
    
    GLKMatrix4 projectionMat4 = GLKMatrix4Identity;
    
    self.projectionScaleFix = self.bounds.size.width / self.bounds.size.height;
    self.projectionNearZ    = 1;
    self.projectionFarZ     = 150;
    
    projectionMat4 = GLKMatrix4MakePerspective(self.projectionFov,
                                               _projectionScaleFix,
                                               _projectionNearZ,
                                               _projectionFarZ);
    
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

- (void)clearColorRenderBuffer:(BOOL)color depth:(BOOL)depth stencil:(BOOL)stencil {
    
    GLbitfield colorBit     = 0;
    GLbitfield depthBit     = 0;
    GLbitfield stencilBit   = 0;
    
    if (color)      { colorBit      = GL_COLOR_BUFFER_BIT;     }
    if (depth)      { depthBit      = GL_DEPTH_BUFFER_BIT;     }
    if (stencil)    { stencilBit    = GL_STENCIL_BUFFER_BIT;   }
    
    glClear(colorBit | depthBit | stencilBit);
    
}

#pragma mark - View Port

// Bottom Left
#define OpenGLES_OriginX     (0)
#define OpenGLES_OriginY     (0)

- (void)setRenderViewPortWithCGRect:(CGRect)rect {
    
    glViewport(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // 默认状态下，就是 [0, 1], 也是修改投影的
    // 如果已经做了 projectionTransform 可以不用改它
    glDepthRangef(0, 1);
    
}

#pragma mark - Attact Arrays

- (void)attachCubeVertexArrays {
    
    glEnableVertexAttribArray(VertexAttributePosition);
    glVertexAttribPointer(VertexAttributePosition,
                          PositionCoordinateCount,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(VFVertex),
                          (const GLvoid *) offsetof(VFVertex, position));
    
    glEnableVertexAttribArray(VertexAttributeColor);
    glVertexAttribPointer(VertexAttributeColor,
                          ColorCoordinateCount,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(VFVertex),
                          (const GLvoid *) offsetof(VFVertex, color));
    
}

#pragma mark - Draw

- (void)drawCube {
    
    // 失败的核心原因
    // 因为 depth buffer 是最后一个绑定的，所以当前渲染的 buffer 变成了 depth 而不是 color
    // 所以 渲染的图形没有任何变化，无法产生深度效果
    // Make the Color Render Buffer the current buffer for display
    [self rebindRenderBuffer:@[@(self.colorRenderBufferID)]];
    
    [self rebindVertexBuffer:@[@(self.vboBufferID)]];
    
    glDrawElements(GL_TRIANGLES,
                   sizeof(indices) / sizeof(indices[0]),
                   GL_UNSIGNED_BYTE,
                   indices);
    
}

#pragma mark - Context

- (void)setContext:(EAGLContext *)context {
    
    if (_context != context) {
     
        [EAGLContext setCurrentContext:_context];
        
        [self deleteFrameBuffer:@[@(self.frameBufferID)]];
        self.frameBufferID = kInvaildBufferID;
        
        [self deleteRenderBuffer:@[@(self.colorRenderBufferID), @(self.depthRenderBufferID)]];
        self.colorRenderBufferID = self.depthRenderBufferID = kInvaildBufferID;
        
        _context = context;
        
        if (context != nil) {
            
            _context = context;
            [EAGLContext setCurrentContext:_context];
            
            // 2. Render / Frame Buffer
            
            // 2.0 创建 Frame Buffer
            [self deleteFrameBuffer:@[@(self.frameBufferID)]];
            
            self.frameBufferID = [self createFrameBuffer];
            
            // 2.1 Color & Depth Render Buffer
            [self deleteRenderBuffer:@[@(self.colorRenderBufferID)]];
            
            self.colorRenderBufferID = [self createRenderBuffer];
            
            [self renderBufferStrogeWithRenderID:self.colorRenderBufferID];
            
            [self attachRenderBufferToFrameBufferWithRenderBufferID:self.colorRenderBufferID
                                                         attachment:GL_COLOR_ATTACHMENT0];
            
            // 2.2 检查 Frame 装载 Render Buffer 的问题
            [self checkFrameBufferStatus];
            
            // 2.3 Add Depth Render Buffer
            [self enableDepthRenderBuffer];
            
            [self deleteRenderBuffer:@[@(self.depthRenderBufferID)]];
            
            if ( ! CGSizeEqualToSize(self.renderBufferSize, CGSizeZero) &&
                self.depthMode != VFDrawableDepthMode_None) {
                
                self.depthRenderBufferID = [self createRenderBuffer];
                
                if (self.depthRenderBufferID == kInvaildBufferID) {
                    return;
                }
                
                [self renderBufferStrogeWithRenderID:self.depthRenderBufferID];
                
                [self attachRenderBufferToFrameBufferWithRenderBufferID:self.depthRenderBufferID
                                                             attachment:GL_DEPTH_ATTACHMENT];
                
            }
            
            // 2.4 检查 Frame 装载 Render Buffer 的问题
            [self checkFrameBufferStatus];
            
        }
        
    }
    
}

- (void)settingContext {

    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
}

- (void)bindDrawableObjectToRenderBuffer {
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
}

- (void)render {
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (void)resetContext {
    
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
    
}

#pragma mark - Render Buffer 

#define RenderMemoryBlock    (1)

- (GLuint)createRenderBuffer {
    
    GLuint ID = kInvaildBufferID;
    glGenRenderbuffers(RenderMemoryBlock, &ID);
    glBindRenderbuffer(GL_RENDERBUFFER, ID);
    
    return ID;
    
}

- (void)enableDepthRenderBuffer {
    
    self.depthMode = VFDrawableDepthMode_16;
    
}

- (void)renderBufferStrogeWithRenderID:(GLuint)renderBufferID {
    
    if (renderBufferID == self.colorRenderBufferID) {
        
        // 必须要在 glbindRenderBuffer 之后 （就是使用 Render Buffer 之后）, 再绑定渲染的图层
        [self bindDrawableObjectToRenderBuffer];
        
        self.renderBufferSize = [self getRenderBufferSize];
        
    }
    
    if (renderBufferID == self.depthRenderBufferID) {
        
        glRenderbufferStorage(GL_RENDERBUFFER,
                              GL_DEPTH_COMPONENT16,
                              self.renderBufferSize.width,
                              self.renderBufferSize.height);
        
    }
    
}

- (CGSize)getRenderBufferSize {
    
    GLint renderbufferWidth, renderbufferHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
//    GLint size;
//    glGetIntegerv(GL_MAX_RENDERBUFFER_SIZE, &size);
//    NSLog(@"size %@", @(size));
//    NSLog(@"width %@, height %@", @(renderbufferWidth), @(renderbufferHeight));
    
    return CGSizeMake(renderbufferWidth, renderbufferHeight);
    
}

- (void)rebindRenderBuffer:(NSArray<NSNumber *> *)rbos {
    
    for (NSNumber *rboN in rbos) {
        GLuint rboID = (GLuint)[rboN integerValue];
        if (rboID != kInvaildBufferID && glIsRenderbuffer(rboID)) {
            glBindRenderbuffer(GL_RENDERBUFFER, rboID);
        }
    }
    
}

- (void)deleteRenderBuffer:(NSArray<NSNumber *> *)rbos {
    
    for (NSNumber *rboN in rbos) {
        GLuint rboID = (GLuint)[rboN integerValue];
        if (rboID != kInvaildBufferID && glIsRenderbuffer(rboID)) {
            glDeleteRenderbuffers(RenderMemoryBlock, &rboID);
        }
    }
    
}

- (void)enableDepthTesting {
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
}

#pragma mark - Frame Buffer

#define FrameMemoryBlock    (1)

- (GLuint)createFrameBuffer {
    
    GLuint ID = kInvaildBufferID;
    glGenFramebuffers(FrameMemoryBlock, &ID);
    glBindFramebuffer(GL_FRAMEBUFFER, ID);
    
    return ID;
    
}

- (void)attachRenderBufferToFrameBufferWithRenderBufferID:(GLuint)renderBufferID attachment:(GLenum)attachment {

    glFramebufferRenderbuffer(GL_FRAMEBUFFER, attachment, GL_RENDERBUFFER, renderBufferID);
    
    GLint resultsName[3] = {0};
    GLint resultsType[3] = {0};
    glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, attachment, GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME, resultsName);
    glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, attachment, GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE, resultsType);
    
//    for (NSUInteger i = 0; i < 3; i++) {
//        
//        NSLog(@"attachment resultsName = %d", resultsName[i]);
//        NSLog(@"attachment resultsType = %x", resultsType[i]);
//        
//    }
//    
//    NSLog(@"===========");
    
}

- (void)rebindFrameBuffer:(NSArray<NSNumber *> *)fbos {
    
    for (NSNumber *fboN in fbos) {
        GLuint fboID = (GLuint)[fboN integerValue];
        if (fboID != kInvaildBufferID && glIsFramebuffer(fboID)) {
            glBindFramebuffer(GL_FRAMEBUFFER, fboID);
        }
    }
    
}

- (void)deleteFrameBuffer:(NSArray<NSNumber *> *)fbos {
    
    for (NSNumber *fboN in fbos) {
        GLuint fboID = (GLuint)[fboN integerValue];
        if (fboID != kInvaildBufferID && glIsFramebuffer(fboID)) {
            glDeleteFramebuffers(FrameMemoryBlock, &fboID);
        }
    }
    
}

- (void)checkFrameBufferStatus {
    
    // Check for any errors configuring the render buffer
    GLenum statusFrame = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    
//    NSLog(@"statusFrame %x", statusFrame);

    if(statusFrame != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x", statusFrame);
    }
    
}

#pragma mark - Layout Views

- (void)prepareDisplay {
    
    // 1. Context
    [self settingContext];
    
    // 2 要在 Render Context setCurrent 后, 再进行 OpenGL ES 的操作
    // [UIColor colorWithRed:0.423 green:0.046 blue:0.875 alpha:1.000]
    // [UIColor colorWithRed:0.423 green:0.431 blue:0.875 alpha:1.000]
    [self setRenderBackgroundColor:RGBAColorMake(0.423, 0.431, 0.875, 1.000)];
    
    // 2.? Vertex Buffer Object
    self.vboBufferID = [self createVBO];
    [self bindVertexDatasWithVertexBufferID:_vboBufferID
                               bufferTarget:GL_ARRAY_BUFFER
                                   dataSize:sizeof(vertices)
                                       data:vertices
                                   elements:NO];
    
    [self bindVertexDatasWithVertexBufferID:kInvaildBufferID
                               bufferTarget:GL_ELEMENT_ARRAY_BUFFER
                                   dataSize:sizeof(indices)
                                       data:indices
                                   elements:YES];
    
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
    
    // 4. Attach VBOs
    [self attachCubeVertexArrays];
    
}

// 5. Draw & Rander
- (void)drawAndRender {
    
    // 5. Draw Cube
    // 5.0 使用 Shader
    [self userShaderWithProgramID:_programID];
    
    // 5.1 应用 3D 变换
    self.modelPosition = GLKVector3Make(0, -0.5, -5);
    [self transforms];
    
    // 5.2 清除旧渲染缓存
    [self clearColorRenderBuffer:YES depth:YES stencil:NO];
    
    // 5.3 开启深度测试
    [self enableDepthTesting];
    
    // 5.4 绘制图形
    [self drawCube];
    
    // 5.5 渲染图形
    [self render];
    
}

- (void)transforms {
    
    // 第一次变换，modelTransform [模型空间 --> 世界空间]
    GLKMatrix4 modelMat4 = [self modelTransforms];
    
    // 第二次变换，viewTransform  [世界空间 --> 摄像机空间]
    GLKMatrix4 viewMat4 = [self viewTransforms];
    
    GLKMatrix4 modelViewMat4 = GLKMatrix4Multiply(modelMat4, viewMat4);
    [self setModelViewMat4:modelViewMat4];
    //    NSLog(@"modelViewMat4 = %@", NSStringFromGLKMatrix4(modelViewMat4));
    
    // 第三次变换，projectionTransforms [摄像机空间 --> 裁剪空间]
    GLKMatrix4 projectionMat4 = [self projectionTransforms];
    
    [self setProjectionMat4:projectionMat4];
    //    NSLog(@"projectionMat4 = %@", NSStringFromGLKMatrix4(projectionMat4));
    
    // Test Start
//    NSLog(@"----------Start----------");
//    
//    GLKMatrix4 modelViewProjectionMat4 = GLKMatrix4Multiply(modelViewMat4, projectionMat4);
//    //    NSLog(@"modelViewProjectionMat4 = %@", NSStringFromGLKMatrix4(modelViewProjectionMat4));
//    
//    for (NSUInteger i = 0; i < 4; i++) {
//        
//        GLKVector4 positionV = GLKVector4Make(vertices[i].position[0], vertices[i].position[1], vertices[i].position[2], 1.0);
//        GLKVector4 position  = GLKMatrix4MultiplyVector4(modelViewProjectionMat4, positionV);
//        NSLog(@"position = %@", NSStringFromGLKVector4(position));
//        
//    }
//    NSLog(@"----------End----------");
    // Test End
    
    // View Port
    // 第四次变换，viewportTransforms [裁剪空间 --> 屏幕空间]
    [self setRenderViewPortWithCGRect:CGRectMake(OpenGLES_OriginX,
                                                 OpenGLES_OriginY,
                                                 self.renderBufferSize.width,
                                                 self.renderBufferSize.height)];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - DisplayLink Update

- (void)preferTransformsWithTimes:(NSTimeInterval)time {
    
    GLfloat rotateX = self.modelRotate.x;
//    rotateX += M_PI_4 * time;
    
    GLfloat rotateY = self.modelRotate.y;
    rotateY += M_PI_2 * time;
    
    GLfloat rotateZ = self.modelRotate.z;
    rotateZ += M_PI * time;
    
    self.modelRotate = GLKVector3Make(rotateX, rotateY, rotateZ);
    
}

// <VFRedisplayDelegate>
- (void)updateContentsWithTimes:(NSTimeInterval)times {
    
    [self preferTransformsWithTimes:times];
    [self drawAndRender];
    
}

#pragma mark - Update

- (void)update {
    
    self.displayUpdate = [[VFRedisplay alloc] init];
    self.displayUpdate.delegate = self;
    self.displayUpdate.preferredFramesPerSecond = 25;
    self.displayUpdate.updateContentTimes = arc4random_uniform(650) / 10000.0;
    [self.displayUpdate startUpdate];
    
}

- (void)pauseUpdate {
    
    [self.displayUpdate pauseUpdate];
    
}

#pragma mark - Dealloc

- (void)dealloc {
    
    [self.displayUpdate endUpdate];

    [self resetContext];
    
    // 释放资源
    // 8、Delete Objects
    [self deleteFrameBuffer:@[@(self.frameBufferID)]];
    [self deleteRenderBuffer:@[@(self.colorRenderBufferID), @(self.depthRenderBufferID)]];
    
    [self deleteVBO:@[@(self.vboBufferID)]];
    
}

@end
