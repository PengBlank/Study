//
//  HYScreenTransformHeader.h
//  Teshehui
//
//  Created by HYZB on 2014/12/29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 屏幕适配的转换
 */

#import <UIKit/UIKit.h>

#ifndef Teshehui_HYScreenTransformHeader_h
#define Teshehui_HYScreenTransformHeader_h

#define ScreenRect [[UIScreen mainScreen] bounds]

typedef enum _DeviceType
{
    iPhone4_4S  = 10001,
    iPhone5_5S = 10002,
    iPhone6 = 10003,
    iPhone6Plus = 10004,
}DeviceType;

CG_INLINE DeviceType currentDeviceType() {
    CGRect mainFrme = [[UIScreen mainScreen] bounds];
    if (mainFrme.size.height > 667)
    {
        return iPhone6Plus;
    }
    else if (mainFrme.size.height > 568)
    {
        return iPhone6;
    }
    else if (mainFrme.size.height > 480)
    {
        return iPhone5_5S;
    }
    return iPhone4_4S;
}


CG_INLINE CGFloat TFScalePoint(CGFloat x) {
    if (x != 0)
    {
        CGRect mainFrme = [[UIScreen mainScreen] bounds];
        CGFloat scale = mainFrme.size.width/320;
        return x*scale;
    }
    
    return x;
}

CG_INLINE CGRect TFRectMakeFixWidth(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = TFScalePoint(x);
    rect.origin.y = y;
    rect.size.width = TFScalePoint(width);
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect TFRectMakeFixHeight(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = TFScalePoint(y);
    rect.size.width = width;
    rect.size.height = TFScalePoint(height);
    return rect;
}

CG_INLINE CGRect TFRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = TFScalePoint(x);
    rect.origin.y = TFScalePoint(y);
    rect.size.width = TFScalePoint(width);
    rect.size.height = TFScalePoint(height);
    return rect;
}

CG_INLINE CGRect TFREctMakeWithRect(CGRect nrect)
{
    CGRect rect;
    rect.origin.x = TFScalePoint(nrect.origin.x);
    rect.origin.y = TFScalePoint(nrect.origin.y);
    rect.size.width = TFScalePoint(nrect.size.width);
    rect.size.height = TFScalePoint(nrect.size.height);
    return rect;
}

#endif
