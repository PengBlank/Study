//
//  HYMallAdsResponse.m
//  Teshehui
//
//  Created by Kris on 16/1/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallAdsResponse.h"


@implementation HYMallAdsResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *dataInfo = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if ([dataInfo count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (id obj in dataInfo)
            {
                HYMallHomeBoard *board = [[HYMallHomeBoard alloc] initWithDictionary:obj
                                                                               error:nil];
                [muArray addObject:board];
            }
            
            self.homeItems = [muArray copy];
        }
    }
    
    return self;
}

@end
