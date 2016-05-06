//
//  HYHotelImageRequest.m
//  Teshehui
//
//  Created by RayXiang on 14-11-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelImageRequest.h"

@implementation HYHotelImageRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kHotelRequestBaseURL, @"api/hotels/hotel_image_list"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.hotelId length] > 0)
    {
        [newDic setObject:self.hotelId forKey:@"hotelId"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店详情请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelImageResponse *respose = [[HYHotelImageResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
