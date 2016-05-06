//
//  HYGetMyEmployeesListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetMyEmployeesListResponse.h"

@implementation HYGetMyEmployeesListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if ([data count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *d in data)
            {
                HYEmployee *e = [[HYEmployee alloc] initWithData:d];
                [muArray addObject:e];
            }
            
            self.employees = [muArray copy];
        }
    }
    
    return self;
}

@end
