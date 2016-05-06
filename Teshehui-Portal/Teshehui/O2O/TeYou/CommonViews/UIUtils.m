//
//  UIUtils.m
//  YYHealth
//
//  Created by xkun on 15/6/10.
//  Copyright (c) 2015年 xkun. All rights reserved.
//


#import "UIUtils.h"
#import "LineView.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
//inline UIColor *colorWithHexAndAlpha(long hexColor, float opacity)
//{
//    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
//    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
//    float blue = ((float)(hexColor & 0xFF))/255.0;
//    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
//}
//
//inline UIColor *colorWithHex(long hexColor)
//{
//    return colorWithHexAndAlpha(hexColor, 1.f);
//}

inline NSString *downCountToWanString(NSInteger count)
{
    //	以 下载/评论 次数范围为判断条件：
    //	1）	当小于1w时，显示具体数字，如 3458次下载/评论；
    //	2）	当大于等于1w小于9.95w时，四舍五入显示小数点后一位数字，如 9.9万次下载/评论；
    //	3）	当大于等于9.95w小于1亿时，四舍五入只显示整数位数字，如 19万次下载/评论；
    //	4）	当大于等于1亿小于9.95亿时，四舍五入显示小数点后一位数字，如 1.9亿次下载/评论；
    //	5）	当大于等于9.95亿时，四舍五入只显示整数位数字，如 19亿次下载/评论。
    
    NSInteger tenThoudand = 10000;
    char buff[128] = {0};
    char unit[10] = {0};
    
    if(count < 1 * tenThoudand)
    {
        //当小于1w时
        
        sprintf(buff, "%f", (double)count);
    }
    else if(count < 9.95 * tenThoudand)
    {
        //当大于等于1w小于9.95w时
        
        sprintf(buff, "%.1f", (double)((double)count/(double)(1 * tenThoudand)));
        strcpy(unit, "万");
    }
    else if(count < 1 * tenThoudand * tenThoudand)
    {
        //当大于等于9.95w小于1亿时
        
        sprintf(buff, "%.0f", (double)((double)count/(double)(1 * tenThoudand)));
        strcpy(unit, "万");
    }
    else if(count < 9.95 * tenThoudand * tenThoudand)
    {
        //当大于等于1亿小于9.95亿时
        
        sprintf(buff, "%.1f", (double)((double)count/(double)(1 * tenThoudand * tenThoudand)));
        strcpy(unit, "亿");
    }
    else
    {
        //当大于等于9.95亿时
        
        sprintf(buff, "%f.0", (double)((double)count/(double)(1 * tenThoudand * tenThoudand)));
        strcpy(unit, "亿");
    }
    
    double dCount = atof(buff);
    sprintf(buff, "%g%s", dCount, unit);
    
    return [NSString stringWithUTF8String:buff];
}


/**
 *  适配5、6、6P~尺寸
 *
 *  @param plist 参数列表，尺寸依次是多少例如(@[@10,@20,@30])
 *
 *  @return 对应浮点数，例如(@[@10,@20,@30])5返回10，6返回20，6P返回30; (@[@10,@20) 5返回10，6和6P返回20; (@[@10])5、6、6P都返回10。
 */
CGFloat g_fitFloat(NSArray *plist)
{
    CGFloat f = 0.0f;
    
    if (plist.count) {
        switch (plist.count) {
            case 1:
            {
                f = [[plist firstObject] floatValue];
            }
                break;
            case 2:
            {
                f = currentDeviceType() == iPhone6  ? [plist[1] floatValue]:[plist[0] floatValue];
                f = currentDeviceType() == iPhone6Plus ? [plist[1] floatValue]:f;
            }
                break;
            case 3:
            {
                f = currentDeviceType() == iPhone6 ? [plist[1] floatValue]:[plist[0] floatValue];
                f = currentDeviceType() == iPhone6Plus ? [plist[2] floatValue]:f;
            }
                break;
            default:
                break;
        }
    }
    
    return f;
}

extern CGFloat g_fitNSInteger(NSArray *plist)
{
    NSInteger value = 0;
    
    if (plist.count) {
        switch (plist.count) {
            case 1:
            {
                value = [[plist firstObject] integerValue];
            }
                break;
            case 2:
            {
                value = currentDeviceType() == iPhone6 ? [plist[1] integerValue]:[plist[0] integerValue];
                value = currentDeviceType() == iPhone6Plus? [plist[1] integerValue]:value;
            }
                break;
            case 3:
            {
                value = currentDeviceType() == iPhone6 ? [plist[1] integerValue]:[plist[0] integerValue];
                value = currentDeviceType() == iPhone6Plus? [plist[2] integerValue]:value;
            }
                break;
            default:
                break;
        }
    }
    
    return value;
}

