//
//  HYQRCodeGetShopListRequest.m
//  Teshehui
//
//  Created by HYZB on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetShopListRequest.h"

@implementation HYQRCodeGetShopListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/merchant/merchant_list"];
//        self.interfaceURL = [NSString stringWithFormat:@"http://portal.t.teshehui.com/v2/api/merchant/merchant_list"];
        self.httpMethod = @"POST";
        self.pageSize = 20;
        self.postType = JSON;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (_cityName.length > 0)
        {
            [newDic setObject:[NSString stringWithFormat:@"%@", self.cityName]
                       forKey:@"region_name"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNumber]
                   forKey:@"page"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"num_per_page"];
        if (_latitude.length > 0)
        {
            [newDic setObject:_latitude forKey:@"latitude"];
        }
        if (_lontitude)
        {
            [newDic setObject:_lontitude forKey:@"longitude"];
        }
        if ([_merchant_cate_id length] > 0)
        {
            [newDic setObject:self.merchant_cate_id forKey:@"merchant_cate_id"];
        }
        
        if (_sort == 0)
        {
            [newDic setObject:@"1" forKey:@"intelligent"];
        }
        else if (_sort == 1)
        {
            [newDic setObject:@"1" forKey:@"latestPosts"];
        }
        else
        {
            
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYQRCodeGetShopListResponse *respose = [[HYQRCodeGetShopListResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
