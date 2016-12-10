//
//  VFShaderValueInfo.h
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/10.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFShaderValueLocation.h"

@interface VFShaderValueInfo : NSObject<NSCoding>

/* 变量名 */
@property (assign, nonatomic) NSString  *name;
/* 变量的数据类型 */
@property (assign, nonatomic) NSString  *type;
/* 变量的精度 */
@property (assign, nonatomic) NSString  *precision;
/* 变量的存储类型 */
@property (assign, nonatomic) NSString  *storage;

/* 变量的内存标识符 */
@property (assign, nonatomic) NSInteger location;

- (instancetype)initWithName:(NSString *)name type:(NSString *)type precision:(NSString *)precision storage:(NSString *)storage;
- (instancetype)initWithName:(NSString *)name type:(NSString *)type storage:(NSString *)storage;

- (NSString *)valueKey;

@end
