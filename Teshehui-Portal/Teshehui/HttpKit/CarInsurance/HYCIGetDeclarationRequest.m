//
//  HYCIGetDeclarationRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetDeclarationRequest.h"
#import "HYCIGetDeclarationResponse.h"

@implementation HYCIGetDeclarationRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"insurance/car/getInsuranceStatement.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYCIGetDeclarationResponse alloc] initWithJsonDictionary:info];
}

//- (NSMutableDictionary *)getJsonDictionary
//{
//    NSMutableDictionary *newDic = [super getJsonDictionary];
//    if (newDic && (NSNull *)newDic != [NSNull null]
//        )
//    {
//        
//    }
//    return newDic;
//}

@end
