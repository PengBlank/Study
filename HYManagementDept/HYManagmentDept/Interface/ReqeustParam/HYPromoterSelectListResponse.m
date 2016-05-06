//
//  HYPromoterSelectListResponse.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterSelectListResponse.h"

@implementation HYPromoterSelectInfo

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.real_name = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
    }
    return self;
}

@end

@implementation HYPromoterSelectListResponse

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
                    HYPromoterSelectInfo *a = [[HYPromoterSelectInfo alloc] initWithData:data];
                    [muArray addObject:a];
                }
                
                self.promoterList = [muArray copy];
            }
        }
    }
    
    return self;
}

@end
