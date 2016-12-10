//
//  VFBezierCurve.m
//  VFDynamicCalculateGeoPoints
//
//  Created by windy on 16/11/27.
//  Copyright © 2016年 windy. All rights reserved.
//

#import "VFBezierCurve.h"

typedef NS_ENUM(NSUInteger, VFQuadrant) {
    
    VFQuadrant_Origin = 0,
    VFQuadrant_1th    = 1,  // {+x, +y}
    VFQuadrant_2th,         // {-x, +y}
    VFQuadrant_3th,         // {-x, -y}
    VFQuadrant_4th,         // {+x, -y}
    
};

@implementation VFBezierCurve

#define DEFAULT_PRECISION   (_Precision(50))

- (NSArray *)makeMountainPoints:(const VFVertex *)points segmentPointsCount:(uint)count segments:(uint)segments {
    
    NSMutableArray *BEZPoints = [NSMutableArray array];
    
    VFVertex segmentPoints[count];
    uint index = 0;
    for (uint seg = 0; seg < segments; seg++) {
        
        uint endIndex = (count - 1) * (1 + seg);
        for ( ; index <= endIndex; index++ ) {
            uint segIndex = endIndex > (count - 1) ? (index - (count - 1) * seg) : index;
            segmentPoints[segIndex] = points[index];
        }
        index--;
        
        NSArray *segPoints = [self BEZ3DPointBuildWithPoints:segmentPoints
                                                 pointsCount:count
                                                   precision:DEFAULT_PRECISION];
        [BEZPoints addObjectsFromArray:segPoints];
        
    }
    
    return BEZPoints;
}

- (NSArray *)makeRoundPointsWithRadii:(float)radii originPoint:(CGPoint)originPoint {
    
    return [self makeRoundPointsWithRadiis:CGPointMake(radii, radii) originPoint:originPoint];
    
}

- (NSArray *)makeOvalPointsWithRadiiX:(float)radiiX radiiY:(float)radiiY originPoint:(CGPoint)originPoint {
    
    return [self makeRoundPointsWithRadiis:CGPointMake(radiiX, radiiY) originPoint:originPoint];
    
}

- (NSArray *)makeRoundPointsWithRadiis:(CGPoint)radiis originPoint:(CGPoint)originPoint {
    
    if (radiis.x == 0 || radiis.y == 0 ) { return nil; }
    
    float mNumberX = 0.551784 * radiis.x;
    float mNumberY = 0.551784 * radiis.y;
    
    VFVertex pointA = VFVertexMake(originPoint.x - radiis.x, originPoint.y, 0.0);
    VFVertex pointControl1 = VFVertexMake(originPoint.x - radiis.x, originPoint.y + mNumberY, 0.0);
    VFVertex pointControl2 = VFVertexMake(originPoint.x - mNumberX, originPoint.y + radiis.y, 0.0);
    VFVertex pointB = VFVertexMake(originPoint.x, originPoint.y + radiis.y, 0.0);
    
    uint pointsCount = 4;
    VFVertex points[] = { pointA, pointControl1, pointControl2, pointB };
    
    NSMutableArray *BEZRoundPoints = [NSMutableArray array];
    
    NSArray *_2th_Quadrant_BEZPoints = [self BEZ3DPointBuildWithPoints:points
                                                           pointsCount:pointsCount
                                                             precision:DEFAULT_PRECISION];
    [BEZRoundPoints addObjectsFromArray:_2th_Quadrant_BEZPoints];
    
    NSArray *_1th_Quadrant_BEZPoints = [self quadrantPoints:_2th_Quadrant_BEZPoints
                                                 inQuadrant:VFQuadrant_2th
                                                outQuadrant:VFQuadrant_1th];
    [BEZRoundPoints addObjectsFromArray:_1th_Quadrant_BEZPoints];
    
    NSArray *_4th_Quadrant_BEZPoints = [self quadrantPoints:_2th_Quadrant_BEZPoints
                                                 inQuadrant:VFQuadrant_2th
                                                outQuadrant:VFQuadrant_4th];
    [BEZRoundPoints addObjectsFromArray:_4th_Quadrant_BEZPoints];
    
    NSArray *_3th_Quadrant_BEZPoints = [self quadrantPoints:_2th_Quadrant_BEZPoints
                                                 inQuadrant:VFQuadrant_2th
                                                outQuadrant:VFQuadrant_3th];
    [BEZRoundPoints addObjectsFromArray:_3th_Quadrant_BEZPoints];
    
    return BEZRoundPoints;
    
}