/**
 *  适配5、6、6P~尺寸
 *
 *  @param plist 参数列表，字体大小依次是多少例如(@[@10,@20,@30])、(@[@10,@20)、(@[@10])
 *
 *  @return 返回对应字体大小,(@[@10,@20,@30])5返回10号字体，6返回20号字体，6P返回30号字体; (@[@10,@20) 5返回10号字体，6和6P返回20号字体; (@[@10])5、6、6P都返回10号字体。
 */
UIFont *g_fitSystemFontSize(NSArray *plist)
{
    return [UIFont systemFontOfSize:g_fitFloat(plist)];
}

/**
 *  用于拉伸的UIImage图 缓存
 */
@interface lineImageCacheKey : NSObject
@property (nonatomic, assign)BOOL isVertical;
@property (nonatomic, assign)BOOL isFirstPixelOpaque;
@property (nonatomic, strong)UIColor *highlightColor;
@property (nonatomic, strong)UIImage *image;
@end

@implementation lineImageCacheKey
@end

/**
 *  圆角蒙版Image 缓存
 */
@interface roundMarkCacheKey : NSObject
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIImage *image;
@end

@implementation roundMarkCacheKey
@end




@implementation UIUtils

+ (BOOL)isPad
{
    static BOOL isPad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    });
    return isPad;
}

+ (BOOL)iPhone6Puls
{
    static BOOL is6Puls;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        is6Puls = kScreen_Width == 414;
    });
    return is6Puls;
}

+ (BOOL)iPhone6
{
    static BOOL iPhone6;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        iPhone6 = kScreen_Width == 375;
    });
    return iPhone6;
}

+ (BOOL)iPhone5
{
    static BOOL iPhone5;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        iPhone5 = kScreen_Width == 320;
    });
    return iPhone5;
}

+ (UIColor *)getColor:(NSString *)hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

//字符串转码成UTF-8
+ (NSString *)stringToUTF8:(NSString *)string
{
    NSString *newString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return newString;
}

+ (NSString *)getVersion
{
    static NSString *versionStr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        versionStr = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    });
    return versionStr;
}

+ (NSString *)timestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu", dTime];
    
    return curTime;
}


+ (UIView *) addLineInView:(UIView *)parentView
                       top:(BOOL)isTop
                leftMargin:(CGFloat)leftMargin
               rightMargin:(CGFloat)rightMargin
{
    LineView *line = [[LineView alloc] initGrayLineWithFrame:CGRectMake(0, 0, parentView.frame.size.width, 1)
                                                            vertical:NO
                                                  isFirstPixelOpaque:isTop];
    [parentView addSubview:line];
    
    __weak UIView *wParent = parentView;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wParent.mas_left).offset(leftMargin);
        make.right.mas_equalTo(wParent.mas_right).offset(-rightMargin);
        make.height.mas_equalTo(@1);
        if (isTop) {
            make.top.mas_equalTo(wParent.mas_top);
        }else{
            make.bottom.mas_equalTo(wParent.mas_bottom);
        }
    }];
    
    return line;
}

+ (UIView *) addLineInView:(UIView *)parentView
                       top:(BOOL)isTop
                     color:(NSString *)color
                leftMargin:(CGFloat)leftMargin
               rightMargin:(CGFloat)rightMargin
{
    LineView *line = [[LineView alloc] initGrayLineWithFrame:CGRectMake(0, 0, parentView.frame.size.width, 1)
                                                    vertical:NO
                                          isFirstPixelOpaque:isTop];
    [line setBackgroundColor:[UIColor colorWithHexString:color]];
    [parentView addSubview:line];
    
    __weak UIView *wParent = parentView;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wParent.mas_left).offset(leftMargin);
        make.right.mas_equalTo(wParent.mas_right).offset(-rightMargin);
        make.height.mas_equalTo(@1);
        if (isTop) {
            make.top.mas_equalTo(wParent.mas_top);
        }else{
            make.bottom.mas_equalTo(wParent.mas_bottom);
        }
    }];
    
    return line;
}

