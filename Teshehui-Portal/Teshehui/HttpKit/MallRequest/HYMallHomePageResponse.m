//
//  HYMallHomePageResponse.m
//  Teshehui
//
//  Created by HYZB on 14-10-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallHomePageResponse.h"

@interface HYMallHomePageResponse ()

@property (nonatomic, strong) NSArray *homeItems;

@end


@implementation HYMallHomePageResponse

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