#pragma mark - Quadrant Points Rotate

- (NSArray *)quadrantPoints:(NSArray *)inQuadrantPoints inQuadrant:(VFQuadrant)inQua outQuadrant:(VFQuadrant)outQua {
    
    NSArray *outQuaPoints = [NSArray array];
    
    // "_" 表示从什么象限到什么象限
    // 沿 X : 1_4 = 5, 2_3 = 5, 3_2 = 5, 4_1 = 5 -> (1, -1) reverse
    // 沿 Y : 1_2 = 3, 2_1 = 3, 3_4 = 7, 4_3 = 7 -> (-1, 1) reverse
    // 沿 原点 中心对称 : 1_3 = 4, 2_4 = 6, 3_1 = 4, 4_2 = 6 -> (-1, -1)
    
    int xRotate = 5;
    int yRotate_1 = 3, yRotate_2 = 7;
    int originRotate_1 = 4, originRotate_2 = 6;
    
    int quaCombiantor = inQua + outQua;
    
    if (quaCombiantor == xRotate) {
        outQuaPoints = [self quadrantPoints:inQuadrantPoints xFlag:1 yFlag:-1 reverse:YES];  // 沿 X 翻转
    }
    
    if (quaCombiantor == yRotate_1 || quaCombiantor == yRotate_2) {
        outQuaPoints = [self quadrantPoints:inQuadrantPoints xFlag:-1 yFlag:1 reverse:YES];  // 沿 Y 翻转
    }
    
    if (quaCombiantor == originRotate_1 || quaCombiantor == originRotate_2) {
        outQuaPoints = [self quadrantPoints:inQuadrantPoints xFlag:-1 yFlag:-1 reverse:NO];  // 沿 原点 中心对称
    }

    return outQuaPoints;
    
}

- (NSArray *)quadrantPoints:(NSArray *)quadrantPoints xFlag:(int)xFlag yFlag:(int)yFlag reverse:(BOOL)reverse {

    NSMutableArray *outQuaPoints = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < quadrantPoints.count; i++) {
        
        NSUInteger index = reverse ? (quadrantPoints.count - 1 - i) : i;
        NSValue *pointV  = quadrantPoints[index];
        
        VFVertex point;
        [self valueToBEZ3DPoint:pointV storedPoint:&point];
        
        VFVertex outPoint = VFVertexMake(point.x * xFlag, point.y * yFlag, point.z);
        [outQuaPoints addObject:[self BEZ3DPointToValue:&outPoint]];
        
    }
    
    return outQuaPoints;
    
}

/**
 *  生成平均分布的线
 */
