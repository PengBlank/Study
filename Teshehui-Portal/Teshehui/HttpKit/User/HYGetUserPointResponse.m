//
//  HYGetUserPointResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetUserPointResponse.h"

@implementation HYGetUserPointResponse

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
                HYPointLogInfo* info = [[HYPointLogInfo alloc]initWithDataInfo:d];
                [muArray addObject:info];
            }
        }
        
        NSString *point = GETOBJECTFORKEY(dic, @"points", [NSString class]);
        self.points = point;
        
        if ([muArray count] > 0)
        {
            self.PointArray = [muArray copy];
        }
    }
    
    return self;
}
@end
