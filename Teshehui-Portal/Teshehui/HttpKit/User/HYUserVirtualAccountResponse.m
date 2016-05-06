//
//  HYUserVirtualAccountResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserVirtualAccountResponse.h"

@implementation HYUserVirtualAccountResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        NSArray *list = GETOBJECTFORKEY(data, @"balanceList", NSArray);
        if (list.count > 0)
        {
            NSDictionary *balance = [list objectAtIndex:0];
            self.accountInfo = [[HYUserVirutalAccountInfo alloc] initWithDictionary:balance error:nil];
        }
    }
    return self;
}

@end
