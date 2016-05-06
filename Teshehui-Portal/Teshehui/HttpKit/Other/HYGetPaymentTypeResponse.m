//
//  HYGetPaymentTypeResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPaymentTypeResponse.h"

@interface HYGetPaymentTypeResponse ()

@property (nonatomic, strong) NSArray *payTypes;

@end

@implementation HYGetPaymentTypeResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);

        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (NSDictionary *d in array)
        {
            NSString *str = GETOBJECTFORKEY(d, @"channelCode", [NSString class]);
            if (str)
            {
                [muArray addObject:str];
            }
        }
        
        self.payTypes = [muArray copy];
    }
    
    return self;
}

@end
