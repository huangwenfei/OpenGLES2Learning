//
//  VFShaderValueRexAnalyzer.h
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/10.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFOpenGLES2XHeader.h"
#import "VFShaderValueInfo.h"

typedef NSString VFFileNameString;
typedef NSString VFValueStorageString;
typedef NSString VFValueNameString;

#define ValueInfo_Dict      NSDictionary<VFValueNameString *, VFShaderValueInfo *>

#define ValueInfo_Key_Value_Type                             \
    NSDictionary <VFValueStorageString *, ValueInfo_Dict *>

static NSString * VERTEX_SHADER     = @"vertexShader";
static NSString * FRAGMENT_SHADER   = @"fragmentShader";

static NSString * ATTRIBUTE_VALUE_DICT_KEY  = @"attributekey";
static NSString * UNIFORM_VALUE_DICT_KEY    = @"uniformkey";
static NSString * VARYING_VALUE_DICT_KEY    = @"varyingkey";

@interface VFShaderValueRexAnalyzer : NSObject

/**
 *  所有 Shader Code 文件 的变量集
 */
@property (strong, nonatomic, readonly)
    NSMutableDictionary<VFFileNameString *, ValueInfo_Key_Value_Type *> *shaderFileValueInfos;

/**
 *  默认的代码变量分析器
 */
+ (instancetype)defaultShaderAnalyzer;

/**
 *  更新活跃的 Uniform 变量的内存标识符
 *
 *  @param fileName 代码信息文件名（不包含后缀）
 */
- (void)updateActiveUniformsLocationsWithShaderFileName:(NSString *)fileName programID:(GLuint)programID;

/**
 *  解析着色器代码的变量
 *
 *  @param fileName 着色器代码文件
 *  @param type     着色器类型
 */
- (void)analyzingShaderCodeWithFileName:(NSString *)fileName shaderType:(NSString *)type;

/**
 *  获取 attribute 变量的变量信息
 *
 *  @param infoKey  信息的类型
 *  @param fileName 代码信息文件名（不包含后缀）
 *
 *  @return 变量信息模型类
 */
- (VFShaderValueInfo *)getAttributeValueInfoEntryWithValueName:(NSString *)valueName shaderFileName:(NSString *)fileName;

/**
 *  获取 uniform 变量的变量信息
 *
 *  @param valueName  信息的名称
 *  @param fileName   代码信息文件名（不包含后缀）
 *
 *  @return 变量信息模型类
 */
- (VFShaderValueInfo *)getUniformValueInfoEntryWithValueName:(NSString *)valueName shaderFileName:(NSString *)fileName;

@end



