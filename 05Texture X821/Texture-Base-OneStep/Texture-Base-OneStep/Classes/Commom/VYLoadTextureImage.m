//
//  VYLoadTextureImage.m
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/15.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "VYLoadTextureImage.h"

#import <OpenGLES/gltypes.h>
#import <OpenGLES/ES2/gl.h>

@implementation VYLoadTextureImage

#pragma mark - Texture Load Image

- (size_t)aspectSizeWithDataDimension:(size_t)dimension {
    
    size_t failure = 0;
    
    if (dimension <= 0 || (dimension % 2) != 0) {
        return failure;
    }
    
    GLint _2dTextureSize;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &_2dTextureSize);
    
    GLint cubeMapTextureSize;
    glGetIntegerv(GL_MAX_CUBE_MAP_TEXTURE_SIZE, &cubeMapTextureSize);
    
    //    NSLog(@"2D Max Texture Size = %@", @(_2dTextureSize));
    //    NSLog(@"CubeMap Max Texture Size = %@", @(cubeMapTextureSize));
    
    if (dimension > _2dTextureSize) {
        return failure;
    }
    
    if (dimension == _2dTextureSize) {
        return _2dTextureSize;
    }
    
    // [pow(2, 0), _2dTextureSize]
    GLint min = 1;// pow(2, 0)
    
    // _2dTextureSize === cubeMapTextureSize
    size_t aspectSize = min;
    
    GLuint index = 1;
    while (_2dTextureSize / pow(2, index) != min) {
        
        if (dimension > (_2dTextureSize / pow(2, index))) {
            
            aspectSize = (_2dTextureSize / pow(2, index - 1));
            
            break;
            
        }
        
        index++;
        
    }
    
    return aspectSize;
    
}

#define kBitsPerComponent   8

#define kBytesPerPixels     4
#define kBytesPerRow(width)         ((width) * kBytesPerPixels)

- (NSData *)textureDataWithResizedCGImageBytes:(CGImageRef)cgImage
                                      widthPtr:(size_t *)widthPtr
                                     heightPtr:(size_t *)heightPtr {
    
    if (cgImage == nil) {
        NSLog(@"Error: CGImage 不能是 nil ! ");
        return [NSData data];
    }
    
    if (widthPtr == NULL || heightPtr == NULL) {
        NSLog(@"Error: 宽度或高度不能为空。");
        return [NSData data];
    }
    
    size_t originalWidth  = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetHeight(cgImage);
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    size_t width  = [self aspectSizeWithDataDimension:originalWidth];
    size_t height = [self aspectSizeWithDataDimension:originalHeight];
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData *imageData =
    [NSMutableData dataWithLength:height * width * kBytesPerPixels]; // 4 bytes per RGBA pixel
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   width, height,
                                                   kBitsPerComponent,
                                                   kBytesPerRow(width),
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgContext);
    
    *widthPtr  = width;
    *heightPtr = height;
    
    return imageData;
}

- (void)textureDataWithResizedCGImageBytes:(CGImageRef)cgImage
                                completion:(void (^)(NSData *imageData, size_t newWidth, size_t newHeight))completionBlock {
    
    if (cgImage == nil) {
        NSLog(@"Error: CGImage 不能是 nil ! ");
        return;
    }
    
    size_t originalWidth  = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetHeight(cgImage);
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    size_t width  = [self aspectSizeWithDataDimension:originalWidth];
    size_t height = [self aspectSizeWithDataDimension:originalHeight];
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData *imageData =
    [NSMutableData dataWithLength:height * width * kBytesPerPixels]; // 4 bytes per RGBA pixel
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   width, height,
                                                   kBitsPerComponent,
                                                   kBytesPerRow(width),
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgContext);
    
    if (completionBlock) {
        completionBlock(imageData, width, height);
    }
    
}

- (void)textureDatasWithResizedUIImages:(NSArray<UIImage *> *)uiImages
                             completion:(void (^)(NSArray<NSData *> *imageDatas, size_t newWidth, size_t newHeight))completionBlock {
    
    if (uiImages == nil) {
        NSLog(@"Error: UIImage s 不能是 nil ! ");
        return;
    }
    
    // 假设所有的图片宽度、高度是一样的
    size_t originalWidth  = CGImageGetWidth(uiImages.firstObject.CGImage);
    size_t originalHeight = CGImageGetHeight(uiImages.firstObject.CGImage);
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    size_t width  = [self aspectSizeWithDataDimension:originalWidth];
    size_t height = [self aspectSizeWithDataDimension:originalHeight];
    
    size_t drawWidth  = width;
    size_t drawHeight = height * uiImages.count;
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData *imageData =
    [NSMutableData dataWithLength:drawHeight * drawWidth * kBytesPerPixels]; // 4 bytes per RGBA pixel
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   drawWidth, drawHeight,
                                                   kBitsPerComponent,
                                                   kBytesPerRow(drawWidth),
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, drawHeight);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    
    size_t offsetX = 0, offsetY = 0;
    for (UIImage *img in uiImages) {
        
        CGContextDrawImage(cgContext, CGRectMake(offsetX, offsetY, width, height), img.CGImage);
        offsetY += height;
        
    }
    
    CGContextRelease(cgContext);
    
    NSMutableArray *datas = [NSMutableArray array];
    NSUInteger loc = 0;
    NSUInteger len = width * height * kBytesPerPixels;
    for (NSUInteger i = 0; i < uiImages.count; i++) {
        
        NSRange range = NSMakeRange(loc + (i * len), len);
        NSData *subData = [imageData subdataWithRange:range];
        [datas addObject:subData];
    }
    
    if (completionBlock) {
        completionBlock(datas, width, height);
    }
    
}

@end
