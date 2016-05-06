//
//  HYCIGetDeclarationResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIGetDeclarationResponse.h"

@implementation HYCIGetDeclarationResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.statement = GETOBJECTFORKEY(data, @"insuranceStatement", NSString);
    }
    return self;
}

@end
