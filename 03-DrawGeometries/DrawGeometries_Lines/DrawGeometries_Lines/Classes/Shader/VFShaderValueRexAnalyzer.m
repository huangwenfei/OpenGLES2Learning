//
//  VFShaderValueRexAnalyzer.m
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/10.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFShaderValueRexAnalyzer.h"

@interface VFShaderValueRexAnalyzer ()

/**
 *  所有 Shader Code 文件 的变量集
 */
@property (strong, nonatomic)
    NSMutableDictionary<VFFileNameString *, ValueInfo_Key_Value_Type *> *shaderFileValueInfos;

@end

@implementation VFShaderValueRexAnalyzer

#pragma mark -
#pragma mark Private:
#pragma mark -

#pragma mark Getter

- (NSMutableDictionary<VFFileNameString *, ValueInfo_Key_Value_Type *> *)shaderFileValueInfos {
    
    if ( ! _shaderFileValueInfos ) {
        self.shaderFileValueInfos = [NSMutableDictionary dictionary];
    }

    return _shaderFileValueInfos;
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

#pragma mark 正则表达式
// ICU -> Per`s Rex
#define UNIFORM_REX         (@"uniform.*;")
#define ATTRIBUTE_REX       (@"attribute.*;")
#define VARYING_REX         (@"varying.*;")

+ (NSString *)uinformValueRex {
    return UNIFORM_REX;
}

+ (NSString *)attributeValueRex {
    return ATTRIBUTE_REX;
}

+ (NSString *)varyingValueRex {
    return VARYING_REX;
}

+ (NSString *)shaderValueRexWithStorageName:(NSString *)storageName {
    return [NSString stringWithFormat:@"^%@.*;$", storageName];
}

#pragma mark -
#pragma mark Public:
#pragma mark -

#pragma mark Share

// 单例
static VFShaderValueRexAnalyzer * _defaultAnalyzer;

/**
 *  默认的着色器管理者
 */
+ (instancetype)defaultShaderAnalyzer {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultAnalyzer = [[[self class] alloc] init];
    });
    
    return _defaultAnalyzer;
    
}

#define DOT_SEPARATING_CHARACTER      (@".") // 点号

/**
 *  解析着色器代码的变量
 *
 *  @param fileName 着色器代码文件
 *  @param type     着色器类型
 */
- (void)analyzingShaderCodeWithFileName:(NSString *)fileName shaderType:(NSString *)type {
    
    NSArray *nameString = [fileName componentsSeparatedByString:DOT_SEPARATING_CHARACTER];
    
    // 加载 String 数据
    NSString *stringFilePath = [[NSBundle mainBundle] pathForResource:nameString.firstObject
                                                               ofType:nameString.lastObject];
    NSError *error;
    NSString *strings = [NSString stringWithContentsOfFile:stringFilePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    NSArray *uniformStrings     = [self loadStringsWithRexType:UNIFORM_REX strings:strings];
    NSArray *attributeStrings   = [self loadStringsWithRexType:ATTRIBUTE_REX strings:strings];
    NSArray *varyingStrings     = [self loadStringsWithRexType:VARYING_REX strings:strings];
    
    ValueInfo_Dict *uniformValueInfos      = [self exchangeStringsToValueInfoWithStrings:uniformStrings];
    ValueInfo_Dict *attributeValueInfos    = [self exchangeStringsToValueInfoWithStrings:attributeStrings];
    ValueInfo_Dict *varyingValueInfos      = [self exchangeStringsToValueInfoWithStrings:varyingStrings];
    
    [self.shaderFileValueInfos setObject:@{UNIFORM_VALUE_DICT_KEY   : uniformValueInfos,
                                           ATTRIBUTE_VALUE_DICT_KEY : attributeValueInfos,
                                           VARYING_VALUE_DICT_KEY   : varyingValueInfos}
                                  forKey:nameString.firstObject];
    
//    NSLog(@"valueInfos %@", _shaderFileValueInfos);
    
}

/**
 *  更新活跃的 Uniform 变量的内存标识符
 */
- (void)updateActiveUniformsLocationsWithShaderFileName:(NSString *)fileName programID:(GLuint)programID {
    
    NSDictionary *vertexShaderValueInfos = self.shaderFileValueInfos[fileName];
    ValueInfo_Dict *uniforms = vertexShaderValueInfos[UNIFORM_VALUE_DICT_KEY];
    
    NSArray *keys = [uniforms allKeys];
    for (NSString *uniformName in keys) {
        const GLchar * uniformCharName = [uniformName UTF8String];
        GLint location = glGetUniformLocation(programID, uniformCharName);
        VFShaderValueInfo *info = uniforms[uniformName];
        info.location = location;
    }
    
}

/**
 *  获取 attribute 变量的变量信息
 *
 *  @param infoKey  信息的类型
 *  @param fileName 代码信息文件名（不包含后缀）
 *
 *  @return 变量信息模型类
 */
- (VFShaderValueInfo *)getAttributeValueInfoEntryWithValueName:(NSString *)valueName shaderFileName:(NSString *)fileName {
    
    NSDictionary *vertexShaderValueInfos = self.shaderFileValueInfos[fileName];
    ValueInfo_Dict *attributes = vertexShaderValueInfos[ATTRIBUTE_VALUE_DICT_KEY];
    
    __block VFShaderValueInfo *info = nil;
    [attributes enumerateKeysAndObjectsUsingBlock:^(VFValueNameString * _Nonnull key, VFShaderValueInfo * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([valueName isEqualToString:[obj valueKey]]) {
            info = obj;
            *stop = YES;
        }
        
    }];
    
    return info;
    
}

/**
 *  获取 uniform 变量的变量信息
 *
 *  @param valueName  信息的名称
 *  @param fileName   代码信息文件名（不包含后缀）
 *
 *  @return 变量信息模型类
 */
- (VFShaderValueInfo *)getUniformValueInfoEntryWithValueName:(NSString *)valueName shaderFileName:(NSString *)fileName {
    
    NSDictionary *vertexShaderValueInfos = self.shaderFileValueInfos[fileName];
    ValueInfo_Dict *uniforms = vertexShaderValueInfos[UNIFORM_VALUE_DICT_KEY];

    __block VFShaderValueInfo *info = nil;
    [uniforms enumerateKeysAndObjectsUsingBlock:^(VFValueNameString * _Nonnull key, VFShaderValueInfo * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([valueName isEqualToString:[obj valueKey]]) {
            info = obj;
            *stop = YES;
        }
        
    }];
    
    return info;
    
}

#pragma mark -
#pragma mark Override:
#pragma mark -

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultAnalyzer = [super allocWithZone:zone];
    });
    
    return _defaultAnalyzer;
    
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return _defaultAnalyzer;
    
}

