//
//  HYAgencyIncomeOrderListResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyIncomeOrderListResponse.h"
#import "HYOrderIncomInfo.h"

@interface HYAgencyIncomeOrderListResponse ()


@end


@implementation HYAgencyIncomeOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            NSArray *array = GETOBJECTFORKEY(self.jsonDic, @"items", [NSArray class]);
            
            if ([array count] > 0)
            {
                NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
                for (NSDictionary *data in array)
                {
                    HYOrderIncomInfo *a = [[HYOrderIncomInfo alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.dataArray = [muArray copy];
            }
        }
    }
    
    return self;
}

@end