//
//  VYTransforms.m
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/15.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "VYTransforms.h"

@implementation VYTransforms

- (instancetype)init {
    if (self = [super init]) {
        [self settingDefault];
    }
    return self;
}

- (void)settingDefault {
    
    self.PositionVec3Make   = GLKVector3Make;
    self.RotationVec3Make   = self.PositionVec3Make;
    self.ScalingVec3Make    = self.PositionVec3Make;
    
    self.EyeVec3Make        = self.PositionVec3Make;
    self.CenterVec3Make     = self.PositionVec3Make;
    self.UpVec3Make         = self.PositionVec3Make;
    
    self.modelUpdate        = NO;
    self.viewUpdate         = self.modelUpdate;
    self.lookAtUpdate       = self.modelUpdate;
    self.projectionUpdate   = self.modelUpdate;
    
}

- (void)releaseAllVec3MakeFunPtr {
    
    Vector3Make funPtr[] = {self.PositionVec3Make, self.RotationVec3Make, self.ScalingVec3Make,
                            self.EyeVec3Make, self.CenterVec3Make, self.UpVec3Make, NULL};
    
    for (NSUInteger i = 0; funPtr[i] != NULL; i++) {
        free(funPtr[i]);
    }
    
}

@end




