//
//  HYCIQuoteRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIQuoteRequest.h"
#import "HYCIQuoteResponse.h"
#import "JSONKit_HY.h"

@interface HYCIQuoteRequest ()

@property (nonatomic, strong) NSDictionary *reqData;

@end

@implementation HYCIQuoteRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/car/queryInsuranceTypeInputList.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        self.version = @"1.0.1";
    }
    
    return self;
}

- (void)setCarInfoList:(NSArray *)carInfoList
{
    _carInfoList = carInfoList;
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for (HYCICarInfoFillType *type in carInfoList)
    {
        if (type.value && type.name)
        {
            [tempDic setObject:type.value
                        forKey:type.name];
        }
    }
    
    if (self.keyName && self.sessionId && self.packageType)
    {
        self.reqData = [[NSDictionary alloc] initWithObjectsAndKeys:tempDic, self.keyName,
                        self.sessionId, @"sessionId",
                        self.packageType, @"packageType", nil];
    }
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSString *jsondata = [self.reqData JSONString];
        
        if ([jsondata length] > 0)
        {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIQuoteResponse *respose = [[HYCIQuoteResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
