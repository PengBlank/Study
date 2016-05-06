//
//  HYMallLogisticsInfo.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallLogisticsInfo.h"

@implementation HYTrackInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.msg = GETOBJECTFORKEY(data, @"context", [NSString class]);
        self.time = GETOBJECTFORKEY(data, @"time", [NSString class]);
    }
    
    return self;
}


@end

@implementation HYMallLogisticsInfo

/*
- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        HYAddressInfo *add = [[HYAddressInfo alloc] initWithDataInfo:data];
        self.address = add;
        
        NSArray *trackList = GETOBJECTFORKEY(data, @"data", [NSArray class]);
        
        NSMutableArray *muTempArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *obj in trackList)
        {
            HYTrackInfo *t = [[HYTrackInfo alloc] initWithDataInfo:obj];
            [muTempArray addObject:t];
        }
        
        self.trackList = [muTempArray copy];
    }
    
    return self;
}
*/

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expressItemPOList": @"trackList"}];
}

@end

/*
 "data": {
 "express_num": "580070084598",
 "express_company": "天天快递",
 "data": [
 {
 "time": "2014-01-07 16:08:28",
 "context": "已签收,签收人是【本人】"
 },
 {
 "time": "2014-01-07 16:08:28",
 "context": "已签收,签收人是【罗世吉】"
 },
 {
 "time": "2014-01-07 09:18:29",
 "context": "【深圳八卦岭( 075525157244，25847726)】的派件员【罗世吉】正在派件"
 }
 ],
 "order_sn": "BB2S4504710906",
 "consignee": "高武",
 "region_name": "中国\t天津市\t河北区",
 "address": "衡阳祁东",
 "zipcode": "421600",
 "phone_tel": "13113178211",
 "phone_mob": "13113178211",
 "shipping_name": "包邮",
 "shipping_fee": "0.00"
 }
 */
