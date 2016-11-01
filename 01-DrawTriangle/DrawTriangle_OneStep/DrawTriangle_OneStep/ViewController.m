//
//  ViewController.m
//  DrawTriangle_OneStep
//
//  Created by windy on 16/10/25.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "ViewController.h"

#import "VFGLTriangleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = CGRectOffset(self.view.frame, 0, 0);
//    CGRect rect = CGRectOffset(self.view.frame, 10, 20);
//    CGRect rect = CGRectMake(10, 20, CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    VFGLTriangleView *glView = [[VFGLTriangleView alloc] initWithFrame:rect];
    [glView setVertexMode:VertexDataMode_VBO];
    
    [self.view addSubview:glView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
