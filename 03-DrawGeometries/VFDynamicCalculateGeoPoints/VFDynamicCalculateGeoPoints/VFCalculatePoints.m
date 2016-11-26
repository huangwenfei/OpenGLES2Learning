//
//  VFCalculatePoints.m
//  VFDynamicCalculateGeoPoints
//
//  Created by windy on 16/11/26.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFCalculatePoints.h"

#define FilePath      @"/Users/windy/Documents/iOS Projects/OpenGL ES 2.0 Examples For Me/01 Step To Step Draw Triangle/03-DrawGeometries/VFDynamicCalculateGeoPoints/VFDynamicCalculateGeoPoints/Points.h"

typedef union {
    
    struct {
        float x,y,z;
    };
    
    float Position[3]; // { x, y, z }
    
} VFVertex;

static inline VFVertex VFVertexMake(float x, float y, float z) {
    
    VFVertex _ver = {
        x, y, z
    };
    
    return  _ver;
    
}

@implementation VFCalculatePoints

#define RadianByAngle(angle)     ( (angle) / 180.f * M_PI )
#define AngleByRadian(radian)    ( (radian) / M_PI * 180.f )

#define PolarCoordinatesX(radian, radii)    ((radii) * (cos(radian)))
#define PolarCoordinatesY(radian, radii)    ((radii) * (sin(radian)))

/**
 *  计算正几何图形
 *
 *  @param radii 外圆的半径
 *  @param lines 多个几边形边数
 */
- (void)makeRegularVertexPointsReadToFileWithRadii:(CGFloat)radii
                                          geolines:(NSArray<NSNumber *> *)geolines {
    
    NSUInteger i = 0;
    for (NSNumber *num in geolines) {
        
        NSUInteger lines = [num integerValue];
        
        NSArray *points = [self makeRegularVertexPointsWithRadii:radii lines:lines];
        
        if (i == 0) {
            [self buildDatasInFileWithMode:OverrideContent content:points];
        } else {
            [self buildDatasInFileWithMode:AppendContent content:points];
        }
        
        i++;
        
    }
    
}

/**
 *  计算正几何图形
 *
 *  @param radii    外圆的半径
 *  @param lines    几边形
 *  @param offAngle 初始角的偏移角
 */
- (NSArray *)makeRegularVertexPointsWithRadii:(CGFloat)radii
                                        lines:(NSUInteger)lines
                        firstPointOffsetAngle:(CGFloat)offAngle {
    
    CGFloat firstPointAngle;
    if (lines == 4) {
        firstPointAngle = 90.f + 45.f + offAngle;
    } else {
        firstPointAngle = 90.f + offAngle;
    }
    
    CGFloat offsetAngle     = (360.f/lines);
    
    NSMutableArray *points = [NSMutableArray array];
    
    [points addObject:[NSString stringWithFormat:@"static const VFVertex _%ld_Geometry[] = {", lines]];
    
    for (NSUInteger i = 0; i < lines; i++) {
        
        CGFloat radian = RadianByAngle(firstPointAngle + (offsetAngle * i));
        
        CGFloat x = PolarCoordinatesX(radian, radii);
        CGFloat y = PolarCoordinatesY(radian, radii);
        CGFloat z = 0.f;
        
        VFVertex point = VFVertexMake(x, y, z);
        //        [self  logPoint:point];
        [points addObject:[self NSStringWithVFVertex:point]];
        
    }
    
    [points addObject:@"}"];
    
    return points;
    
}

/**
 *  计算正几何图形
 *
 *  @param radii 外圆的半径
 *  @param lines 几边形
 */
- (NSArray *)makeRegularVertexPointsWithRadii:(CGFloat)radii
                                        lines:(NSUInteger)lines {
    
    return [self makeRegularVertexPointsWithRadii:radii
                                            lines:lines
                            firstPointOffsetAngle:0.f];
    
}

/**
 *  计算梯形(它可以制作任意四边形)
 *
 *  @param width     包围梯形的长方形的宽
 *  @param height    包围梯形的长方形的高
 *  @param topOff    上面两个顶点向原点的偏移量
 *  @param bottomOff 下面两个顶点向原点的偏移量
 */
