//
//  VFShaderValueInfo.m
//  DrawTriangle_Fix
//
//  Created by windy on 16/11/10.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFShaderValueInfo.h"
#import "VFOpenGLES2XHeader.h"

#define DATA_NAME_KEY           (@"name")
#define DATA_TYPE_KEY           (@"type")
#define DATA_PRECISION_KEY      (@"precision")
#define DATA_STORAGE_KEY        (@"storage")
#define DATA_LOCATION_KEY       (@"location")

#define INVALID_LOCATION_VALUE      (-1)

@interface VFShaderValueInfo ()

@end

@implementation VFShaderValueInfo

#pragma mark - Init

- (instancetype)initWithName:(NSString *)name type:(NSString *)type precision:(NSString *)precision storage:(NSString *)storage {
    
    if (self = [super init]) {
        
        self.name       = name;
        self.type       = type;
        self.precision  = precision;
        self.storage    = storage;
        self.location   = [self defaultLocation];
        
    }
    
    return self;
    
}

- (instancetype)initWithName:(NSString *)name type:(NSString *)type storage:(NSString *)storage {
    
    return [self initWithName:name type:type precision:@"" storage:storage];
    
}

#pragma mark - Set Location

- (NSString *)valueKey {
    return [self.name componentsSeparatedByString:@"_"].lastObject;
}

- (NSInteger)defaultLocation {
    
    if ([self.storage isEqualToString:@"attribute"]) {
        NSArray *strings = [self.name componentsSeparatedByString:@"_"];
        if ([strings.lastObject isEqualToString:POSITION_STRING_KEY]) {
            return VFVertexPositionAttribute;
        }
        if ([strings.lastObject isEqualToString:COLOR_STRING_KEY]) {
            return VFVertexColorAttribute;
        }
    }
    
    return INVALID_LOCATION_VALUE;
    
}

#pragma mark - Get

- (NSInteger)location {
    
    if (_location == INVALID_LOCATION_VALUE) {
//        glgetloca
    }
    
    return _location;
    
}

#pragma mark - <NSCoding>

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.name       = (NSString *)[aDecoder decodeObjectForKey:DATA_NAME_KEY];
        self.type       = (NSString *)[aDecoder decodeObjectForKey:DATA_TYPE_KEY];
        self.precision  = (NSString *)[aDecoder decodeObjectForKey:DATA_PRECISION_KEY];
        self.storage    = (NSString *)[aDecoder decodeObjectForKey:DATA_STORAGE_KEY];
        self.location   = [aDecoder decodeIntegerForKey:DATA_LOCATION_KEY];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:DATA_NAME_KEY];
    [aCoder encodeObject:self.type forKey:DATA_TYPE_KEY];
    [aCoder encodeObject:self.precision forKey:DATA_PRECISION_KEY];
    [aCoder encodeObject:self.storage forKey:DATA_STORAGE_KEY];
    [aCoder encodeInteger:self.location forKey:DATA_LOCATION_KEY];
    
}

@end
