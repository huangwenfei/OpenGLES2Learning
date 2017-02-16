//
//  ViewController.m
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/13.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "VYTextureView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *square_Cube_SegCon;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tex2D_CubeMap_SegCon;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pixels_Image_SegCon;
@property (weak, nonatomic) IBOutlet UISegmentedControl *elongated_Conformal_SegCon;
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageSource_SegCon;

@property (strong, nonatomic, nonnull) VYTextureView *texView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.texView = [[VYTextureView alloc] initWithFrame:self.view.bounds];
    
    VYSwitchKey *currentKey = self.texView.currentKey;
    self.square_Cube_SegCon.selectedSegmentIndex            = currentKey.squareCubeSwitch;
    self.tex2D_CubeMap_SegCon.selectedSegmentIndex          = currentKey.tex2DCubeMapSwitch;
    self.pixels_Image_SegCon.selectedSegmentIndex           = currentKey.pixelsImageSwitch;
    self.elongated_Conformal_SegCon.selectedSegmentIndex    = currentKey.elongatedConformalSwitch;
    self.imageSource_SegCon.selectedSegmentIndex            = currentKey.imageSourceSwitch;
    
    [self.view insertSubview:self.texView atIndex:0];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SegCon Actions

- (IBAction)squareCubeSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.squareCubeSwitch = (VYSquareCubeKey)sender.selectedSegmentIndex;
}
- (IBAction)tex2DCubeMapSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.tex2DCubeMapSwitch = (VYTexture2DCubemapKey)sender.selectedSegmentIndex;
}
- (IBAction)pixelsImageSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.pixelsImageSwitch = (VYPixelImageKey)sender.selectedSegmentIndex;
}
- (IBAction)elongatedConformalSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.elongatedConformalSwitch = (VYElongateConformalKey)sender.selectedSegmentIndex;
}
- (IBAction)imageSourceSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.imageSourceSwitch = (VYImageSourceKey)sender.selectedSegmentIndex;
}

@end