+ (UIImage *)getLineImageWithIsVertical:(BOOL)isVertical
                     isFirstPixelOpaque:(BOOL)isFirstOpaque
                         highlightColor:(UIColor *)highlightColor;
{
    static NSMutableArray *cacheArray = nil;
    
    UIImage *retImage = nil;
    lineImageCacheKey *cacheKey = nil;
    
    if(cacheArray) cacheArray = [NSMutableArray new];
    
    for(lineImageCacheKey *tmp in cacheArray)
    {
        if((tmp.isVertical == isVertical) &&
           (tmp.highlightColor == highlightColor) &&
           (tmp.isFirstPixelOpaque == isFirstOpaque))
        {
            cacheKey = tmp;
            break;
        }
    }
    
    if(!cacheKey)
    {
        CGSize vSize = isVertical?(CGSize){2, 1}:(CGSize){1, 2};
        
        UIGraphicsBeginImageContext(vSize);
        
        //创建路径并获取句柄
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat leftMargin = isVertical&&!isFirstOpaque ? 1:0;
        CGFloat topMargin = !isVertical&&!isFirstOpaque ? 1:0;
        
        //指定矩形
        CGRect rectangle = (CGRect){leftMargin,topMargin, 1, 1};
        
        //将矩形添加到路径中
        CGPathAddRect(path,NULL, rectangle);
        
        //获取上下文
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        //将路径添加到上下文
        CGContextAddPath(currentContext,path);
        
        //设置矩形填充色
        [highlightColor setFill];
        
        //矩形边框颜色
        [[UIColor clearColor] setStroke];
        
        //绘制
        CGContextDrawPath(currentContext,kCGPathFillStroke);
        
        CGPathRelease(path);
        
        retImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cacheKey = [lineImageCacheKey new];
        cacheKey.isVertical = isVertical;
        cacheKey.isFirstPixelOpaque = isFirstOpaque;
        cacheKey.highlightColor = highlightColor;
        cacheKey.image = retImage;
        
        [cacheArray addObject:cacheKey];
    }
    else
    {
        retImage = cacheKey.image;
    }
    
    return retImage;
}

/**
 *  获取圆角蒙版Image 永久保存内存
 *
 *  @param size   大小
 *  @param radius 圆角
 *  @param color  蒙版颜色
 *
 *  @return Image
 */
+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                                  Size:(CGSize)size
                                Radius:(CGFloat)radius
                                 color:(UIColor *)color
                       withStrokeColor:(UIColor *)strokeColor
{
    static NSMutableArray *cacheArray = nil;
    UIImage *retImage =  nil;
    roundMarkCacheKey *cacheKey = nil;
    
    if(!cacheArray) cacheArray = [NSMutableArray new];
    
    for(roundMarkCacheKey *tmp in cacheArray)
    {
        if((CGSizeEqualToSize(tmp.size, size)) &&
           (tmp.radius == radius) &&
           ([tmp.color isEqual:color]))
        {
            cacheKey = tmp;
            break;
        }
    }
    
    if(!cacheKey)
    {
        UIView *roundView = [UIView new];
        roundView.backgroundColor = color;
        [roundView setFrame:(CGRect){0,0,size.width+2, size.height+2}];
        
        retImage = [self getImageFromView:roundView atFrame:(CGRect){0, 0, size}];
        retImage = [self clipRoundImageWithImage:retImage CutOuter:isCutOuter Radius:radius StrokeColor:strokeColor];
        
        cacheKey = [roundMarkCacheKey new];
        cacheKey.size = size;
        cacheKey.radius = radius;
        cacheKey.color = color;
        cacheKey.image = retImage;
        
        [cacheArray addObject:cacheKey];
    }
    else
    {
        retImage = cacheKey.image;
    }
    
    return retImage;
}

/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView View
 *  @param frame   frame
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView atFrame:(CGRect)frame
{
    NSParameterAssert(theView);
    //截取一部分
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //截取
    CGImageRef imageRef = theImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, frame);
    UIGraphicsBeginImageContext(frame.size);
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, frame, subImageRef);
    UIImage* retImage = [UIImage imageWithCGImage:subImageRef];
    
    return retImage;
}

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *
 *  @param orig         原始图片
 *  @param r            半径
 *  @param strokeColor  描边颜色
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor
{
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, origImage.size};
    
    UIBezierPath *clipPath = nil;
    UIBezierPath *roundPath = nil;
    
    if (isCutOuter) {
        clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:r];
        roundPath = clipPath;
    }else{
        clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
        roundPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:r];
        [clipPath appendPath:roundPath];
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        clipPath.usesEvenOddFillRule = YES;
        
        if (!isCutOuter) {
            [UIColor.clearColor setFill];
            [roundPath fill];
        }
        
        if (strokeColor) {
            [roundPath setLineWidth:1.0f];
            [strokeColor set];
            [roundPath stroke];
        }
    }
    [clipPath addClip];
    
    [origImage drawInRect:rect];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}





@end
