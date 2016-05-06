//
//  HYSearchUnPromoterCardResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchUnPromoterCardResponse.h"

@implementation HYSearchUnPromoterCardResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *numbers = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        NSMutableArray *getNums = [NSMutableArray array];
        for (NSDictionary *num in numbers)
        {
            HYCardSummaryInfo *card = [[HYCardSummaryInfo alloc] init];
            card.number = [num objectForKey:@"value"];
            card.card_id = [num objectForKey:@"id"];
            [getNums addObject:card];
        }
        self.numbers = [NSArray arrayWithArray:getNums];
    }
    
    return self;
}

@end
