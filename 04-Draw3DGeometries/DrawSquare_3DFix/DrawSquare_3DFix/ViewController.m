//
//  ViewController.m
//  DrawTriangle_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "ViewController.h"

#import "VFGLSquareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = CGRectOffset(self.view.frame, 0, 0);
    VFGLSquareView *glView = [[VFGLSquareView alloc] initWithFrame:rect];
    [glView setVertexMode:VertexDataMode_VBO];
    
    [glView prepareDisplay];
    [glView drawAndRender];
    
    [glView updateContentsWithSeconds:2];
    
    [self.view addSubview:glView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
