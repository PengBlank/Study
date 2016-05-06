//
//  CQFilghtOrderQueryResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtOrderQueryResponse.h"

@implementation CQFilghtOrderQueryResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSString *countStr = GETOBJECTFORKEY(dictionary, @"RecordCount", [NSString class]);
        NSString *pageStr = GETOBJECTFORKEY(dictionary, @"RecordCount", [NSString class]);
        NSString *curStr = GETOBJECTFORKEY(dictionary, @"CurrentPage", [NSString class]);
        self.RecordCount = countStr.intValue;
        self.CurrentPage = curStr.intValue;
        self.PageCount = pageStr.intValue;
        
        NSArray *array = GETOBJECTFORKEY(dictionary, @"DataList", [NSArray class]);
        if ([array count] >0 )
        {
            NSMutableArray *orders = [[NSMutableArray alloc] init];
            for (NSDictionary *d in array)
            {
                CQFilghtOrder *o = [[CQFilghtOrder alloc] initWithDataInfo:d];
                [orders addObject:o];
            }
            self.orderList = orders;
        }
    }
    
    return self;
}

@end
