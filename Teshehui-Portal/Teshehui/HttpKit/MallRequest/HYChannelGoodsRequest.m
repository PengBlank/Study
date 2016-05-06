//
//  HYChannelGoodsRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelGoodsRequest.h"

@implementation HYChannelGoodsRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/index/get_channel_goods_page_list.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
        self.version = @"1.0.0";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (self.cateCode != nil)
    {
        [data setObject:self.cateCode forKey:@"channelCode"];
    }
    [data setObject:@(_page) forKey:@"pageNum"];
    [data setObject:@(_pageSize) forKey:@"pageSize"];
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
    HYChannelGoodsResponse *respose = [[HYChannelGoodsResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
