//
//  HYAccountBalanceResponse.m
//  Teshehui
//
//  Created by Kris on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAccountBalanceResponse.h"

@implementation HYAccountBalance

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation HYAccountBalanceResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSArray *list = GETOBJECTFORKEY(data, @"items", NSArray);
        NSMutableArray *muArray = [NSMutableArray array];
        for (id obj in list)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYAccountBalance *accountBalance = [[HYAccountBalance alloc] initWithDictionary:d error:nil];
                [muArray addObject:accountBalance];
            }
        }
        if ([muArray count] > 0)
        {
            self.accountBalanceInfos = [muArray copy];
        }
    }
    return self;
}

@end
