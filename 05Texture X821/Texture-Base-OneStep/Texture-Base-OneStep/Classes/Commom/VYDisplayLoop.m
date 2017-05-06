//
//  VYDisplayLoop.m
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/15.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "VYDisplayLoop.h"

@import QuartzCore;

static const NSUInteger kDefaultPreferredFramesPerSecond = 30;
static const BOOL kDefaultDisplayPause = NO;

@interface VYDisplayLoop ()

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic) BOOL displayPause;

/*
 * 链接更新的各个时间间隔
 */
@property (nonatomic, assign) BOOL resume;
@property (nonatomic, assign) NSTimeInterval timeSinceFirstResume;
@property (nonatomic, assign) NSTimeInterval timeSinceLastResume;
@property (nonatomic, assign) NSTimeInterval timeSinceLastUpdate;

@end

@implementation VYDisplayLoop

#pragma mark - Getter / Setter

- (NSTimeInterval)frameRates {
    return self.displayLink.duration;
}

@dynamic displayPause;

- (void)setDisplayPause:(BOOL)displayPause {
    
    self.displayLink.paused = displayPause;
    
}

- (BOOL)displayPause {
    
    return self.displayLink.paused;
    
}

#pragma mark - Init

- (instancetype)initWithPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond {
    
    if (self = [super init]) {
        
        self.preferredFramesPerSecond   = preferredFramesPerSecond;
        self.displayPause               = kDefaultDisplayPause;

    }
    
    return self;
    
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self commit];
        
    }
    
    return self;
    
}

- (void)commit {
    
    self.preferredFramesPerSecond = kDefaultPreferredFramesPerSecond;
    self.displayPause = kDefaultDisplayPause;
    
}

- (void)startUpdate {
    
    if ( ! self.delegate ) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(displayContents:)];
    
    self.displayLink.preferredFramesPerSecond = self.preferredFramesPerSecond;
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    self.displayPause = kDefaultDisplayPause;
    
    self.resume = YES;
    
}

- (void)pauseUpdate {
    
    self.displayPause = YES;
    
}

- (void)stopUpdate {
    
    self.timeSinceLastResume = self.displayLink.timestamp;
    self.displayPause = YES;
    
    [self.displayLink invalidate];
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
    
}

- (void)displayContents:(CADisplayLink *)sender {
    
    NSTimeInterval newTime = self.displayLink.timestamp;
    
    if (self.timeSinceFirstResume == 0) {
        self.timeSinceFirstResume = newTime;
    }
    self.timeSinceLastUpdate  = newTime - self.timeSinceFirstResume;
    self.timeSinceFirstResume = newTime;
    
    if ([self.delegate respondsToSelector:@selector(updateContents)]) {
        
//        NSLog(@"duration: %f; timestamp: %f; rate: %f; LastUpdate: %f",
//              self.displayLink.duration,self.displayLink.timestamp, self.frameRates,
//              self.timeSinceLastUpdate);
//        NSLog(@"----------------------------------------------------------------------------------------");
        
        [self.delegate updateContents];
        
    }
    
}

@end
