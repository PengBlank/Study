//
//  HYGetMessageResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetMessageResponse.h"

@implementation HYGetMessageResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray* result = [dic objectForKey:@"messageData"];
        
        _totalItems = [[dic objectForKey:@"totalItems"] intValue];
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (id obj in result)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *d = (NSDictionary *)obj;
                HYMessageInfo* info = [[HYMessageInfo alloc]initWithDataInfo:d];
                [muArray addObject:info];
            }
        }
        
        if ([muArray count] > 0)
        {
            self.MessageArray = [muArray copy];
        }
    }
    
    return self;
}

@end
