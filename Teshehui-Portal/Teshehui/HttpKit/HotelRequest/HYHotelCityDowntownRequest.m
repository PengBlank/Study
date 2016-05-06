//
//  HYHotelCityDowntownRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCityDowntownRequest.h"

@implementation HYHotelCityDowntownRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL,kHotelRequestBaseURL, @"json/zones/get_list/"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

@end
