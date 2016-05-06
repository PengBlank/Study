//
//  HYMallAdressListResponse.m
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetAdressListResponse.h"

@implementation HYGetAdressListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *result = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in result)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYAddressInfo *fType = [[HYAddressInfo alloc] initWithDictionary:d error:nil];
                [muArray addObject:fType];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.addressList = [muArray copy];
        }
    }
    
    return self;
}

@end
