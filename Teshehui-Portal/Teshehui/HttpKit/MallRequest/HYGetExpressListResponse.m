//
//  HYGetExpressListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetExpressListResponse.h"

#import "HYExpressInfo.h"

@implementation HYGetExpressListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
//        NSMutableArray *muArray = [[NSMutableArray alloc] init];
//        for (id obj in array)
//        {
//            if ([obj isKindOfClass:[NSDictionary class]])
//            {
//                NSDictionary *d = (NSDictionary *)obj;
//                HYExpressInfo *express = [[HYExpressInfo alloc] initWithDataInfo:d];
//                [muArray addObject:express];
//            }
//        }
//        
//        if ([muArray count] > 0)
//        {
//            self.expressList = [muArray copy];
//        }
        self.expressList = [HYExpressInfo arrayOfModelsFromDictionaries:array];
    }
    
    return self;
}

@end
