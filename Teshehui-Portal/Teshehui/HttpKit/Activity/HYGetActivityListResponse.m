//
//  HYActivityCategoryResponse.m
//  Teshehui
//
//  Created by RayXiang on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetActivityListResponse.h"

@interface HYGetActivityListResponse ()
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSString *title;
@end

@implementation HYGetActivityListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *array = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        if (array)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *d in array)
            {
                HYActivityCategory *city = [[HYActivityCategory alloc] initWithData:d];
                NSArray *childs = [d objectForKey:@"child"];
                if (childs.count > 0)
                {
                    NSMutableArray *childCates = [NSMutableArray array];
                    for (NSDictionary *child in childs) {
                        HYActivityCategory *ch = [[HYActivityCategory alloc] initWithData:child];
                        [childCates addObject:ch];
                    }
                    city.child = [childCates copy];
                }
                
                [muArray addObject:city];
            }
            
            self.categoryArray = [muArray copy];
        }
        
        NSString *title = GETOBJECTFORKEY(dictionary, @"title", [NSString class]);
        self.title = title;
    }
    
    return self;
}

@end
