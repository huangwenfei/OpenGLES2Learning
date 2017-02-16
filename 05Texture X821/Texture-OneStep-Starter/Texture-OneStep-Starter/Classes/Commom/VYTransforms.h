//
//  VYTransforms.h
//  Texture-Base-OneStep
//
//  Created by Windy on 2017/2/15.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKMath.h>

//MARK: ModelView
/**
 *  Transform
 */
//GLKVector3 (*PositionVec3Make)(float x, float y, float z) __attribute__((weak, aliaes("GLKVector3Make")));

typedef GLKVector3 (*Vector3Make)(float x, float y, float z);

typedef struct {
    GLKVector3 position;
    GLKVector3 rotation;
    GLKVector3 scale;
}VYSTTransform;

GLK_INLINE VYSTTransform VYSTTransformMake(GLKVector3 posi, GLKVector3 rota, GLKVector3 scal) {
    VYSTTransform sttr = {
        .position = posi,
        .rotation = rota,
        .scale    = scal,
    };
    return sttr;
}

GLK_INLINE GLKMatrix4 VYSTTransformMat4Make(VYSTTransform sttr) {
    
    GLKMatrix4 mat4 = GLKMatrix4Identity;
    
    mat4 = GLKMatrix4Translate(mat4, sttr.position.x, sttr.position.y, sttr.position.z);
    mat4 = GLKMatrix4Rotate(mat4, sttr.rotation.x, 1, 0, 0);
    mat4 = GLKMatrix4Rotate(mat4, sttr.rotation.y, 0, 1, 0);
    mat4 = GLKMatrix4Rotate(mat4, sttr.rotation.z, 0, 0, 1);
    mat4 = GLKMatrix4Scale(mat4, sttr.scale.x, sttr.scale.y, sttr.scale.z);
    
    return mat4;
}

//MARK: Camera
/**
 *  Camera LookAt
 */
typedef struct {
    GLKVector3 eyeVector;
    GLKVector3 centerVector;
    GLKVector3 upVector;
}VYLookAt;

GLK_INLINE VYLookAt VYLookAtMake(GLKVector3 eyeV, GLKVector3 cenV, GLKVector3 upV) {
    VYLookAt look = {
        .eyeVector      = eyeV,
        .centerVector   = cenV,
        .upVector       = upV,
    };
    return look;
}

GLK_INLINE GLKMatrix4 VYLookAtMat4Make(VYLookAt lookAt) {
    return GLKMatrix4MakeLookAt(lookAt.eyeVector.x, lookAt.eyeVector.y, lookAt.eyeVector.z,
                                lookAt.centerVector.x, lookAt.centerVector.y, lookAt.centerVector.z,
                                lookAt.upVector.x, lookAt.upVector.y, lookAt.upVector.z);
}

/**
 *  Camera Perspective
 */
typedef union {
    
    struct  {
        float left, right;
        float top, bottom;
        float nearZ, farZ;
    }frustum;
    
    struct {
        float nearWidth, nearHeight;
        float halfFov;
        float nearZ, farZ;
    }frustumCal;
    
    struct {
        float fov, aspect;
        float nearZ, farZ;
    }perspective;
    
}VYPerspectiveProj;

GLK_INLINE VYPerspectiveProj VYPerspectiveFrustumMake(float l, float r,
                                                      float t, float b,
                                                      float nz, float fz) {
    VYPerspectiveProj fru = {
        .frustum.left   = l,  .frustum.right  = r,
        .frustum.top    = t,  .frustum.bottom = b,
        .frustum.nearZ  = nz, .frustum.farZ   = fz,
    };
    return fru;
}

GLK_INLINE GLKMatrix4 VYPerspectiveFrustumMat4Make(VYPerspectiveProj fru) {
    return GLKMatrix4MakeFrustum(fru.frustum.left, fru.frustum.right,
                                 fru.frustum.bottom, fru.frustum.top,
                                 fru.frustum.nearZ, fru.frustum.farZ);
}

GLK_INLINE VYPerspectiveProj VYPerspectiveFrustumCalMake(float nw, float nh,
                                                         float hfov,
                                                         float nz, float fz) {
    VYPerspectiveProj fru = {
        .frustumCal.nearWidth   = nw,  .frustumCal.nearHeight  = nh,
        .frustumCal.halfFov     = hfov,
        .frustumCal.nearZ       = nz,  .frustumCal.farZ        = fz,
    };
    return fru;
}

GLK_INLINE GLKMatrix4 VYPerspectiveFrustumCalMat4Make(VYPerspectiveProj fruCal) {
    return GLKMatrix4Identity;
}

GLK_INLINE VYPerspectiveProj VYPerspectivePerspectiveMake(float fov,float aspect,
                                                          float nz, float fz) {
    VYPerspectiveProj fru = {
        .perspective.fov    = fov,.perspective.aspect = aspect,
        .perspective.nearZ  = nz, .perspective.farZ   = fz,
    };
    return fru;
}

GLK_INLINE GLKMatrix4 VYPerspectivePerspectiveMat4Make(VYPerspectiveProj pers) {
    return GLKMatrix4MakePerspective(pers.perspective.fov, pers.perspective.aspect,
                                     pers.perspective.nearZ, pers.perspective.farZ);
}

/**
 *  Camera Ortho
 */
typedef struct {
    float left, right;
    float top, bottom;
    float nearZ, farZ;
}VYOrthoProj;

GLK_INLINE VYOrthoProj VYorthoProjMake(float l, float r,
                                       float t, float b,
                                       float nz, float fz) {
    VYOrthoProj orth = {
        .left   = l,  .right  = r,
        .top    = t,  .bottom = b,
        .nearZ  = nz, .farZ   = fz,
    };
    return orth;
}