- (id)mutableCopyWithZone:(struct _NSZone *)zone {
    
    return _defaultAnalyzer;
    
}

#pragma mark -
#pragma mark Private:
#pragma mark -

- (NSArray<NSString *> *)loadStringsWithRexType:(NSString *)rex_type strings:(NSString *)searchedStrings {
    
    NSError *error;
    NSRegularExpression *rex = [NSRegularExpression regularExpressionWithPattern:rex_type
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
    
    NSRange searchRange = NSMakeRange(0, searchedStrings.length);
    
    NSArray *results = [rex matchesInString:searchedStrings options:0 range:searchRange];
    
    NSMutableArray *strings = [NSMutableArray array];
    NSUInteger index = 0;
    for (NSTextCheckingResult *result in results) {
        
        NSString *string = [searchedStrings substringWithRange:[result range]];
//        NSLog(@"result: %@", string);
        [strings addObject:string];
        index++;
        
    }
    
    return strings;
}

#define HAVE_PRECSION_TYPE_SUBSTRING_COUNT      (4)
#define UNHAVE_PRECSION_TYPE_SUBSTRING_COUNT    (3)

#define SPACE_SEPARATING_CHARACTER      (@" ") // 空格
#define COLON_SEPARATING_CHARACTER      (@";") // 冒号

#define ARRAY_SECOND_OBJECT_INDEX   (1)
#define ARRAY_THIRD_OBJECT_INDEX    (2)

- (ValueInfo_Dict *)exchangeStringsToValueInfoWithStrings:(NSArray<NSString *> *)strings {
    
    NSMutableDictionary *infos = [NSMutableDictionary dictionary];
    
    for (NSString *string in strings) {
        
        VFShaderValueInfo *info;
        
        NSArray *subStrings = [string componentsSeparatedByString:SPACE_SEPARATING_CHARACTER];
        NSArray *nameString = [subStrings.lastObject componentsSeparatedByString:COLON_SEPARATING_CHARACTER];
        
        if (subStrings.count == HAVE_PRECSION_TYPE_SUBSTRING_COUNT) {
            
            info = [[VFShaderValueInfo alloc] initWithName:nameString.firstObject
                                                      type:subStrings[ARRAY_THIRD_OBJECT_INDEX]
                                                 precision:subStrings[ARRAY_SECOND_OBJECT_INDEX]
                                                   storage:subStrings.firstObject];
            
        }
        
        if (subStrings.count == UNHAVE_PRECSION_TYPE_SUBSTRING_COUNT) {
            
            info = [[VFShaderValueInfo alloc] initWithName:nameString.firstObject
                                                      type:subStrings[ARRAY_SECOND_OBJECT_INDEX]
                                                   storage:subStrings.firstObject];
            
        }
        
        [infos setObject:info forKey:info.name];
        
    }
    
    return infos;
    
}



@end




