//
//  VFTextureDrawView.m
//  Texture-Part1-OneStep
//
//  Created by windy on 17/1/6.
//  Copyright © 2017年 windy. All rights reserved.
//

#import "VFDrawCubeView.h"

#import <OpenGLES/gltypes.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "VFRedisplay.h"

//#define Square                    // 默认状态
#define Cube                        // 绘制 Square 或 Cube 的开关

@import QuartzCore;
@import GLKit;

@interface VFDrawCubeView ()<VFRedisplayDelegate>
@property (strong, nonatomic) EAGLContext *glContext;
@property (strong, nonatomic) VFRedisplay *dispalayContents;

#ifdef Cube

@property (assign, nonatomic) GLKVector3 modelPosition, modelRotate, modelScale;
@property (assign, nonatomic) GLKVector3 viewPosition , viewRotate , viewScale ;
@property (assign, nonatomic) GLfloat projectionFov, projectionScaleFix, projectionNearZ, projectionFarZ;

#endif

@end

@implementation VFDrawCubeView

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
    
    // Step 2
    glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking : @(YES), // retained unchange
                                   kEAGLDrawablePropertyColorFormat     : kEAGLColorFormatRGBA8 // 32-bits Color
                                   };
    
    glLayer.contentsScale = [UIScreen mainScreen].scale;
    glLayer.opaque = YES;
    
    // Transforms Setting Default
#ifdef Cube
    [self setTransformInfoDefault];
#endif
    
}

#pragma mark - Datas

typedef struct {
    GLfloat position[3];
    GLfloat color[4];
} VFVertex;

#ifdef Cube

static const VFVertex vertices[] = {

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
    
};

static const GLubyte indices[] = {
    
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
    7, 0, 3, // 蓝蓝白
    
};

#else

// Square
static const VFVertex verDatas[] = {
    
    {{-1.0, -1.0, 0.0}, {1, 1, 1, 1}},
    {{ 1.0, -1.0, 0.0}, {1, 0, 1, 1}},
    {{ 1.0,  1.0, 0.0}, {0, 1, 1, 1}},
    {{-1.0,  1.0, 0.0}, {1, 1, 0, 1}},
    
};

static const GLubyte indDatas[] = {
    
    0, 1, 2,
    2, 3, 0,
    
};

#endif

#pragma mark - Transform

#ifdef Cube

#pragma mark - Transforms

- (void)setTransformInfoDefault {
    
    self.modelPosition = GLKVector3Make(0, 0, 0);
    self.viewPosition  = self.modelPosition;
    
    self.modelRotate   = GLKVector3Make(0, 0, 0);
    self.viewRotate    = self.modelRotate;
    
    self.modelScale    = GLKVector3Make(1, 1, 1);
    self.viewScale     = self.modelScale;
    
    self.projectionFov      = GLKMathDegreesToRadians(85.0);
    self.projectionScaleFix = 1;
    self.projectionNearZ    = 0;
    self.projectionFarZ     = 1500;
    
}

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

#else

- (GLKMatrix4)projectionTransforms {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float scaleFix = screenSize.width / screenSize.height;
    
    return GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0f), scaleFix, 1, 150);
    
}

- (GLKMatrix4)modelTransforms {
    
    return GLKMatrix4MakeTranslation(0, 0, -3);
    
}

- (GLKMatrix4)viewTransforms {
    
    return GLKMatrix4MakeTranslation(0, 0, 0);
    
}

#endif

#pragma mark - Shader

/**
 *  加载着色器代码
 *
 *  @param fileName   着色器代码文件
 *  @param shaderType 着色器类型
 *
 *  @return 着色器标识
 */
- (GLuint)loadShaderCodeWithFileName:(NSString *)fileName shaderType:(GLenum)shaderType {
    
    // 加载 String 数据
    NSString *stringFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError *error;
    NSString *strings = [NSString stringWithContentsOfFile:stringFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error: Load Fail, %@", error.localizedDescription);
        return 0;
    }
    
    const GLchar * stringDatas = [strings UTF8String];
    GLint stringLength = (GLint)strings.length;
    
    // 创建 Shader
    GLuint shaderID = glCreateShader(shaderType);
    
    // 加载 Shader 数据
    glShaderSource(shaderID, 1, &stringDatas, &stringLength);
    
    return shaderID;
    
}

/**
 *  编译着色器
 *
 *  @param shaderID 着色器标识
 *
 *  @return 编译成功与否
 */
