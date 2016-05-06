//
//  HYDeliverCompanyResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYDeliverCompanyResponse.h"

@implementation HYDeliverCompanyResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary]) {
        NSArray *array = GETOBJECTFORKEY(dictionary, @"data", NSArray);
        self.companyList = [HYDeliverCompany arrayOfModelsFromDictionaries:array];
        
    }
    return self;
}

@end
