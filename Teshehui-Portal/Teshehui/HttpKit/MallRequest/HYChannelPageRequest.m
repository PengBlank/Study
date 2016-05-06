//
//  HYChannelPageRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelPageRequest.h"

@implementation HYChannelPageRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/index/get_channel_page_by_channel_code.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.0";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.channelCode != nil)
    {
        [data setObject:self.channelCode forKey:@"channelCode"];
    }
    return data;
}

//- (NSMutableDictionary *)getJsonDictionary
//{
//    NSMutableDictionary *newDic = [super getJsonDictionary];
//    if (newDic && (NSNull *)newDic != [NSNull null])
//    {
//        //        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
//        //                   forKey:@"page"];
//        //        [newDic setObject:[NSString stringWithFormat:@"%ld", self.num_per_page]
//        //                   forKey:@"num_per_page"];
//        //        [newDic setObject:@(_refund_type) forKey:@"refund_type"];
//    }
//    
//    return newDic;
//}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYChannelPageResponse *respose = [[HYChannelPageResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
