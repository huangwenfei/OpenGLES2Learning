//
//  VYDisplayLoop.h
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/15.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VYDisplayLoopDelegate <NSObject>

- (void)updateContents;

@end

@interface VYDisplayLoop : NSObject

@property (weak, nonatomic) id<VYDisplayLoopDelegate> delegate;

/*
 * 1 秒内链接[显示]的帧数，默认是 30
 */
@property (assign, nonatomic) NSInteger preferredFramesPerSecond;

/**
 *  帧速率
 */
@property (assign, nonatomic, readonly) NSTimeInterval frameRates;

/*
 * 链接更新的各个时间间隔
 */
@property (nonatomic, readonly) NSTimeInterval timeSinceFirstResume;
@property (nonatomic, readonly) NSTimeInterval timeSinceLastResume;
@property (nonatomic, readonly) NSTimeInterval timeSinceLastUpdate;

- (instancetype)initWithPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond;

- (void)startUpdate;
- (void)pauseUpdate;
- (void)stopUpdate;

@end
