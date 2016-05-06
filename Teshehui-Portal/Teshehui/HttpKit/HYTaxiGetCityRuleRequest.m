//
//  HYTaxiGetCityRuleRequest.m
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiGetCityRuleRequest.h"
#import "HYTaxiGetCityRuleResponse.h"
#import "JSONKit_HY.h"

@implementation HYTaxiGetCityRuleRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"traffic/didi/getCityRuleList.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (_latitude && _longitude)
        {
            NSDictionary *dict = @{@"latitude" : self.latitude,
                                   @"longitude": self.longitude};
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
    HYTaxiGetCityRuleResponse *respose = [[HYTaxiGetCityRuleResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