- (NSArray *)makeLinesWithRect:(CGRect)rect lines:(NSUInteger)lines firstLineW:(CGFloat)fW offsetPoint:(CGPoint)offsetP bottomH:(CGFloat)bottomH {
    
    NSMutableArray<NSValue *> *linePoints = [NSMutableArray array];
    
    CGFloat space = (rect.size.height - offsetP.y - bottomH) / lines;
    CGPoint topLeftPoint = rect.origin;
    
    VFVertex firstLineLeftPoint  = VFVertexMake(topLeftPoint.x + offsetP.x, topLeftPoint.y - offsetP.y - space, 0.0);
    VFVertex firstLineRightPoint = VFVertexMake(firstLineLeftPoint.x + fW, firstLineLeftPoint.y, 0.0);
    
    [linePoints addObject:[self BEZ3DPointToValue:&firstLineLeftPoint]];
    [linePoints addObject:[self BEZ3DPointToValue:&firstLineRightPoint]];
    
    CGFloat lineWidth = rect.size.width - offsetP.x * 2.0;
    for (NSUInteger i = 1; i < lines; i++) {
        
        CGFloat lx, ly;
        CGFloat rx, ry;
        CGFloat z = 0.0;
        
        lx = firstLineLeftPoint.x;
        ly = firstLineLeftPoint.y - space * i;
        
        rx = lx + lineWidth;
        ry = ly;
        
        VFVertex lineLeftPoint  = VFVertexMake(lx, ly, z);
        VFVertex lineRightPoint = VFVertexMake(rx, ry, z);
        
        [linePoints addObject:[self BEZ3DPointToValue:&lineLeftPoint]];
        [linePoints addObject:[self BEZ3DPointToValue:&lineRightPoint]];
        
    }
    
    return linePoints;
    
}

#pragma mark - Beizer Curve Methods

/**
 *  把 VFVertex 点封装成 NSValue 对象
 */
- (NSValue *)BEZ3DPointToValue:(VFVertex *)point {
    return [NSValue valueWithBytes:point objCType:@encode(VFVertex)];
}

/**
 *  把 VFVertex 点从 NSValue 对象中提取出来
 */
- (void)valueToBEZ3DPoint:(NSValue *)point storedPoint:(VFVertex *)storedPoint {
    [point getValue:storedPoint];
}

/**
 *  生成 BEZ 曲线的所有点
 *
 *  @param Points    所有的点（包括起点、终点、以及所有控制点）
 *  @param count     点的数量
 *  @param precision 精度
 *
 */
- (NSArray<NSValue *> *)BEZ3DPointBuildWithPoints:(VFVertex *)Points pointsCount:(uint)count precision:(long double)precision {

    uint factorialNumber = count - 1;
    long double stepNumber      = precision;
    
    NSMutableArray<NSValue *> *BEZPoints = [NSMutableArray array];
    
    VFVertex firstPoint = Points[0];
    [BEZPoints addObject:[self BEZ3DPointToValue:&firstPoint]];
    
    long double lastT  = 0.0;
    long double startT = 0.0 + stepNumber;
    long double endT   = 1.0;
    for (long double t = startT; t <= endT; t += stepNumber) {
        lastT = t;
        VFVertex BEZPoint = BEZ3DPoint(Points, factorialNumber, t);
//        NSLog(@"BEZ3DPointBuildWithPoints ---> BEZPoint %@", [self NSStringWithVFVertex:BEZPoint]);
        [BEZPoints addObject:[self BEZ3DPointToValue:&BEZPoint]];
    }
    
    if (floor(lastT) != floor(endT)) {
        VFVertex lastPoint = Points[count - 1];
        [BEZPoints addObject:[self BEZ3DPointToValue:&lastPoint]];
    }
    
    return BEZPoints;
    
}

/**
 *  生成 BEZ 点
 *
 *  @param points          所有的点（包括起点、终点、以及所有控制点）
 *  @param factorialNumber 阶数（ n 几次贝塞尔）
 *  @param stepNumber      步进值 (也就是精度)
 *
 */
VFVertex BEZ3DPoint(VFVertex *points, uint factorialNumber, long double stepNumber) {
    
    long double X = 0.0, Y = 0.0, Z = 0.0;
    
    for (uint k = 0; k <= factorialNumber; k++) {
        
        X += BEZ(points[k].x, factorialNumber, k, stepNumber);
        Y += BEZ(points[k].y, factorialNumber, k, stepNumber);
        Z += BEZ(points[k].z, factorialNumber, k, stepNumber);
        
        if (X > 1) { X = 1.0; }
        if (Y > 1) { Y = 1.0; }
        if (Z > 1) { Z = 1.0; }
        
    }
    
    return VFVertexMake(X, Y, Z);
    
}

