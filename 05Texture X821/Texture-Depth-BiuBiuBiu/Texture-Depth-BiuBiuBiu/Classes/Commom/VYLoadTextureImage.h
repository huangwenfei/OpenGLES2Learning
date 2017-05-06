//
//  VYLoadTextureImage.h
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/15.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreGraphics;
@import UIKit;

@interface VYLoadTextureImage : NSObject

- (NSData *)textureDataWithResizedCGImageBytes:(CGImageRef)cgImage
                                      widthPtr:(size_t *)widthPtr
                                     heightPtr:(size_t *)heightPtr;

- (void)textureDataWithResizedCGImageBytes:(CGImageRef)cgImage
                                completion:(void (^)(NSData *imageData, size_t newWidth, size_t newHeight))completionBlock;

- (void)textureDatasWithResizedUIImages:(NSArray<UIImage *> *)uiImages
                             completion:(void (^)(NSArray<NSData *> *imageDatas, size_t newWidth, size_t newHeight))completionBlock;

@end
