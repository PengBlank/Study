//
//  HYCIQuoteCalculateRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQuoteCalculateRequest.h"
#import "HYCICarInfoFillType.h"
#import "JSONKit_HY.h"

@implementation HYCIQuoteCalculateRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"/insurance/car/calculateInsuranceFee.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (self.sessionId.length > 0
            && self.fillTypeKey.length > 0)
        {
            [data setObject:self.sessionId forKey:@"sessionId"];
            [data setObject:self.fillTypeKey forKey:@"packageType"];
            
            NSMutableDictionary *filltypes = [NSMutableDictionary dictionary];
            for (HYCICarInfoFillType *filltype in self.fillTypeList)
            {
                [filltypes setObject:filltype.value forKey:filltype.name];
            }
            [filltypes setObject:[NSString stringWithFormat:@"%d", self.forceFlag]
                          forKey:@"forceFlag"];
            
            [data setObject:filltypes forKey:self.fillTypeKey];
            
            NSMutableDictionary *dates = [NSMutableDictionary dictionary];
            for (HYCICarInfoFillType *filltype in self.dateList)
            {
                [dates setObject:filltype.value forKey:filltype.name];
            }
            [data setObject:dates forKey:@"deadline"];
            
            //下面暂未搞清楚是什么意思的一些参数，先放默认
//            [data setObject:@{@"isImmevalid": @"0",
//                              @"immeValidHoursStart": @"20"}
//                     forKey:@"immevalid"];
            if (self.driverFlag)
            {
                [data setObject:@(_isAssignDriver) forKey:@"agreedDriver"];
                if (_isAssignDriver && self.driverName && self.drivateDate && self.driverNum)
                {
                    [data setObject:self.driverName forKey:@"driverName"];
                    [data setObject:self.drivateDate forKey:@"drivateDate"];
                    [data setObject:self.driverNum forKey:@"driverNum"];
                }
            }
        }
        else
        {
            @throw [[NSException alloc] init];
        }
        
        NSString *jsondata = [data JSONString];
        if ([jsondata length] > 0)
        {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIQuoteCalculateResponse *respose = [[HYCIQuoteCalculateResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