- (BOOL)compilingShaderWithShaderIdentifier:(GLuint)shaderID {
    
    // 编译 Shader
    glCompileShader(shaderID);
    
    // 获取 编译信息
    GLint compileSuccess;
    glGetShaderiv(shaderID, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLint infoLength;
        glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *messages = malloc(sizeof(GLchar *) * infoLength);
            glGetShaderInfoLog(shaderID, infoLength, NULL, messages);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Error: Compiled Fail %@ !", messageString);
            free(messages);
        }
        return 0;// Failure = NO;
    }
    
    return 1;
    
}

/**
 *  链接所有的着色器
 *
 *  @param programID 着色器程序标识
 *
 *  @return 链接成功与否
 */
- (BOOL)linkShaderWithProgramID:(GLuint)programID {
    
    // 链接 Shader 到 Program
    glLinkProgram(programID);
    
    // 获取 Link 信息
    GLint linkSuccess;
    glGetProgramiv(programID, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLint infoLength;
        glGetProgramiv(programID, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *messages = malloc(sizeof(GLchar *) * infoLength);
            glGetProgramInfoLog(programID, infoLength, NULL, messages);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Error: Link Fail %@ !", messageString);
            free(messages);
        }
        return 0;
    }
    
    return 1;
}

#pragma mark - Texture Load Image

- (size_t)aspectSizeWithDataDimension:(size_t)dimension {
    
    size_t failure = 0;
    
    if (dimension <= 0 || (dimension % 2) != 0) {
        return failure;
    }
    
    GLint _2dTextureSize;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &_2dTextureSize);
    
    GLint cubeMapTextureSize;
    glGetIntegerv(GL_MAX_CUBE_MAP_TEXTURE_SIZE, &cubeMapTextureSize);
    
    //    NSLog(@"2D Max Texture Size = %@", @(_2dTextureSize));
    //    NSLog(@"CubeMap Max Texture Size = %@", @(cubeMapTextureSize));
    
    if (dimension > _2dTextureSize) {
        return failure;
    }
    
    if (dimension == _2dTextureSize) {
        return _2dTextureSize;
    }
    
    // [pow(2, 0), _2dTextureSize]
    GLint min = 1;// pow(2, 0)
    
    // _2dTextureSize === cubeMapTextureSize
    size_t aspectSize = min;
    
    GLuint index = 1;
    while (_2dTextureSize / pow(2, index) != min) {
        
        if (dimension > (_2dTextureSize / pow(2, index))) {
            
            aspectSize = (_2dTextureSize / pow(2, index - 1));
            
            break;
            
        }
        
        index++;
        
    }
    
    return aspectSize;
    
}

#define kBitsPerComponent   8

#define kBytesPerPixels     4
#define kBytesPerRow(width)         ((width) * kBytesPerPixels)

- (NSData *)textureDataWithResizedCGImageBytes:(CGImageRef)cgImage
                                      widthPtr:(size_t *)widthPtr
                                     heightPtr:(size_t *)heightPtr {
    
    if (cgImage == nil) {
        NSLog(@"Error: CGImage 不能是 nil ! ");
        return [NSData data];
    }
    
    if (widthPtr == NULL || heightPtr == NULL) {
        NSLog(@"Error: 宽度或高度不能为空。");
        return [NSData data];
    }
    
    size_t originalWidth  = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetHeight(cgImage);
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    size_t width  = [self aspectSizeWithDataDimension:originalWidth];
    size_t height = [self aspectSizeWithDataDimension:originalHeight];
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData *imageData =
    [NSMutableData dataWithLength:height * width * kBytesPerPixels]; // 4 bytes per RGBA pixel
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   width, height,
                                                   kBitsPerComponent,
                                                   kBytesPerRow(width),
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgContext);
    
    *widthPtr  = width;
    *heightPtr = height;
    
    return imageData;
}

- (void)textureDataWithResizedCGImageBytes:(CGImageRef)cgImage
                                completion:(void (^)(NSData *imageData, size_t newWidth, size_t newHeight))completionBlock {
    
    if (cgImage == nil) {
        NSLog(@"Error: CGImage 不能是 nil ! ");
        return;
    }
    
    size_t originalWidth  = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetHeight(cgImage);
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    size_t width  = [self aspectSizeWithDataDimension:originalWidth];
    size_t height = [self aspectSizeWithDataDimension:originalHeight];
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData *imageData =
    [NSMutableData dataWithLength:height * width * kBytesPerPixels]; // 4 bytes per RGBA pixel
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   width, height,
                                                   kBitsPerComponent,
                                                   kBytesPerRow(width),
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgContext);
    
    if (completionBlock) {
        completionBlock(imageData, width, height);
    }
    
}

