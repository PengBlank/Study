//
//  HYSearchInactiveBatchResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSearchInactiveBatchResponse.h"

@implementation HYSearchInactiveBatchResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
        NSMutableArray *getObjs = [NSMutableArray array];
        for (NSDictionary *info in array)
        {
            HYCardSummaryInfo *card = [[HYCardSummaryInfo alloc] init];
            card.card_id = [info objectForKey:@"id"];
            card.number = [info objectForKey:@"value"];
            [getObjs addObject:card];
        }
        self.cardList = [NSArray arrayWithArray:getObjs];
    }
    
    return self;
}

@end
