//
//  main.m
//  VFDynamicCalculateGeoPoints
//
//  Created by windy on 16/11/26.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFCalculatePoints.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        VFCalculatePoints *pointMaker = [[VFCalculatePoints alloc] init];
        
        CGFloat radii = 0.5f;
        NSArray *geos = @[@(3), @(4), @(5), @(6), @(10)];
        [pointMaker makeRegularVertexPointsReadToFileWithRadii:radii geolines:geos];
        
        NSArray *traPoints = [pointMaker makeTrapezoidVertexPointsWithWidth:0.7f
                                                                     height:0.5f
                                                                  topOffset:CGPointMake(0.f, 0.f)
                                                                bottomOffet:CGPointMake(0.25f, 0.f)];
        [pointMaker buildDatasInFileWithMode:AppendContent content:traPoints];
        
        NSArray *starPoints = [pointMaker makeStarVertexPointsWithInnerRadii:0.3f outterRadii:0.5f];
        [pointMaker buildDatasInFileWithMode:AppendContent content:starPoints];
        
        NSArray *roundPoints = [pointMaker makeRegularVertexPointsWithRadii:0.5f lines:100];
        [pointMaker buildDatasInFileWithMode:AppendContent content:roundPoints];
        
    }
    return 0;
}
