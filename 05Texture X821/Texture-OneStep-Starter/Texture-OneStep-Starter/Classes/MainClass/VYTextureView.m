//
//  VYTextureView.m
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/13.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "VYTextureView.h"

#import "TextureDatas.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#pragma mark - VYSwitchKey [Inner Class]

@interface VYSwitchKey ()

@end

@implementation VYSwitchKey

- (instancetype)init {
    
    if (self = [super init]) {
        self.squareCubeSwitch           = Square;
        self.tex2DCubeMapSwitch         = Texture2D;
        self.pixelsImageSwitch          = Pixel;
        self.elongatedConformalSwitch   = Conformal;
        self.imageSourceSwitch          = ImageSource_512_512;
    }
    
    return self;
    
}

- (instancetype)initWithSquareCube:(VYSquareCubeKey)squareCube
                      tex2DCubeMap:(VYTexture2DCubemapKey)tex2DCubeMap
                       pixelsImage:(VYPixelImageKey)pixelsImage
                elongatedConformal:(VYElongateConformalKey)elongatedConformal
                       imageSource:(VYImageSourceKey)imageSource; {
    
    if (self = [super init]) {
        self.squareCubeSwitch           = squareCube;
        self.tex2DCubeMapSwitch         = tex2DCubeMap;
        self.pixelsImageSwitch          = pixelsImage;
        self.elongatedConformalSwitch   = elongatedConformal;
        self.imageSourceSwitch          = imageSource;
    }
    
    return self;
    
}

@end

#pragma mark - VYTextureView

#import "VYTransforms.h"

@interface VYTextureView ()
@property (strong, nonatomic) VYTransforms *currentTransforms, *oldTransforms;
@end

@implementation VYTextureView

#pragma mark - Init

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self settingDrawable];
        [self settingDefault];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self settingDrawable];
        [self settingDefault];
    }
    
    return self;
    
}

- (void)settingDrawable {
    
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    
    /*----------------------------------------------------------> Release <---*/
    [self shouldExit:([layer isKindOfClass:[CAEAGLLayer class]]) releaseOldSource:nil];
    /*----------------------------------------------------------> Release <---*/
    
    layer.drawableProperties = @{kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                 kEAGLDrawablePropertyRetainedBacking : @(YES)};
    
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.opaque = YES;
    
}

- (void)settingDefault {
    self.currentKey = [[VYSwitchKey alloc] init];
    self.currentTransforms = self.oldTransforms = [[VYTransforms alloc] init];
}

#pragma mark - Transforms

- (void)setTransformsWithProgram:(GLuint)programObject {
    
    GLuint modelViewLoc = glGetUniformLocation(programObject, "u_modelViewMat4");
    GLuint projectionLoc = glGetUniformLocation(programObject, "u_projectionMat4");
    
    VYTransforms *trans = self.currentTransforms;
    // Model Transform
    trans.modelTransform = VYSTTransformMake(trans.PositionVec3Make(0, 0.5, -3),
                                             trans.RotationVec3Make(0, 0, 0),
                                             trans.ScalingVec3Make(1, 1, 1));
    trans.modelTransformMat4 = VYSTTransformMat4Make(trans.modelTransform);
    
    // View Transform
    trans.viewTransform = VYSTTransformMake(trans.PositionVec3Make(0, 0, 0),
                                            trans.RotationVec3Make(0, 0, 0),
                                            trans.ScalingVec3Make(1, 1, 1));
    trans.viewTransformMat4 = VYSTTransformMat4Make(trans.viewTransform);
    
    // Projection Transform
    trans.aspectRadio = (self.bounds.size.width / self.bounds.size.height);
    trans.lookAt = VYLookAtMake(trans.EyeVec3Make(0, 0, 0),
                                trans.CenterVec3Make(0, 0, -1),
                                trans.UpVec3Make(0, 1, 0));
    trans.lookAtMat4 = VYLookAtMat4Make(trans.lookAt);
    
    // 使用透视投影
    trans.perspectiveProj = VYPerspectivePerspectiveMake(GLKMathDegreesToRadians(85.0),
                                                         trans.aspectRadio,
                                                         1, 150);
    trans.perspectiveProjMat4 = VYPerspectivePerspectiveMat4Make(trans.perspectiveProj);
    
    trans.baseCamera = VYCameraMake(trans.lookAtMat4,
                                    trans.perspectiveProjMat4);
    trans.baseCameraMat4 = VYCameraMat4Make(trans.baseCamera);
    
    trans.mvpTransfrom = VYMVPTransformMake(trans.modelTransformMat4,
                                            trans.viewTransformMat4,
                                            trans.baseCameraMat4);
    
    VYMVPTransform mvp = trans.mvpTransfrom;
    glUniformMatrix4fv(modelViewLoc, 1, GL_FALSE, VYMVPTransformModelViewMat4Make(mvp).m);
    glUniformMatrix4fv(projectionLoc, 1, GL_FALSE, mvp.cameraProjMat4.m);
    
}

