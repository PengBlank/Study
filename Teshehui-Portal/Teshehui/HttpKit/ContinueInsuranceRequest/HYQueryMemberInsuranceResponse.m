//
//  HYQueryMemberInsuranceResponse.m
//  Teshehui
//
//  Created by Kris on 15/6/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYQueryMemberInsuranceResponse.h"


@implementation HYQueryMemberInsuranceResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *result = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        if (result)
        {
            self.insuranceResualt = [[HYPolicy alloc] initWithDictionary:result
                                                                   error:nil];
        }
    }
    return self;
}

@end