//
//  VFShaderManager.m
//  DrawTriangle_OOP
//
//  Created by windy on 16/10/30.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFShaderManager.h"

typedef NS_ENUM(NSUInteger, VFShaderType) {
    
    VFShaderVertexType   = GL_VERTEX_SHADER,
    VFShaderFragmentType = GL_FRAGMENT_SHADER,
    
};

@interface VFShaderManager ()<OpenELESErrorHandle>
@property (assign, nonatomic) GLuint vertexShaderID;
@property (assign, nonatomic) GLuint fragmentShaderID;
@property (assign, nonatomic) GLuint shaderProgramID;
@end

@implementation VFShaderManager

#pragma mark -
#pragma mark Public:
#pragma mark -

#pragma mark Share

/**
 *  默认的着色器管理者
 */
+ (instancetype)defaultShaderManager {
    
    static dispatch_once_t onceToken;
    static VFShaderManager * defaultManager;
    dispatch_once(&onceToken, ^{
        defaultManager = [[[self class] alloc] init];
    });
    
    return defaultManager;
    
}

#pragma mark - Attach Shader

/**
 *  装载着色器
 *
 *  @param fileName           着色器代码文件
 *  @param VFShaderVertexType 着色器类型
 */
- (void)attachVertexShader:(NSString *)vertexStringFileName fragmentShader:(NSString *)fragmentStringFileName {
    
    [self compileShaderWithFileName:vertexStringFileName shaderType:VFShaderVertexType];
    [self compileShaderWithFileName:fragmentStringFileName shaderType:VFShaderFragmentType];
    
    self.shaderProgramID = [self createShaderProgram];
    [self attachShaderWithVertexShaderIdentifier:self.vertexShaderID fragmentShaderIdentifier:self.fragmentShaderID];
    
    BOOL isLinkSuccess = [self linkShaderWithProgramID:self.shaderProgramID];
    if ( ! isLinkSuccess ) {
        // Error Handle
    }
    
}

/**
 *  使用着色器
 */
- (void)useShader {
    
    glUseProgram(self.shaderProgramID);
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

/**
 *  编译着色器
 *
 *  @param fileName   着色器代码文件
 *  @param shaderType 着色器类型
 */
- (void)compileShaderWithFileName:(NSString *)fileName shaderType:(VFShaderType)shaderType {
    
    if (shaderType == VFShaderVertexType) {
        
        self.vertexShaderID = [self loadShaderCodeWithFileName:fileName shaderType:VFShaderVertexType];
        // Error Handle
        [self compilingShaderWithShaderIdentifier:self.vertexShaderID];
        
    } else {
        
        self.fragmentShaderID = [self loadShaderCodeWithFileName:fileName shaderType:VFShaderFragmentType];
        // Error Handle
        [self compilingShaderWithShaderIdentifier:self.fragmentShaderID];
        
    }
    
}

/**
 *  加载着色器代码
 *
 *  @param fileName   着色器代码文件
 *  @param shaderType 着色器类型
 *
 *  @return 着色器标识
 */
- (GLuint)loadShaderCodeWithFileName:(NSString *)fileName shaderType:(VFShaderType)shaderType {
    
    // 加载 String 数据
    NSString *stringFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError *error;
    NSString *strings = [NSString stringWithContentsOfFile:stringFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error: Load Fail, %@", error.localizedDescription);
        return InvalidShaderID;
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
        if (infoLength > EmptyMessage) {
            GLchar *messages = malloc(sizeof(GLchar *) * infoLength);
            glGetShaderInfoLog(shaderID, infoLength, NULL, messages);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Error: Compiled Fail %@ !", messageString);
            free(messages);
        }
        return Failure;// Failure = NO;
    }
    
    return Successfully;
    
}

/**
 *  创建着色器程序
 */
- (GLuint)createShaderProgram {
    
    return glCreateProgram();
    
}

/**
 *  装载顶点着色器和片元着色器
 *
 *  @param vertexShaderID   顶点着色器标识
 *  @param fragmentShaderID 片元着色器标识
 */
- (void)attachShaderWithVertexShaderIdentifier:(GLuint)vertexShaderID fragmentShaderIdentifier:(GLuint)fragmentShaderID {
    
    glAttachShader(self.shaderProgramID, vertexShaderID);
    glAttachShader(self.shaderProgramID, fragmentShaderID);
    
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
        if (infoLength > EmptyMessage) {
            GLchar *messages = malloc(sizeof(GLchar *) * infoLength);
            glGetProgramInfoLog(programID, infoLength, NULL, messages);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Error: Link Fail %@ !", messageString);
            free(messages);
        }
        return Failure;
    }
    
    return Successfully;
}

