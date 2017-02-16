//
//  ViewController.m
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/13.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "VYTextureView.h"

@interface ViewController () <VYTextureViewDelegate>

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
    self.texView.delegate = self;
    
    [self dealingTex2DSegCon];
    
    NSArray<UISegmentedControl *> *segments = @[self.square_Cube_SegCon, self.tex2D_CubeMap_SegCon,
                                                self.pixels_Image_SegCon, self.elongated_Conformal_SegCon,
                                                self.imageSource_SegCon];
    
    VYSwitchKey *currentKey = self.texView.currentKey;
    NSArray<NSNumber *> *keys = @[@(currentKey.squareCubeSwitch), @(currentKey.tex2DCubeMapSwitch),
                                  @(currentKey.pixelsImageSwitch), @(currentKey.elongatedConformalSwitch),
                                  @(currentKey.imageSourceSwitch)];
    [self lockSegment:segments currentKeys:keys];
    
    [self.view insertSubview:self.texView atIndex:0];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SegCon Actions

- (void)dealingTex2DSegCon {
    NSString *segmentTitle = @"TextureCubemap";
    NSUInteger segmentIndex = 1;
    if (self.texView.currentKey.squareCubeSwitch == Square) {
        [self.tex2D_CubeMap_SegCon removeSegmentAtIndex:segmentIndex animated:YES];
    } else {
        [self.tex2D_CubeMap_SegCon insertSegmentWithTitle:segmentTitle atIndex:segmentIndex animated:YES];
    }
}

- (IBAction)squareCubeSwitchAction:(UISegmentedControl *)sender {
    
    self.texView.currentKey.squareCubeSwitch = (VYSquareCubeKey)sender.selectedSegmentIndex;
    [self dealingTex2DSegCon];
    
}
- (IBAction)tex2DCubeMapSwitchAction:(UISegmentedControl *)sender {
    
    self.texView.currentKey.tex2DCubeMapSwitch = (VYTexture2DCubemapKey)sender.selectedSegmentIndex;
    
    NSString *segmentTitle = @"长方图";
    NSUInteger segmentIndex = 0;
    if (self.texView.currentKey.squareCubeSwitch == Square) {
        [self.tex2D_CubeMap_SegCon removeSegmentAtIndex:segmentIndex animated:YES];
    } else {
        [self.tex2D_CubeMap_SegCon insertSegmentWithTitle:segmentTitle atIndex:segmentIndex animated:YES];
    }
    
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

- (void)lockSegment:(NSArray<UISegmentedControl *> *)segments currentKeys:(NSArray<NSNumber *> *)keys {
    [segments enumerateObjectsUsingBlock:^(UISegmentedControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int key = keys[idx].intValue;
        if (key == UnknownKey) {
            obj.enabled = NO;
            obj.selectedSegmentIndex = 0;
        } else {
            obj.enabled = YES;
            obj.selectedSegmentIndex = key;
        }
    }];
}

#pragma mark - Update

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.texView update];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.texView pauseUpdate];
    
}

#pragma mark - <VYTextureViewDelegate>

- (void)realTimeUpdateContents {
    
    if (self.texView.currentKey.pixelsImageSwitch == Image) {
        
        self.imageSource_SegCon.enabled = YES;
        
        if (self.texView.currentKey.tex2DCubeMapSwitch == Texture2D &&
            self.texView.currentKey.squareCubeSwitch == Cube) {
            
            self.elongated_Conformal_SegCon.enabled = YES;
        } else {
            self.elongated_Conformal_SegCon.enabled = NO;
        }
        
    } else {
        self.imageSource_SegCon.enabled = NO;
    }
    
}

@end
