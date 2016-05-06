//
//  HYCradSummaryInfo.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCardSummaryInfo.h"

@implementation HYCardSummaryInfo

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.card_id = GETOBJECTFORKEY(data, @"card_id", [NSString class]);
        self.number = GETOBJECTFORKEY(data, @"number", [NSString class]);
    }
    
    return self;
}

@end
