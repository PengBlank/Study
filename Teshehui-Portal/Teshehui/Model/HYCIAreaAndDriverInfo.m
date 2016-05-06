//
//  HYCIAreaAndDriverInfo.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIAreaAndDriverInfo.h"

@implementation HYCIAreaAndDriverInfo

- (NSString *)checkError
{
    NSString *ret = nil;
    if (self.runAreaFlag)
    {
        if (!self.runAreaInfo)
        {
            ret = @"请指定驾驶区域";
        }
    }
    else if (self.driverFlag && self.isAssignDriver)
    {
        if (self.driverName.length == 0)
        {
            ret = @"请输入驾驶员";
        }
        else if (self.drivateDate.length == 0)
        {
            ret = @"请选择初次领证时间";
        }
        else if (self.driverNum.length == 0)
        {
            ret = @"请输入驾驶证号";
        }
    }
    return ret;
}

@end
