//
//  HYHotelCommentReuqest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCommentReuqest.h"
#import "HYHotelCommentResponse.h"

@implementation HYHotelCommentReuqest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL,kHotelRequestBaseURL, @"json/hotels/get_hotel_comment/"];
        self.httpMethod = @"POST";
        _num_per_page = 10;
        _page = 1;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.HotelID length] > 0)
    {
        [newDic setObject:self.HotelID forKey:@"HotelID"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.num_per_page]
                   forKey:@"num_per_page"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
                   forKey:@"page"];
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店评价列表请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelCommentResponse *respose = [[HYHotelCommentResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
