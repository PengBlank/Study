//
//  HYMallStoreListResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallStoreListResponse.h"

@interface HYMallStoreListResponse ()

@property (nonatomic, strong) NSArray *storeList;

@end

@implementation HYMallStoreListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *list = GETOBJECTFORKEY(data, @"programPOList", [NSArray class]);
        if ([list count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (id obj in list)
            {
                HYMallHomeItem *goods = [[HYMallHomeItem alloc] initWithDictionary:obj
                                                                             error:nil];
                [muArray addObject:goods];
            }
            
            self.storeList = [muArray copy];
        }
    }
    
    return self;
}

@end
