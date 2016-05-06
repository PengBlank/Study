//
//  HYPromotersListResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersListResponse.h"
#import "HYPromoters.h"

@implementation HYPromotersListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            id dataArray = [self.jsonDic objectForKey:@"items"];
            if ([dataArray isKindOfClass:[NSArray class]])
            {
                dataArray = dataArray;
            } else if ([dataArray isKindOfClass:[NSDictionary class]])
            {
                dataArray = [dataArray allValues];
            }
            NSArray *array = dataArray;

            if ([array count] > 0)
            {
                NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
                for (NSDictionary *data in array)
                {
                    HYPromoters *a = [[HYPromoters alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.dataArray = [muArray copy];
            }
        }
    }
    
    return self;
}

@end
