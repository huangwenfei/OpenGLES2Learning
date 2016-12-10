//
//  NSValue+Struct2Value.m
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "NSValue+Struct2Value.h"

@implementation NSValue (Struct2Value)

#pragma mark - Struct & NSValue

// 结构体转换成 NSValue 对象
+ (NSValue *)valueObjByStructPtr:(const void *)str objType:(const char * )objType {
    return [NSValue valueWithBytes:str objCType:objType];
}

// NSValue 转换成 Struct
+ (void)structFromValueObj:(NSValue *)value structPtr:(void *)str {
    [value getValue:str];
}

@end