- (void)textureDatasWithResizedUIImages:(NSArray<UIImage *> *)uiImages
                             completion:(void (^)(NSArray<NSData *> *imageDatas, size_t newWidth, size_t newHeight))completionBlock {
    
    if (uiImages == nil) {
        NSLog(@"Error: UIImage s 不能是 nil ! ");
        return;
    }
    
    // 假设所有的图片宽度、高度是一样的
    size_t originalWidth  = CGImageGetWidth(uiImages.firstObject.CGImage);
    size_t originalHeight = CGImageGetHeight(uiImages.firstObject.CGImage);
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    size_t width  = [self aspectSizeWithDataDimension:originalWidth];
    size_t height = [self aspectSizeWithDataDimension:originalHeight];
    
    size_t drawWidth  = width;
    size_t drawHeight = height * uiImages.count;
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData *imageData =
    [NSMutableData dataWithLength:drawHeight * drawWidth * kBytesPerPixels]; // 4 bytes per RGBA pixel
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   drawWidth, drawHeight,
                                                   kBitsPerComponent,
                                                   kBytesPerRow(drawWidth),
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, drawHeight);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    
    size_t offsetX = 0, offsetY = 0;
    for (UIImage *img in uiImages) {
        
        CGContextDrawImage(cgContext, CGRectMake(offsetX, offsetY, width, height), img.CGImage);
        offsetY += height;
        
    }
    
    CGContextRelease(cgContext);
    
    NSMutableArray *datas = [NSMutableArray array];
    NSUInteger loc = 0;
    NSUInteger len = width * height * kBytesPerPixels;
    for (NSUInteger i = 0; i < uiImages.count; i++) {
        
        NSRange range = NSMakeRange(loc + (i * len), len);
        NSData *subData = [imageData subdataWithRange:range];
        [datas addObject:subData];
    }
    
    if (completionBlock) {
        completionBlock(datas, width, height);
    }
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    // Step 1
    CAEAGLLayer *glLayer = (CAEAGLLayer *)self.layer;
    if ( ! [glLayer isKindOfClass:[CAEAGLLayer class]] ) {
        NSLog(@"Error : 错误的 Layer !");
        return;
    }
    
    // Step 2
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.glContext];
    
    // Step 3
    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
    
    // Render Buffer Size
    GLint width, height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
#ifdef Cube
    // Depth RenderBuffer Step 1
    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
#endif
    
    // Step 4
    NSString *vertexShaderName      = @"VertexShader.glsl";
    NSString *fragmentShaderName    = @"FragmentShader.glsl";
    
    GLuint vertexShader = [self loadShaderCodeWithFileName:vertexShaderName shaderType:GL_VERTEX_SHADER];
    BOOL isCompiledVertexShaderSuccessFul = [self compilingShaderWithShaderIdentifier:vertexShader];
    if ( ! isCompiledVertexShaderSuccessFul ) {
        NSLog(@"Error : Vertex Shader Compiled Fail !");
        return;
    }
    
    GLuint fragmentShader = [self loadShaderCodeWithFileName:fragmentShaderName shaderType:GL_FRAGMENT_SHADER];
    BOOL isCompiledFragmentShaderSuccessFul = [self compilingShaderWithShaderIdentifier:fragmentShader];
    if ( ! isCompiledFragmentShaderSuccessFul ) {
        NSLog(@"Error : Fragment Shader Compiled Fail !");
        return;
    }
    
    // Step 4.1
    GLuint program = glCreateProgram();
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // Step 4.2
    const GLuint positionAttributeIndex = 0;
    const GLuint colorAttributeIndex    = 1;
    
    const GLchar *positionAttributeName = "a_Position";
    const GLchar *colorAttributeName    = "a_Color";
    
    glBindAttribLocation(program, positionAttributeIndex, positionAttributeName);
    glBindAttribLocation(program, colorAttributeIndex, colorAttributeName);
    
    //  Step 4.3
    BOOL isSuccessFul = [self linkShaderWithProgramID:program];
    if ( ! isSuccessFul ) {
        NSLog(@"Error : Shade Link Fail !");
        return;
    }
    
    // Transform Step 1
    GLuint projectionLocation = glGetUniformLocation(program, "u_ProjectionMat4");
    GLuint modelViewLocation  = glGetUniformLocation(program, "u_ModelViewMat4");
    
    // Step 5
    GLuint vboBuffer;
    glGenBuffers(1, &vboBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vboBuffer);
    
