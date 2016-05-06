//
//  HYHotelCityListRequest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCityListRequest.h"

@implementation HYHotelCityListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kHotelRequestBaseURL,@"api/hotels/hotel_geo_data_get"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    [newDic setObject:[NSNumber numberWithInteger:self.dataVersion]
               forKey:@"version"];
    
    return newDic;
}

@end
