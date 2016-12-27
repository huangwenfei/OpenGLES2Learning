//
//  ViewController.m
//  DrawTriangle_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "ViewController.h"

#import "VFGLCubeView.h"

@interface ViewController ()
@property (strong, nonatomic) VFGLCubeView *cubeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = CGRectOffset(self.view.frame, 0, 0);
    self.cubeView = [[VFGLCubeView alloc] initWithFrame:rect];
    
    [_cubeView prepareDisplay];
    [_cubeView drawAndRender];
    
    [self.view addSubview:_cubeView];
    
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