GLK_INLINE GLKMatrix4 VYorthoProjMat4Make(VYOrthoProj ortho) {
    return GLKMatrix4MakeOrtho(ortho.left, ortho.right,
                               ortho.bottom, ortho.top,
                               ortho.nearZ, ortho.farZ);
}

/**
 *  Camera
 */
typedef struct {
    GLKMatrix4 lookAt;
    GLKMatrix4 projection;
}VYCamera;

GLK_INLINE VYCamera VYCameraMake(GLKMatrix4 look, GLKMatrix4 proj) {
    VYCamera came = {
        .lookAt     = look,
        .projection = proj,
    };
    return  came;
}

typedef NS_ENUM(NSUInteger, VYPerspectiveSwitch) {
    PERSPECT_FRUSTUM = 0,
    PERSPECT_FRUSTUMCAL,
    PERSPECT_PERSPECTIVE,
};

GLK_INLINE GLKMatrix4 VYCameraMat4Make(VYCamera camera) {
    return GLKMatrix4Multiply(camera.lookAt, camera.projection);
}

GLK_INLINE GLKMatrix4 VYCameraPerspectiveMat4Make(VYLookAt lookAt,
                                                  VYPerspectiveProj persProj,
                                                  VYPerspectiveSwitch switchProj) {
    
    GLKMatrix4 lookat = VYLookAtMat4Make(lookAt);
    GLKMatrix4 perspectProj = GLKMatrix4Identity;
    switch (switchProj) {
        case PERSPECT_FRUSTUM:
            perspectProj = VYPerspectiveFrustumMat4Make(persProj);
            break;
        case PERSPECT_FRUSTUMCAL:
            perspectProj = VYPerspectiveFrustumCalMat4Make(persProj);
            break;
        case PERSPECT_PERSPECTIVE:
            perspectProj = VYPerspectivePerspectiveMat4Make(persProj);
            break;
        default:
            
            break;
    }
    
    return GLKMatrix4Multiply(lookat, perspectProj);
    
}

GLK_INLINE GLKMatrix4 VYCameraOrthoMat4Make(VYLookAt lookAt, VYOrthoProj orthoProj) {
    
    GLKMatrix4 lookat = VYLookAtMat4Make(lookAt);
    GLKMatrix4 perspectProj = VYorthoProjMat4Make(orthoProj);
    
    return GLKMatrix4Multiply(lookat, perspectProj);
    
}

//MARK: MVP
/**
 *  Shader MVP
 */
typedef struct {
    GLKMatrix4 modelMat4;
    GLKMatrix4 viewMat4;
    GLKMatrix4 cameraProjMat4;
}VYMVPTransform;

GLK_INLINE VYMVPTransform VYMVPTransformMake(GLKMatrix4 model, GLKMatrix4 view, GLKMatrix4 cameraProj) {
    VYMVPTransform mvp = {
        .modelMat4      = model,
        .viewMat4       = view,
        .cameraProjMat4 = cameraProj,
    };
    return mvp;
}

GLK_INLINE GLKMatrix4 VYMVPTransformModelViewMat4Make(VYMVPTransform mvp) {
    GLKMatrix4 modelViewMat4 = GLKMatrix4Multiply(mvp.modelMat4, mvp.viewMat4);
    return modelViewMat4;
}

GLK_INLINE GLKMatrix4 VYMVPTransformMat4Make(VYMVPTransform mvp) {
    GLKMatrix4 modelViewMat4 = GLKMatrix4Multiply(mvp.modelMat4, mvp.viewMat4);
    GLKMatrix4 mvpMat4 = GLKMatrix4Multiply(modelViewMat4, mvp.cameraProjMat4);
    return mvpMat4;
}

@interface VYTransforms : NSObject

/**
 *  指向 GLKVector3Make 的函数指针
 */
@property (assign, nonatomic) Vector3Make PositionVec3Make, RotationVec3Make, ScalingVec3Make;
/**
 *  指向 GLKVector3Make 的函数指针
 */
@property (assign, nonatomic) Vector3Make EyeVec3Make, CenterVec3Make, UpVec3Make;

/**
 *  Ascept Layer Radio
 */
@property (assign, nonatomic) float aspectRadio;

/**
 *  Model + View + Camera
 */
@property (assign, nonatomic) GLKMatrix4     mvpTransformMat4;
@property (assign, nonatomic) VYMVPTransform mvpTransfrom;

/**
 *  模型变换
 */
@property (assign, nonatomic) GLKMatrix4    modelTransformMat4;
@property (assign, nonatomic) VYSTTransform modelTransform;
/**
 *  视变换
 */
@property (assign, nonatomic) GLKMatrix4    viewTransformMat4;
@property (assign, nonatomic) VYSTTransform viewTransform;

/**
 *  投影变换
 */
@property (assign, nonatomic) GLKMatrix4        baseCameraMat4;
@property (assign, nonatomic) VYCamera          baseCamera;

@property (assign, nonatomic) GLKMatrix4        lookAtMat4;
@property (assign, nonatomic) VYLookAt          lookAt;
@property (assign, nonatomic) GLKMatrix4        perspectiveProjMat4;
@property (assign, nonatomic) VYPerspectiveProj perspectiveProj;
@property (assign, nonatomic) GLKMatrix4        orthoProjMat4;
@property (assign, nonatomic) VYOrthoProj       orthoProj;

/**
 *  释放所有的【 GLKVector3Make 】函数指针
 */
- (void)releaseAllVec3MakeFunPtr;

@end

