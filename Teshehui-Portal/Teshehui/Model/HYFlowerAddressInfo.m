//
//  HYFlowerAdressInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerAddressInfo.h"

@interface HYFlowerAddressInfo ()

@property (nonatomic, copy)NSString *fullAddress;

@end

@implementation HYFlowerAddressInfo

- (NSString *)fullAddress
{
    if (!_fullAddress)
    {
        NSMutableString *address = [[NSMutableString alloc] init];
        if ([self.province.name length] > 0)
        {
            [address appendString:self.province.name];
        }
        
        if ([self.city.name length] > 0)
        {
            [address appendString:self.city.name];
        }
        
        if ([self.area.name length] > 0)
        {
            [address appendString:self.area.name];
        }
        
        if ([self.detaillInfo length] > 0)
        {
            [address appendString:self.detaillInfo];
        }
        
        if ([address length] > 0)
        {
            _fullAddress = [address copy];
        }
    }
    return _fullAddress;
}

@end
