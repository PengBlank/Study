//
//  HYGetGroupOrderListReq.m
//  Teshehui
//
//  Created by HYZB on 2014/12/17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetGroupOrderListReq.h"

@implementation HYGetGroupOrderListReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"meituan/orderList.action"];
        self.httpMethod = @"POST";
        self.pageSize = 10;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.thirdOrderId length] > 0) {
            [newDic setObject:self.thirdOrderId forKey:@"thirdOrderId"];
        }
        
        if ([self.orderId length] > 0) {
            [newDic setObject:self.orderId forKey:@"orderId"];
        }
        
        if ([self.buyerId length ]> 0) {
            [newDic setObject:self.buyerId forKey:@"buyerId"];
        }
        
        if ([self.orderType length ]> 0) {
            [newDic setObject:self.orderType forKey:@"orderType"];
        }
        if ([self.orderStatus length ]> 0) {
            [newDic setObject:self.orderStatus forKey:@"orderStatus"];
        }
        if ([self.startTime length ]> 0) {
            [newDic setObject:self.startTime forKey:@"startTime"];
        }
        if ([self.endTime length ]> 0) {
            [newDic setObject:self.endTime forKey:@"endTime"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.page]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetGroupOrderListResq *respose = [[HYGetGroupOrderListResq alloc]initWithJsonDictionary:info];
    return respose;
}

@end


@implementation HYGetGroupOrderListResq

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if ([data count] > 0)
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (id obj in data)
            {
                HYGroupOrderInfo *g = [[HYGroupOrderInfo alloc] initWithDataInfo:obj];
                [tempArray addObject:g];
            }
            
            self.orderList = [tempArray copy];
        }
    }
    
    return self;
}

@end
