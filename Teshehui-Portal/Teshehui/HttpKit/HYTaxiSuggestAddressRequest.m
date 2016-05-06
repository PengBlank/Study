//
//  HYTaxiSuggestAddressRequest.m
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiSuggestAddressRequest.h"
#import "HYTaxiSuggestAddressResponse.h"
#import "JSONKit_HY.h"

@implementation HYTaxiSuggestAddressRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"traffic/didi/suggestAddress.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        BOOL ok = _cityName && _address && _latitude &&_longitude;
        if (ok)
        {
            NSDictionary *dict = @{@"cityName" : _cityName,
                                   @"address": _address,
                                   @"latitude":_latitude,
                                   @"longitude":_longitude};
            NSString *data = [dict JSONString];
            if (data)
            {
                [newDic setObject:data forKey:@"data"];
            }
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiSuggestAddressResponse *respose = [[HYTaxiSuggestAddressResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
