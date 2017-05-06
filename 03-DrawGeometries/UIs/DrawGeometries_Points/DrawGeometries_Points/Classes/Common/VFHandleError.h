//
//  VFHandleError.h
//  DrawGeometries_Lines
//
//  Created by windy on 16/11/06.
//  Copyright © 2016年 windy. All rights reserved.
//

#ifndef VFHandleError_h
#define VFHandleError_h

#pragma mark - Error Types

/* Render Buffer Error */
static void const * VFError_RBO_Identifier_Type                 = &VFError_RBO_Identifier_Type;

/* Frame Buffer Error */
static void const * VFError_FBO_Identifier_Type                 = &VFError_FBO_Identifier_Type;

/* File Error */
static void const * VFError_GLSL_FileName_Type                  = &VFError_GLSL_FileName_Type;
static void const * VFError_GLSL_File_Non_Exsit_Type            = &VFError_GLSL_File_Non_Exsit_Type;

/* Shader Error */
static void const * VFError_VertexShader_Identifier_Type        = &VFError_VertexShader_Identifier_Type;
static void const * VFError_FragmentShader_Identifier_Type      = &VFError_FragmentShader_Identifier_Type;

/* Shader Program Error */
static void const * VFError_ShaderProgram_Identifier_Type       = &VFError_ShaderProgram_Identifier_Type;
static void const * VFError_ShaderProgram_Link_Type             = &VFError_ShaderProgram_Link_Type;

/* Vertex Data */
static void const * VFError_VBO_Identifier_Type                 = &VFError_VBO_Identifier_Type;

// Error Notification
static NSString * VFErrorHandleNotificationName = @"ErrorHandleNotificationName";

#pragma mark - Error OPs

static inline BOOL _isEqual (void const * errorType1, void const * errorType2) {

    return (errorType1 == errorType2);

}

@protocol OpenELESErrorHandle <NSObject>

- (void)errorHandleWithType:(void const *)errorType;
- (void)postReleaseSourceNotification;

@end

@protocol OpenELESErrorHandleNotification <NSObject>

- (void)addReleaseSourceNotification;
- (void)removeReleaseSourceNotification;

- (void)releaseSourceCallBack:(NSNotification *)info;

@end

#endif /* VFHandleError_h */
