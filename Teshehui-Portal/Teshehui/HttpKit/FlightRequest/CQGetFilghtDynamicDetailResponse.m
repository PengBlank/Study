//
//  CQGetFilghtDynamicDetailResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetFilghtDynamicDetailResponse.h"


@implementation CQGetFilghtDynamicDetailResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        
        NSArray *array = GETOBJECTFORKEY(dictionary, @"DataList", [NSArray class]);
        if ([array count] >0 )
        {
            NSMutableArray *dycs = [[NSMutableArray alloc] init];
            for (NSDictionary *d in array)
            {
                CQFilghtDycDetail *dyc
                = [[CQFilghtDycDetail alloc] initWithDataInfo:d];
                [dycs addObject:dyc];
            }
            
            //只显示最后的;
            self.dycDetail = [dycs lastObject];
        }
    }
    
    return self;
}

@end