#pragma mark - Shader Methods

- (NSString *)getShaderStringWithFileName:(NSString *)fileName {
    
    NSString *stringFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError *error;
    NSString *strings = [NSString stringWithContentsOfFile:stringFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error: Load Fail, %@", error.localizedDescription);
        return 0;
    }
    
    return strings;
    
}

- (BOOL)compliedShader:(GLuint)shaderId codeString:(NSString *)codeString {
    
    const GLchar *codeDatas = codeString.UTF8String;
    GLint codeLength = (GLint)codeString.length;
    glShaderSource(shaderId, 1, &codeDatas, &codeLength);
    
    // 编译 Shader
    glCompileShader(shaderId);
    
    // 获取 编译信息
    GLint compileSuccess;
    glGetShaderiv(shaderId, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLint infoLength;
        glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 0) {
            GLchar *messages = malloc(sizeof(GLchar *) * infoLength);
            glGetShaderInfoLog(shaderId, infoLength, NULL, messages);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Error: Compiled Fail %@ !", messageString);
            free(messages);
        }
        return NO;
    }
    
    return YES;
}

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
        return NO;
    }
    
    return YES;
}

#pragma mark - Release

typedef void (^ReleaseBlock)(void);

- (void)shouldExit:(BOOL)code releaseOldSource:(NSDictionary<NSString *, ReleaseBlock> *)releaseBlocks {
    
    if ( ! code ) {
        
        [releaseBlocks enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, ReleaseBlock  _Nonnull obj, BOOL * _Nonnull stop) {
            
            obj();
            
        }];
        
        exit(-1);
        
    }
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    CAEAGLLayer *glLayer = (CAEAGLLayer *)self.layer;
    if ( ! [glLayer isKindOfClass:[CAEAGLLayer class]] ) {
        NSLog(@"Error : 错误的 Layer !");
        return;
    }
    
    //MARK: Release Old Source
    NSMutableDictionary<NSString *, ReleaseBlock> *releaseBlockDicts = [NSMutableDictionary dictionary];
    
    //MARK: Context
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];

    //MARK: Render Buffer
    // Color Render
    GLuint colorRenderbuffer = 0;
    glGenRenderbuffers(1, &colorRenderbuffer);
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) { [EAGLContext setCurrentContext:nil]; } forKey:@"CurrentContext"];
    [self shouldExit:colorRenderbuffer releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/

    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);

    //ERROR: 原来是这里写错了，真难排查 “GL_RENDERBUFFER 写成了 colorRenderbuffer”
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
    
    BOOL square = (self.currentKey.squareCubeSwitch == Square);
    BOOL cube   = !square;
    
    //MARK: FrameBuffer
    GLuint framebuffer = 0;
    glGenFramebuffers(1, &framebuffer);
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) { glDeleteRenderbuffers(1, &colorRenderbuffer); } forKey:@"ColorRenderObject"];
    [self shouldExit:framebuffer releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        // GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT
        NSLog(@"Failure ~ %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        /*----------------------------------------------------------> Release <---*/
        [self shouldExit:framebuffer releaseOldSource:releaseBlockDicts];
        /*----------------------------------------------------------> Release <---*/
    }
    
    // Depth Render
    GLint renderWidth = 0, renderHeight = 0;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderHeight);
    
    GLuint depthRenderBuffer = 0;
    if ( cube ) {
        
        glGenRenderbuffers(1, &depthRenderBuffer);
        /*----------------------------------------------------------> Release <---*/
        [releaseBlockDicts setValue:^(void) { glDeleteRenderbuffers(1, &framebuffer); }
                             forKey:@"FrameObject"];
        [self shouldExit:depthRenderBuffer releaseOldSource:releaseBlockDicts];
        /*----------------------------------------------------------> Release <---*/
        
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, renderWidth, renderHeight);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
        
    }
    
    //MARK: Buffer Object
    GLuint bufferObject = 0;
    glGenBuffers(1, &bufferObject);
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) {
        if ( cube ) {
            glDeleteFramebuffers(1, &depthRenderBuffer);
        } else {
            glDeleteFramebuffers(1, &framebuffer);
        }
    } forKey:@"Frame_DepthObject"];
    [self shouldExit:bufferObject releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferObject);
    
    GLsizeiptr size = square ? sizeof(tex2DSquareDatas) : sizeof(tex2DCubeDatas);
    const GLvoid* data =  square ? tex2DSquareDatas : tex2DCubeDatas;
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
    
    GLsizeiptr elementSize = square ? sizeof(squareIndices) : sizeof(cubeIndices);
    const GLvoid* elementData = square ? squareIndices : cubeIndices;
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, elementSize, elementData, GL_STATIC_DRAW);
    
    //MARK: Shader Program
    // Vertex Shader
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) { glDeleteBuffers(1, &bufferObject); } forKey:@"BufferObject"];
    [self shouldExit:vertexShader releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/

    BOOL texture2D = (self.currentKey.tex2DCubeMapSwitch == Texture2D);
//    GLenum texMode = texture2D ? GL_TEXTURE_2D : GL_TEXTURE_CUBE_MAP;
    
    NSString *vertexShaderFile = texture2D ? @"VYTex2DVertexShader.glsl" : @"VYTexCubemapVertexShader.glsl";
    NSString *vertexShaderString = [self getShaderStringWithFileName:vertexShaderFile];
    BOOL failured = [self compliedShader:vertexShader codeString:vertexShaderString];
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) { glDeleteShader(vertexShader); } forKey:@"VertexShaderObject"];
    [self shouldExit:failured releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    // Fragment Shader
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    /*----------------------------------------------------------> Release <---*/
    [self shouldExit:failured releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    NSString *fragmentShaderFile = texture2D ? @"VYTex2DFragmentShader.glsl" : @"VYTexCubemapFragmentShader.glsl";
    NSString *fragmentShaderString = [self getShaderStringWithFileName:fragmentShaderFile];
    failured = [self compliedShader:fragmentShader codeString:fragmentShaderString];
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) { glDeleteShader(fragmentShader); } forKey:@"FragmentShaderObject"];
    [self shouldExit:failured releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    // Program Object
    GLuint programObject = glCreateProgram();
    /*----------------------------------------------------------> Release <---*/
    [releaseBlockDicts setValue:^(void) { glDeleteProgram(programObject); } forKey:@"ProgramObject"];
    [self shouldExit:programObject releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    GLuint positionAttributeIndex = 0;
    GLuint texCoordAttributeIndex = 1;
    glBindAttribLocation(programObject, positionAttributeIndex, "a_position");
    glBindAttribLocation(programObject, texCoordAttributeIndex, "a_texCoord");
    
    failured = [self linkShaderWithProgramID:programObject];
    /*----------------------------------------------------------> Release <---*/
    [self shouldExit:failured releaseOldSource:releaseBlockDicts];
    /*----------------------------------------------------------> Release <---*/
    
    //MARK: Bind Datas To GPU
    const GLuint positionAttributeComCount = 3;
    const GLuint texCoordAttributeComCount = 2;
    
    glEnableVertexAttribArray(positionAttributeIndex);
    glVertexAttribPointer(positionAttributeIndex,
                          positionAttributeComCount,
                          GL_FLOAT, GL_FALSE,
                          sizeof(VYVertex),
                          (const GLvoid *) offsetof(VYVertex, position));
    
    glEnableVertexAttribArray(texCoordAttributeIndex);
    glVertexAttribPointer(texCoordAttributeIndex,
                          texCoordAttributeComCount,
                          GL_FLOAT, GL_FALSE,
                          sizeof(VYVertex),
                          (const GLvoid *) offsetof(VYVertex, texCoord));
    
    //MARK: ViewPort
    glClearColor(0.3, 0.3, 0.3, 1.0);
    
    if ( cube ) {
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    } else {
        glClear(GL_COLOR_BUFFER_BIT);
    }
 
    //ERROR: 图形出现了偏移，原因是视窗太大【使用了 self.bounds.size 】
    glViewport(0,
               0,
               renderWidth,
               renderHeight);
    
    //MARK: Draw
    //ERROR: 真是醉了，忘写 glUseProgram，导致没结果
    glUseProgram(programObject);
    
    [self setTransformsWithProgram:programObject];
    
    GLsizeiptr eachElementSize = square ? sizeof(squareIndices[0]) : sizeof(cubeIndices[0]);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    glDrawElements(GL_TRIANGLES, (GLint)(elementSize / eachElementSize), GL_UNSIGNED_BYTE, elementData);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    //MARK: Release Source
    glDeleteProgram(programObject);
    glDeleteShader(fragmentShader);
    glDeleteShader(vertexShader);
    glDeleteBuffers(1, &bufferObject);
    glDeleteFramebuffers(1, &framebuffer);
    if ( cube ) { glDeleteRenderbuffers(1, &depthRenderBuffer); };
    glDeleteRenderbuffers(1, &colorRenderbuffer);
    [EAGLContext setCurrentContext:nil];
    
}

- (void)dealloc {
    [self.currentTransforms releaseAllVec3MakeFunPtr];
    [self.oldTransforms releaseAllVec3MakeFunPtr];
}

@end