- (NSArray *)makeTrapezoidVertexPointsWithWidth:(CGFloat)width
                                         height:(CGFloat)height
                                      topOffset:(CGPoint)topOff
                                    bottomOffet:(CGPoint)bottomOff {
    
    CGFloat radii = sqrt(pow(width, 2) + pow(height, 2)) / 2.f;
    
    CGFloat acuteAngle = atan(width/height);
    
    NSMutableArray *points = [NSMutableArray array];
    [points addObject:[NSString stringWithFormat:@"static const VFVertex _Trapezoid[] = {"]];
    
    CGFloat X = PolarCoordinatesX(RadianByAngle(acuteAngle), radii);
    CGFloat Y = width/2.f;
    CGFloat Z = 0.f;
    
    VFVertex firstPoint = VFVertexMake(X - topOff.x, Y + topOff.y, Z);
    [points addObject:[self NSStringWithVFVertex:firstPoint]];
    
    VFVertex secondPoint = VFVertexMake(-X + topOff.x, Y + topOff.y, Z);
    [points addObject:[self NSStringWithVFVertex:secondPoint]];
    
    VFVertex thirdPoint = VFVertexMake(-X + bottomOff.x, -Y + bottomOff.y, Z);
    [points addObject:[self NSStringWithVFVertex:thirdPoint]];
    
    VFVertex fourthPoint = VFVertexMake(X - bottomOff.x, -Y + bottomOff.y, Z);
    [points addObject:[self NSStringWithVFVertex:fourthPoint]];
    
    [points addObject:@"}"];
    
    return points;
    
}

/**
 *  计算星形
 *
 *  @param iRadii 内圆的半径
 *  @param oRadii 外圆的半径
 */
- (NSArray *)makeStarVertexPointsWithInnerRadii:(CGFloat)iRadii
                                    outterRadii:(CGFloat)oRadii {
    
    NSUInteger lines = 5;
    CGFloat offAngle = 360 / 5.f / 2.f;
    
    NSArray *innerPoints = [self makeRegularVertexPointsWithRadii:iRadii lines:lines firstPointOffsetAngle:offAngle];
    NSArray *outterPoints = [self makeRegularVertexPointsWithRadii:oRadii lines:lines];
    
    NSMutableArray *points = [NSMutableArray array];
    [points addObject:[NSString stringWithFormat:@"static const VFVertex _Star[] = {"]];
    
    // 去掉起始与结束字符串，因为它们不是数据点 【 1，count - 1 】
    for (NSUInteger i = 1; i < innerPoints.count - 1; i++) {
        [points addObject:outterPoints[i]];
        [points addObject:innerPoints[i]];
    }
    
    [points addObject:@"}"];
    
    return points;
    
}

- (void)logVertexPointsWithPoints:(NSArray *)points {

    NSLog(@"%@", points);
    
}

- (void)buildDatasInFileWithMode:(const char *)mode content:(NSArray *)contentData {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *filePath = FilePath;
    BOOL fileExist = [fm fileExistsAtPath:filePath isDirectory:NULL];
    
    if ( ! fileExist) {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    FILE *fd = fopen([filePath UTF8String], mode);
    
    NSUInteger stringCount = contentData.count;
    for (NSUInteger i = 0; i < stringCount; i++) {
        
        NSString *string = contentData[i];
        
        const char *contents = [string UTF8String];
        NSUInteger contentLength = strlen(contents);
        
        NSUInteger firstString = 0;
        NSUInteger lastString  = stringCount - 1;
        if ( i != firstString && i != lastString ) {
            fwrite("\r\t", 1, 2, fd);
        }
        
        if ( i == lastString ) {
            fwrite("\r", 1, 1, fd);
        }
        
        fwrite(contents, contentLength, 1, fd);
        
        if (i == firstString) { // 开始 “{”
            fwrite("\r\n", 1, 2, fd);
        } else if (i == lastString) { // 结束 “}”
            fwrite(";\r\n", 1, 3, fd);
        } else {    // 中间的数据
            fwrite(",\r\n", 1, 3, fd);
        }
        
    }
    
    fclose(fd);
    
}

#pragma mark - Private

- (void)fileHead {
    
}

- (void)logPoint:(VFVertex)ver {
    
    NSLog(@"%@", [self NSStringWithVFVertex:ver]);
    
}

- (NSString *)NSStringWithVFVertex:(VFVertex)ver {
    
    return [NSString stringWithFormat:@"{%f, %f, %f}", ver.x, ver.y, ver.z];
    
}

@end
