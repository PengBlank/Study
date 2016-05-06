//
//  HYMallOrderReturnListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderReturnListResponse.h"
#import "HYMallReturnsInfo.h"
#import "HYMallAfterSaleInfo.h"

@implementation HYMallOrderReturnListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", NSArray);
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in items)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYMallAfterSaleInfo *returnInfo = [[HYMallAfterSaleInfo alloc] initWithDictionary:d error:nil];
                [muArray addObject:returnInfo];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.returnList = [muArray copy];
        }
    }
    
    return self;
}

@end
