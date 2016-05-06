//
//  HYTaxiEstimatedFeeRequest.m
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiEstimatedFeeRequest.h"
#import "HYTaxiEstimatedFeeResponse.h"
#import "JSONKit_HY.h"

@implementation HYTaxiEstimatedFeeRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"traffic/didi/calcuateCarFee.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
        if (_startLatitude.length > 0)
        {
            [muDict setObject:_startLatitude forKey:@"startLatitude"];
        }
        if (_endLatitude.length > 0)
        {
            [muDict setObject:_endLatitude forKey:@"endLatitude"];
        }
        if (_startLongitude.length > 0)
        {
            [muDict setObject:_startLongitude forKey:@"startLongitude"];
        }
        if (_endLongitude.length > 0)
        {
            [muDict setObject:_endLongitude forKey:@"endLongitude"];
        }
        if (_cityCode.length > 0)
        {
            [muDict setObject:_cityCode forKey:@"cityCode"];
        }
        if (_ruleCode.length > 0)
        {
            [muDict setObject:_ruleCode forKey:@"ruleCode"];
        }
        if (_carTypeCode)
        {
            [muDict setObject:_carTypeCode forKey:@"carTypeCode"];
        }
        
        if (muDict)
        {
            NSString *data = [muDict JSONString];
            [newDic setObject:data forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYTaxiEstimatedFeeResponse *respose = [[HYTaxiEstimatedFeeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
