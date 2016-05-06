//
//  CQGetFilghtDynamicResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQGetFilghtDynamicResponse.h"
#import "CQFilghtDynamic.h"

@implementation CQGetFilghtDynamicResponse

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
                CQFilghtDynamic *dyc
                = [[CQFilghtDynamic alloc] initWithDataInfo:d];
                [dycs addObject:dyc];
            }
            self.dynamicList = dycs;
        }
    }
    
    return self;
}

@end
