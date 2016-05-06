//
//  HYGetFlightDetailReq.m
//  Teshehui
//
//  Created by HYZB on 15/5/29.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYGetFlightDetailReq.h"
#import "JSONKit_HY.h"

@implementation HYGetFlightDetailResp

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.flightInfo = [[HYFlightDetailInfo alloc] initWithDictionary:data];
    }
    
    return self;
}

@end

@implementation HYGetFlightDetailReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/getProductInfo.action"];
        self.httpMethod = @"POST";
        self.businessType = @"02";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.productId length] > 0)
        {
            [newDic setObject:self.productId forKey:@"productId"];
        }
        
        //机票详情相关的扩展请求参数
        NSMutableDictionary *expandedRequest = [NSMutableDictionary dictionary];
        
        if ([self.startCityId length] > 0)
        {
            [expandedRequest setObject:self.startCityId forKey:@"startCityId"];
        }
        if ([self.endCityId length] > 0)
        {
            [expandedRequest setObject:self.endCityId forKey:@"endCityId"];
        }
        if ([self.flightDate length] > 0)
        {
            [expandedRequest setObject:self.flightDate forKey:@"flightDate"];
        }
        if ([self.isSupportChild length] > 0)
        {
            [expandedRequest setObject:self.isSupportChild forKey:@"isSupportChild"];
        }
        
        if ([self.cabinType count] > 0)
        {
            [expandedRequest setObject:self.cabinType
                                forKey:@"cabinType"];
        }
        
        if ([expandedRequest count] > 0)
        {
            NSString *expand = [expandedRequest JSONString];
            [newDic setObject:expand forKey:@"expandedRequest"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetFlightDetailResp *respose = [[HYGetFlightDetailResp alloc]initWithJsonDictionary:info];
    return respose;
}

@end
