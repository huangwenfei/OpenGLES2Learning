//
//  VYTextureView.h
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/13.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - VYSwitchKey [Inner Class]

#define UnknownKey -1

typedef NS_ENUM(int, VYSquareCubeKey) {
    SC_UnKnown = -1,
    Square = 0,
    Cube,
};

typedef NS_ENUM(int, VYTexture2DCubemapKey) {
    _2C_UnKnown = -1,
    Texture2D = 0,
    TextureCubemap,
};

typedef NS_ENUM(int, VYPixelImageKey) {
    PI_UnKnown = -1,
    Pixel = 0,
    Image,
};

typedef NS_ENUM(int, VYElongateConformalKey) {
    EC_UnKnown = -1,
    Elongate_UD = 0,
    Elongate_DD,
    Conformal,
};

typedef NS_ENUM(int, VYImageSourceKey) {
    IS_UnKnown = -1,
    ImageSource_512_512 = 0,        // Conformal
    ImageSource_128_128,            // Conformal
    ImageSource_Single_768_512_01,  // Elong_UD
    ImageSource_Single_768_512_02,  // Elong_UD
    ImageSource_Mutil_768_512_01,   // Elong_DD
    ImageSource_Cubemap_512_512s,   // Cubemap
    ImageSource_Cubemap_HDR01,      // Cubemap HDR
};

@interface VYSwitchKey : NSObject

@property (assign, nonatomic) VYSquareCubeKey           squareCubeSwitch;
@property (assign, nonatomic) VYTexture2DCubemapKey     tex2DCubeMapSwitch;
@property (assign, nonatomic) VYPixelImageKey           pixelsImageSwitch;
@property (assign, nonatomic) VYElongateConformalKey    elongatedConformalSwitch;
@property (assign, nonatomic) VYImageSourceKey          imageSourceSwitch;

- (instancetype)initWithSquareCube:(VYSquareCubeKey)squareCube
                      tex2DCubeMap:(VYTexture2DCubemapKey)tex2DCubeMap
                       pixelsImage:(VYPixelImageKey)pixelsImage
                elongatedConformal:(VYElongateConformalKey)elongatedConformal
                       imageSource:(VYImageSourceKey)imageSource;

@end

#pragma mark - VYTextureView

#import "VYDisplayLoop.h"

typedef void (^UpdateUIsBlock)(void);

@protocol VYTextureViewDelegate <NSObject>

- (void)realTimeUpdateContents;

@end

@interface VYTextureView : UIView

@property (weak  , nonatomic) id<VYTextureViewDelegate> delegate;
@property (strong, nonatomic) VYSwitchKey *currentKey;
@property (strong, nonatomic) VYDisplayLoop *displayLoop;

- (void)update;
- (void)pauseUpdate;

@end
