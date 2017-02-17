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

- (void)insertSegmentTitlesWithSeg:(UISegmentedControl *)seg titles:(NSArray<NSString *> *)titles {
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [seg insertSegmentWithTitle:obj atIndex:idx animated:YES];
    }];
}

- (IBAction)squareCubeSwitchAction:(UISegmentedControl *)sender {
    
    self.texView.currentKey.squareCubeSwitch = (VYSquareCubeKey)sender.selectedSegmentIndex;
    [self dealingTex2DSegCon];
    
}
- (IBAction)tex2DCubeMapSwitchAction:(UISegmentedControl *)sender {
    
    self.texView.currentKey.tex2DCubeMapSwitch = (VYTexture2DCubemapKey)sender.selectedSegmentIndex;
    
    NSArray<NSString *> *segment2DTitles      = @[@"长方图(UD)", @"长方图(DD)", @"正方图"];
    NSArray<NSString *> *segmentCubemapTitles = @[@"正方图"];
    
    if (self.texView.currentKey.pixelsImageSwitch == Pixel) {
        return;
    }
    
    [self.elongated_Conformal_SegCon removeAllSegments];
    if (self.texView.currentKey.tex2DCubeMapSwitch == TextureCubemap) {
        [self insertSegmentTitlesWithSeg:self.elongated_Conformal_SegCon titles:segmentCubemapTitles];
        [self.elongated_Conformal_SegCon setSelectedSegmentIndex:0];
    } else {
         [self insertSegmentTitlesWithSeg:self.elongated_Conformal_SegCon titles:segment2DTitles];
        [self.elongated_Conformal_SegCon setSelectedSegmentIndex:2];
    }
    
}
- (IBAction)pixelsImageSwitchAction:(UISegmentedControl *)sender {
    
    self.texView.currentKey.pixelsImageSwitch = (VYPixelImageKey)sender.selectedSegmentIndex;
    
    if (self.texView.currentKey.pixelsImageSwitch == Pixel) {
        return;
    }
    
    NSArray<NSString *> *squareITitles      = @[@"512_512", @"128_128"];
    NSArray<NSString *> *cube2DELUDITitles  = @[@"HDR湖泊", @"L768_512"];
    NSArray<NSString *> *cube2DELDDITitles  = @[@"Rubik's Cube"];
    NSArray<NSString *> *cube2DCorITitles   = @[@"512_512", @"128_128"];
    NSArray<NSString *> *cubemapITitles     = @[@"512_512s", @"HDR-CP湖泊"];
    
    [self.imageSource_SegCon removeAllSegments];
    if (self.texView.currentKey.squareCubeSwitch == Square) {
         [self insertSegmentTitlesWithSeg:self.imageSource_SegCon titles:squareITitles];
    } else {
        
        if (self.texView.currentKey.tex2DCubeMapSwitch == Texture2D) {
            
            switch (self.texView.currentKey.elongatedConformalSwitch) {
                case Conformal:
                     [self insertSegmentTitlesWithSeg:self.imageSource_SegCon titles:cube2DCorITitles];
                    break;
                    
                case Elongate_UD:
                     [self insertSegmentTitlesWithSeg:self.imageSource_SegCon titles:cube2DELUDITitles];
                    break;
                    
                case Elongate_DD:
                     [self insertSegmentTitlesWithSeg:self.imageSource_SegCon titles:cube2DELDDITitles];
                    break;
                    
                default:
                    break;
            }
            
        } else {
            [self insertSegmentTitlesWithSeg:self.imageSource_SegCon titles:cubemapITitles];
        }
        
    }
    [self.imageSource_SegCon setSelectedSegmentIndex:0];
    
}
- (IBAction)elongatedConformalSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.elongatedConformalSwitch = (VYElongateConformalKey)sender.selectedSegmentIndex;
}
- (IBAction)imageSourceSwitchAction:(UISegmentedControl *)sender {
    
    NSUInteger key = sender.selectedSegmentIndex;
    
    if ( self.texView.currentKey.elongatedConformalSwitch == Elongate_DD ) {
        key %= 2;
    } else {
        key = 0;
    }
    
    self.texView.currentKey.imageSourceSwitch = (VYImageSourceKey)key;
    
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
            self.texView.currentKey.elongatedConformalSwitch = EC_UnKnown;
        }
        
    } else {
        self.imageSource_SegCon.enabled = NO;
        self.texView.currentKey.imageSourceSwitch = IS_UnKnown;
        self.elongated_Conformal_SegCon.enabled = NO;
        self.texView.currentKey.elongatedConformalSwitch = EC_UnKnown;
    }
    
}

@end
