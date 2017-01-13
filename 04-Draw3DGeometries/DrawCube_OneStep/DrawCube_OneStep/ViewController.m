//
//  ViewController.m
//  Texture-Part1-OneStep
//
//  Created by windy on 17/1/6.
//  Copyright © 2017年 windy. All rights reserved.
//

#import "ViewController.h"

#import "VFDrawCubeView.h"

@interface ViewController ()
@property (strong, nonatomic) VFDrawCubeView *cubeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect cubeViewRect = self.view.bounds;
    self.cubeView = [[VFDrawCubeView alloc] initWithFrame:cubeViewRect];
    
    [self.view addSubview:self.cubeView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.cubeView update];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.cubeView pauseUpdate];
    
}

@end
