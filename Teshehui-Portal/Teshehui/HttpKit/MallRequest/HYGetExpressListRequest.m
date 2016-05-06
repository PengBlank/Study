//
//  HYGetExpressListRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetExpressListRequest.h"
#import "HYUserInfo.h"
#import "JSONKit_HY.h"

@implementation HYGetExpressListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"delivery/queryStoreProductDelivery.action"];
        self.httpMethod = @"POST";
        self.businessType = BusinessType_Mall;
        _getAllExpressList = NO;
    }
    
    return self;
}

#pragma mark setter/getter
- (void)setGetAllExpressList:(BOOL)getAllExpressList
{
    if (getAllExpressList != _getAllExpressList)
    {
        _getAllExpressList = getAllExpressList;
        
        if (getAllExpressList)
        {
            self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/expresses"];
        }
        else
        {
            self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"delivery/queryStoreProductDelivery.action"];
        }
    }
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        HYUserInfo *userinfo = [HYUserInfo getUserInfo];
        
        if (userinfo.userId.length > 0)
        {
            [newDic setObject:userinfo.userId
                       forKey:@"userId"];
        }

        if (!_getAllExpressList)
        {
            if ([self.address length] > 0)
            {
                [newDic setObject:self.address forKey:@"userAddressId"];
            }
            
            if (self.storeProductAmount.length > 0)
            {
                [newDic setObject:self.storeProductAmount
                           forKey:@"storeProductAmount"];
            }
            
            if ([self.storeId length] > 0)
            {
                [newDic setObject:self.storeId forKey:@"storeId"];
            }
            if ([self.productSKUQuantity count] > 0)
            {
                NSString *jsonstr = [self.productSKUQuantity JSONString];
                [newDic setObject:jsonstr
                           forKey:@"productSKUQuantity"];
            }
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYGetExpressListResponse *respose = [[HYGetExpressListResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
