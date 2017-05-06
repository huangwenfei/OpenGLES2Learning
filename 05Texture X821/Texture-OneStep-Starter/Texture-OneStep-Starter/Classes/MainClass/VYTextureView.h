//
//  VYTextureView.h
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/13.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - VYSwitchKey [Inner Class]

typedef NS_ENUM(uint, VYSquareCubeKey) {
    Square = 0,
    Cube,
};

typedef NS_ENUM(uint, VYTexture2DCubemapKey) {
    Texture2D = 0,
    TextureCubemap,
};

typedef NS_ENUM(uint, VYPixelImageKey) {
    Pixel = 0,
    Image,
};

typedef NS_ENUM(uint, VYElongateConformalKey) {
    Elongate = 0,
    Conformal,
};

typedef NS_ENUM(uint, VYImageSourceKey) {
    ImageSource_32_32 = 0,
    ImageSource_512_512,
    ImageSource_Single_768_512,
    ImageSource_Mutil_768_512,
    ImageSource_Cubemap01_512_512,
    ImageSource_Cubemap02_512_512,
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

@interface VYTextureView : UIView

@property (strong, nonatomic) VYSwitchKey *currentKey;

@end
