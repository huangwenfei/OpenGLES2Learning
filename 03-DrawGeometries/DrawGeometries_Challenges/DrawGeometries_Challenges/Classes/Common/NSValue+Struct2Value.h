//
//  NSValue+Struct2Value.h
//  DrawGeometries_Challenges
//
//  Created by windy on 16/12/2.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (Struct2Value)

// 结构体转换成 NSValue 对象
+ (NSValue *)valueObjByStructPtr:(const void *)str objType:(const char * )objType;
// NSValue 转换成 Struct
+ (void)structFromValueObj:(NSValue *)value structPtr:(void *)str;

@end
