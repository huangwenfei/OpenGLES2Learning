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
    
    [self.view insertSubview:self.texView atIndex:0];
    
    [self settingDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SegCon Actions

- (void)settingDefault {
    
    NSArray<UISegmentedControl *> *segments = @[self.square_Cube_SegCon, self.tex2D_CubeMap_SegCon,
                                                self.pixels_Image_SegCon, self.elongated_Conformal_SegCon,
                                                self.imageSource_SegCon];
    
    VYSwitchKey *currentKey = self.texView.currentKey;
    NSArray<NSNumber *> *keys = @[@(currentKey.squareCubeSwitch), @(currentKey.tex2DCubeMapSwitch),
                                  @(currentKey.pixelsImageSwitch), @(currentKey.elongatedConformalSwitch),
                                  @(currentKey.imageSourceSwitch)];
    [self lockSegment:segments currentKeys:keys];
    
    [self enable:NO segmentedControl:self.tex2D_CubeMap_SegCon indices:@[@(1)]];
    [self enable:NO segmentedControl:self.elongated_Conformal_SegCon indices:@[@(0), @(1)]];
    [self enable:NO segmentControls:@[self.elongated_Conformal_SegCon, self.imageSource_SegCon]];
    
}

- (IBAction)squareCubeSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.squareCubeSwitch = (VYSquareCubeKey)sender.selectedSegmentIndex;
    [self actionsWithSender:sender];
}
- (IBAction)tex2DCubeMapSwitchAction:(UISegmentedControl *)sender {
    self.texView.currentKey.tex2DCubeMapSwitch = (VYTexture2DCubemapKey)sender.selectedSegmentIndex;
    [self actionsWithSender:sender];
}
- (IBAction)pixelsImageSwitchAction:(UISegmentedControl *)sender {
    self.imageSource_SegCon.selectedSegmentIndex = 0;
    self.texView.currentKey.pixelsImageSwitch = (VYPixelImageKey)sender.selectedSegmentIndex;
    [self actionsWithSender:sender];
}
- (IBAction)elongatedConformalSwitchAction:(UISegmentedControl *)sender {
    self.imageSource_SegCon.selectedSegmentIndex = 0;
    self.texView.currentKey.elongatedConformalSwitch = (VYElongateConformalKey)sender.selectedSegmentIndex;
    [self actionsWithSender:sender];
}
- (IBAction)imageSourceSwitchAction:(UISegmentedControl *)sender {
    [self actionsWithSender:sender];
}

