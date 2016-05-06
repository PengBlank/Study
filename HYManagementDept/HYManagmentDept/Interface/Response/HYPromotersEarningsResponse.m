//
//  HYPromotersEarningsResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersEarningsResponse.h"
#import "HYPromoterEarning.h"

@implementation HYPromotersEarningsResponse

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
                    HYPromoterEarning *a = [[HYPromoterEarning alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.dataArray = [muArray copy];
            }
        }
    }
    
    return self;
}

@end
