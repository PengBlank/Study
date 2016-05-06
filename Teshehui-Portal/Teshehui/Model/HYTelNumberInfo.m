//
//  HYMobileInfo.m
//  Teshehui
//
//  Created by HYZB on 14-10-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYTelNumberInfo.h"

@implementation HYTelNumberInfo

@synthesize desc = _desc;

- (NSString *)desc
{
    if (!_desc)
    {
        switch (self.type)
        {
            case Work:
                _desc = @"工作";
                break;
            case Home:
                _desc = @"住宅";
                break;
            case Fax:
                _desc = @"传真";
                break;
            case Phone:
                _desc = @"手机";
                break;
            case Other:
                _desc = @"其他";
                break;
            default:
                break;
        }
    }
    
    return _desc;
}

- (void)setType:(TelphoneType)type
{
    if (type != _type)
    {
        _type = type;
        _desc = nil;
    }
}
@end