#pragma mark - <OpenGLESFreeSource>

- (void)releaseSource {
    
    if (self.shaderProgramID != InvalidProgramID && glIsProgram(self.shaderProgramID)) {
        if (self.vertexShaderID != InvalidShaderID && glIsShader(self.vertexShaderID)) {
            glDetachShader(self.shaderProgramID, self.vertexShaderID);
            glDeleteShader(self.vertexShaderID);
            self.vertexShaderID = InvalidShaderID;
        }
        if (self.fragmentShaderID != InvalidShaderID && glIsShader(self.fragmentShaderID)) {
            glDetachShader(self.shaderProgramID, self.fragmentShaderID);
            glDeleteShader(self.fragmentShaderID);
            self.fragmentShaderID = InvalidShaderID;
        }
        
        glDeleteProgram(self.shaderProgramID);
        self.shaderProgramID = InvalidProgramID;
        
    }
    
}

- (void)postReleaseSourceNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VFErrorHandleNotificationName
                                                        object:[self class]];
    
}

#pragma mark - <OpenELESErrorHandle>

- (void)errorHandleWithType:(void const *)errorType {
    
    [self postReleaseSourceNotification];
    
    if (_isEqual(VFError_GLSL_FileName_Type, errorType)) {
        [self handleGLSLShaderCodeFileNameError];
    }
    
    if (_isEqual(VFError_GLSL_File_Non_Exsit_Type, errorType)) {
        [self handleGLSLShaderCodeFileNonExsitError];
    }
    
    if (_isEqual(VFError_VertexShader_Identifier_Type, errorType)) {
        [self handleVertexShaderIDError];
    }
    
    if (_isEqual(VFError_FragmentShader_Identifier_Type, errorType)) {
        [self handleFragmentShaderIDError];
    }
    
    if (_isEqual(VFError_ShaderProgram_Identifier_Type, errorType)) {
        [self handleShaderProgramIDError];
    }
    
    if (_isEqual(VFError_ShaderProgram_Link_Type, errorType)) {
        [self handleShaderProgramLinkError];
    }
    
    [self releaseSource];
    EXIT_APPLICATION();
    
}

#pragma mark - Error Handle

- (void)handleGLSLShaderCodeFileNameError {
    
    NSLog(@"请检查文件名是否正确。");
    
}

- (void)handleGLSLShaderCodeFileNonExsitError {
    
    NSLog(@"请检查文件是否正确地放在 MainBundle 中。");
    
}

- (void)handleVertexShaderIDError {

    if (self.vertexShaderID != InvalidShaderID && glIsShader(self.vertexShaderID)) {
        glDeleteShader(self.vertexShaderID);
        self.vertexShaderID = InvalidShaderID;
    }
    NSLog(@"VertexShader 对象分配失败 ！");
    
}

- (void)handleFragmentShaderIDError {

    if (self.fragmentShaderID != InvalidShaderID && glIsShader(self.fragmentShaderID)) {
        glDeleteShader(self.fragmentShaderID);
        self.fragmentShaderID = InvalidShaderID;
    }
    NSLog(@"FragmentShader 对象分配失败 ！");
    
}

- (void)handleShaderProgramIDError {
    
    if (self.shaderProgramID != InvalidProgramID && glIsProgram(self.shaderProgramID)) {
        glDeleteProgram(self.shaderProgramID);
        self.shaderProgramID = InvalidProgramID;
    }
    NSLog(@"ShaderProgram 对象分配失败 ！");
    
}

- (void)handleShaderProgramLinkError {

    NSLog(@"Shader Program 链接失败 ！");
    
}


@end





