//
//  HYAgencyOrderListResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyOrderListResponse.h"
#import "HYOrderInfo.h"

@interface HYAgencyOrderListResponse ()

@property (nonatomic, strong) NSArray *orderList;

@end

@implementation HYAgencyOrderListResponse

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
                    HYOrderInfo *a = [[HYOrderInfo alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.dataArray = [muArray copy];
            }
            
            self.total = [[self.jsonDic objectForKey:@"total"] integerValue];
        }
    }
    
    return self;
}

@end