/**
 *  计算贝塞尔曲线的值（贝塞尔多项式与坐标分量的乘积）
 *
 *  @param pointComponent  坐标分量 (x/y/z)
 *  @param factorialNumber 阶数（ n 几次贝塞尔）
 *  @param termsNumber     项数（即 k = [0, n]）
 *  @param stepNumber      步进值 (也就是精度)
 *
 */
long double BEZ(long double pointComponent, uint factorialNumber, uint termsNumber, long double stepNumber) {
    
    return (pointComponent                                          *
            combinatorialNumber(factorialNumber, termsNumber)       *
            pow(stepNumber, termsNumber)                            *
            pow((1 - stepNumber), (factorialNumber - termsNumber)));
    
}

/**
 *  计算组合数（ 概率统计里面所指的组合数 C(n, m) ）结果
 *
 *  @param n 总数
 *  @param m 所取个数
 *
 */
long double combinatorialNumber(uint n, uint m) {
    
    return ((long double)factorial(n) / (factorial(m) * factorial(n - m)) );
    
}

/**
 *  计算阶乘
 *
 *  @param n 阶数
 *
 */
long int factorial(int n) {
    
    if (n == 0) { return 1; }
    
    long int result = 1;
    
    for (uint i = 1; i <= n; i++) {
        
        result = result * i;
        
    }
    
    return result;
    
}

/**
 *  VFVertex Value 数组转换成 VFVertex 字符串数组
 */
- (NSArray<NSString *> *)BEZ3DPointsToFormatStringPoint:(NSArray<NSValue *> *)BEZPoints headName:(NSString *)name {
    
    NSMutableArray<NSString *> *BEZStringPoints = [NSMutableArray array];
    [BEZStringPoints addObject:[NSString stringWithFormat:@"#pragma mark - %@[]", name]];
    [BEZStringPoints addObject:[NSString stringWithFormat:@"static const VFVertex %@[] = {", name]];
    
    for (NSValue *point in BEZPoints) {
        VFVertex BEZPoint;
        [self valueToBEZ3DPoint:point storedPoint:&BEZPoint];
        [BEZStringPoints addObject:[self NSStringWithVFVertex:BEZPoint]];
    }
    
    
    [BEZStringPoints addObject:@"}"];
    
    return BEZStringPoints;
    
}

#pragma mark - File Method

#define FilePath      @"/Users/windy/Documents/iOS Projects/OpenGL ES 2.0 Examples For Me/01 Step To Step Draw Triangle/03-DrawGeometries/VFDynamicCalculateGeoPoints/VFDynamicCalculateGeoPoints/BEZ3DPoints.h"

- (void)buildDatasInFileWithMode:(const char *)mode content:(NSArray<NSString *> *)contentData {
    
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
        if ( i != firstString && i != firstString + 1 && i != lastString ) {
            fwrite("\r\t", 1, 2, fd);
        }
        
        if ( i == lastString ) {
            fwrite("\r", 1, 1, fd);
        }
        
        fwrite(contents, contentLength, 1, fd);
        
        if (i == firstString || i == firstString + 1) { // 开始 “{”
            fwrite("\r\n", 1, 2, fd);
        } else if (i == lastString) { // 结束 “}”
            fwrite(";\r\n", 1, 3, fd);
        } else {    // 中间的数据
            fwrite(",\r\n", 1, 3, fd);
        }
        
    }
    
    fclose(fd);
    
}


- (NSString *)NSStringWithVFVertex:(VFVertex)ver {
    
    return [NSString stringWithFormat:@"{%f, %f, %f}", ver.x, ver.y, ver.z];
    
}

@end
