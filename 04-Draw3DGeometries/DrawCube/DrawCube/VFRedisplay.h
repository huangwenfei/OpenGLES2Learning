//
//  VFRedisplay.h
//  DrawCube
//
//  Created by windy on 16/12/23.
//  Copyright © 2016年 windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VFRedisplayDelegate <NSObject>

- (void)updateContentsWithTimes:(NSTimeInterval)times;

@end

@interface VFRedisplay : NSObject

@property (weak, nonatomic) id<VFRedisplayDelegate> delegate;

/*
  帧速率，默认是 30
 */
@property (nonatomic) NSInteger preferredFramesPerSecond;

/*
 帧速率
 */
@property (nonatomic, readonly) NSInteger framesPerSecond;

@property (nonatomic, assign) NSTimeInterval updateContentTimes;

/*
 Time interval since properties.
 */
@property (nonatomic, readonly) NSTimeInterval timeSinceFirstResume;
@property (nonatomic, readonly) NSTimeInterval timeSinceLastResume;
@property (nonatomic, readonly) NSTimeInterval timeSinceLastUpdate;
@property (nonatomic, readonly) NSTimeInterval timeSinceLastDraw;

- (void)startUpdate;
- (void)pauseUpdate;
- (void)endUpdate;

@end