#ifdef Cube
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
#else
    glBufferData(GL_ARRAY_BUFFER, sizeof(verDatas), verDatas, GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indDatas), indDatas, GL_STATIC_DRAW);
#endif
    
    // Step 6
    const GLuint positionAttributeComCount      = 3;
    const GLuint colorAttributeComCount         = 4;
    
    glEnableVertexAttribArray(positionAttributeIndex);
    glVertexAttribPointer(positionAttributeIndex,
                          positionAttributeComCount,
                          GL_FLOAT, GL_FALSE,
                          sizeof(VFVertex),
                          (const GLvoid *) offsetof(VFVertex, position));
    
    glEnableVertexAttribArray(colorAttributeIndex);
    glVertexAttribPointer(colorAttributeIndex,
                          colorAttributeComCount,
                          GL_FLOAT, GL_FALSE,
                          sizeof(VFVertex),
                          (const GLvoid *) offsetof(VFVertex, color));

    // Step 7
    glUseProgram(program);
    
    // Transform Step 2
    GLKMatrix4 projectionMat4 = [self projectionTransforms];
    glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, projectionMat4.m);
    
#ifdef Cube
    self.modelPosition = GLKVector3Make(0, 0, -5);
#endif
    GLKMatrix4 modelMat4 = [self modelTransforms];
    GLKMatrix4 viewMat4  = [self viewTransforms];
    GLKMatrix4 modelViewMat4 = GLKMatrix4Multiply(modelMat4, viewMat4);
    glUniformMatrix4fv(modelViewLocation, 1, GL_FALSE, modelViewMat4.m);
    
#ifdef Cube
    // Depth RenderBuffer Step 2
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
#endif
    
    // Step 8
    glClearColor(0.8, 0.9, 0.3, 1);
    
#ifdef Cube
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
#else
    glClear(GL_COLOR_BUFFER_BIT);
#endif
    
    // Step 9
    glViewport(0, 0, width, height);
    
#ifdef Cube
    // Depth RenderBuffer Step 3
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
#endif
    
    // Step 10
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
#ifdef Cube
    glDrawElements(GL_TRIANGLES,
                   sizeof(indices) / sizeof(indices[0]),
                   GL_UNSIGNED_BYTE,
                   indices); // CPU 内存地址
#else
    glDrawElements(GL_TRIANGLES,
                   sizeof(indDatas) / sizeof(indDatas[0]),
                   GL_UNSIGNED_BYTE,
                   indDatas); // CPU 内存地址
#endif
    
    // Step 11
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
    
    // Step 12
    glDisableVertexAttribArray(positionAttributeIndex);
    glDisableVertexAttribArray(colorAttributeIndex);
    
    glDeleteBuffers(1, &vboBuffer);
    
    glDeleteRenderbuffers(1, &colorRenderBuffer);
    glDeleteFramebuffers(1, &frameBuffer);
#ifdef Cube
    glDeleteRenderbuffers(1, &depthRenderBuffer);
#endif
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    glDeleteProgram(program);
    
    self.glContext = nil;
    [EAGLContext setCurrentContext:self.glContext];
    
}

#pragma mark - Update

// Redisplay Contents Step 1
- (void)update {

    self.dispalayContents = [[VFRedisplay alloc] initWithUpdateTimes:arc4random_uniform(800) / 10000.0
                                            preferredFramesPerSecond:25];
    self.dispalayContents.delegate = self;
    
    [self.dispalayContents startUpdate];
    
}

- (void)pauseUpdate {
    
    [self.dispalayContents pauseUpdate];
    
}

#pragma mark - <VFRedisplayDelegate>

- (void)preferTransformsWithTimes:(NSTimeInterval)time {
    
#ifdef Cube
    GLfloat rotateX = self.modelRotate.x;
    //    rotateX += M_PI_4 * time;
    
    GLfloat rotateY = self.modelRotate.y;
    rotateY += M_PI_2 * time;
    
    GLfloat rotateZ = self.modelRotate.z;
    rotateZ += M_PI * time;
    
    self.modelRotate = GLKVector3Make(rotateX, rotateY, rotateZ);
#endif

}

// Redisplay Contents Step 2
- (void)updateContentsWithTimes:(NSTimeInterval)times {
    
    [self preferTransformsWithTimes:times];
    [self layoutSubviews];
    
}

#pragma mark - Dealloc

// Redisplay Contents Step 3
- (void)dealloc {
    
    [self.dispalayContents endUpdate];

}

@end




