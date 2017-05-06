//
//  ViewController.m
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "ViewController.h"

#import "VFRenderWindow.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    VFRenderWindow *renderWindow = [[VFRenderWindow alloc] initWithFrame:self.view.bounds];
    [renderWindow prepareDisplay];

    [self.view addSubview:renderWindow];
    [renderWindow display];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
