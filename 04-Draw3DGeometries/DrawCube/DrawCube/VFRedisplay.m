//
//  VFRedisplay.m
//  DrawCube
//
//  Created by windy on 16/12/23.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFRedisplay.h"

@import QuartzCore;

static const NSUInteger kTotalSeconds = 60;
static const NSUInteger kLeastSeconds = 1;

static const CGFloat kDefaultUpdateSeconds = 0.2;
static const NSUInteger kDefaultPreferredFramesPerSecond = 30;
static const BOOL kDefaultDisplayPause = NO;

// - (void)selector:(CADisplayLink *)sender;

@interface VFRedisplay ()

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) BOOL displayPause;

/*
 Time interval since properties.
 */
@property (nonatomic, assign) NSTimeInterval timeSinceFirstResume;
@property (nonatomic, assign) NSTimeInterval timeSinceLastResume;
@property (nonatomic, assign) NSTimeInterval timeSinceLastUpdate;
@property (nonatomic, assign) NSTimeInterval timeSinceLastDraw;

@end

@implementation VFRedisplay

#pragma mark - Getter / Setter

- (NSInteger)framesPerSecond {
    
    return kTotalSeconds / self.displayLink.frameInterval;
    
}

@dynamic displayPause;

- (void)setDisplayPause:(BOOL)displayPause {
    
    self.displayLink.paused = displayPause;
    
}

- (BOOL)displayPause {

    return self.displayLink.paused;
    
}

- (NSTimeInterval)timeSinceFirstResume {
    
    return 0;
    
}

- (NSTimeInterval)timeSinceLastResume {
    
    return 0;
    
}

- (NSTimeInterval)timeSinceLastUpdate {
    
    return 0;
    
}

- (NSTimeInterval)timeSinceLastDraw {
    
    return 0;
    
}

#pragma mark - Init

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self commit];
        
    }
    
    return self;
    
}

- (void)commit {
    
    self.preferredFramesPerSecond = kDefaultPreferredFramesPerSecond;
    self.displayPause = kDefaultDisplayPause;
    self.updateContentTimes = kDefaultUpdateSeconds;
    
}

- (void)startUpdate {
    
    if ( ! self.delegate ) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(displayContents:)];
    
    self.displayLink.frameInterval = (NSUInteger)MAX(kLeastSeconds,
                                                     (kTotalSeconds / self.preferredFramesPerSecond));
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    self.displayPause = kDefaultDisplayPause;
    
}

- (void)pauseUpdate {
    
    self.displayPause = YES;
    
}

- (void)endUpdate {
    
    self.displayPause = YES;
    [self.displayLink invalidate];
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
    
    
}

- (void)displayContents:(CADisplayLink *)sender {
    
    if ([self.delegate respondsToSelector:@selector(updateContentsWithTimes:)]) {
        
        [self.delegate updateContentsWithTimes:self.updateContentTimes];
        
    }
    
}

@end