- (void)actionsWithSender:(UISegmentedControl *)sender {
    
    BOOL square = (self.texView.currentKey.squareCubeSwitch == Square);
    BOOL cube   = !square;
    
    BOOL texture2D  = (self.texView.currentKey.tex2DCubeMapSwitch == Texture2D);
    BOOL texCubemap = !texture2D;
    
    BOOL pixels = (self.texView.currentKey.pixelsImageSwitch == Pixel);
    BOOL image  = !pixels;
    
    if ( pixels ) {
        
        [self enable:(square ? NO : YES) segmentedControl:self.tex2D_CubeMap_SegCon indices:@[@(1)]];
        [self enable:NO segmentedControl:self.elongated_Conformal_SegCon indices:@[@(0), @(1)]];
        [self enable:NO segmentControls:@[self.elongated_Conformal_SegCon, self.imageSource_SegCon]];
        
        if ( square ) { self.tex2D_CubeMap_SegCon.selectedSegmentIndex = 0; };
        
    }
    
    if ( image ) {
        
        NSUInteger offset = (NSUInteger)ImageSource_512_512;
        BOOL openOffsetAdd = (sender == self.imageSource_SegCon);

        NSDictionary<NSNumber *, NSString *> *squareITitles      = @{@(0) : @"512_512", @(1) : @"128_128"};
        NSDictionary<NSNumber *, NSString *> *cube2DELUDITitles  = @{@(0) : @"HDR湖泊", @(1) : @"L768_512"};
        NSDictionary<NSNumber *, NSString *> *cube2DELDDITitles  = @{@(0) : @"Rubik's Cube"};
        NSDictionary<NSNumber *, NSString *> *cube2DCorITitles   = squareITitles;
        NSDictionary<NSNumber *, NSString *> *cubemapITitles     = @{@(0) : @"512_512s"};
        
        [self enable:YES segmentControls:@[self.elongated_Conformal_SegCon, self.imageSource_SegCon]];
        
        if ( square ) {
            
            [self enable:NO segmentedControl:self.tex2D_CubeMap_SegCon indices:@[@(1)]];
            self.tex2D_CubeMap_SegCon.selectedSegmentIndex = 0;
            [self enable:NO segmentedControl:self.elongated_Conformal_SegCon indices:@[@(0), @(1)]];
            [self setSegmentControl:self.imageSource_SegCon titles:squareITitles];
            
        }
        
        if ( cube ) {
            
            if ( texture2D ) {
                
                [self enable:YES segmentedControl:self.tex2D_CubeMap_SegCon indices:@[@(1)]];
                [self enable:YES segmentedControl:self.elongated_Conformal_SegCon indices:@[@(0), @(1)]];
                
                switch ( self.texView.currentKey.elongatedConformalSwitch ) {
                    case Conformal:
                        [self setSegmentControl:self.imageSource_SegCon titles:cube2DCorITitles];
                        break;
                        
                    case Elongate_UD:
                        [self setSegmentControl:self.imageSource_SegCon titles:cube2DELUDITitles];
                        offset = ImageSource_Single_768_512_01;
                        break;
                        
                    case Elongate_DD:
                        [self setSegmentControl:self.imageSource_SegCon titles:cube2DELDDITitles];
                        offset = ImageSource_Mutil_768_512_01;
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            if ( texCubemap ) {
                [self enable:NO segmentedControl:self.elongated_Conformal_SegCon indices:@[@(0), @(1)]];
                [self setSegmentControl:self.imageSource_SegCon titles:cubemapITitles];
                offset = ImageSource_Cubemap_512_512s;
            }
            
        }
        
        if ( openOffsetAdd ) { offset += sender.selectedSegmentIndex; }
        self.texView.currentKey.imageSourceSwitch = (VYImageSourceKey)offset;
        
    }
    
}

- (void)setSegmentControl:(UISegmentedControl *)seg titles:(NSDictionary<NSNumber *, NSString *> *)titleDict {
    if ( titleDict.count != seg.numberOfSegments ) {
        [seg removeAllSegments];
        [self insertSegmentTitlesWithSeg:seg titles:titleDict.allValues currentIndex:0];
    }
    [titleDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [seg setTitle:obj forSegmentAtIndex:key.integerValue];
    }];
    if ( seg.numberOfSegments == 1 ) {
        seg.selectedSegmentIndex = 0;
    }
}

- (void)insertSegmentTitlesWithSeg:(UISegmentedControl *)seg titles:(NSArray<NSString *> *)titles currentIndex:(NSUInteger)index {
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [seg insertSegmentWithTitle:obj atIndex:idx animated:YES];
    }];
    if ( index != UnknownKey ) {
        seg.selectedSegmentIndex = index;
    }
}

- (void)removeSegmentTitlesWithSeg:(UISegmentedControl *)seg indices:(NSArray<NSNumber *> *)indices {
    [indices enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [seg removeSegmentAtIndex:obj.integerValue animated:YES];
    }];
}

- (void)enable:(BOOL)enable segmentControls:(NSArray<UISegmentedControl *> *)segs {
    [segs enumerateObjectsUsingBlock:^(UISegmentedControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setEnabled:enable];
    }];
}

- (void)enable:(BOOL)enable segmentedControl:(UISegmentedControl *)seg indices:(NSArray<NSNumber *> *)indices {
    [indices enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [seg setEnabled:enable forSegmentAtIndex:obj.integerValue];
    }];
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
    
}

@end
