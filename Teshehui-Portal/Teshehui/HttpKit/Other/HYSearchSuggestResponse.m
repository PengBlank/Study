//
//  HYSearchSuggestResponse.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchSuggestResponse.h"

@implementation HYSearchSuggestResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        //NSArray *
        
        NSMutableArray *items = [NSMutableArray array];
        NSDictionary *dataDict = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray * dataArr = GETOBJECTFORKEY(dataDict, @"suggestNameArray", NSArray);
        for (NSString *str in dataArr)
        {
            HYSearchSuggestItem *item = [[HYSearchSuggestItem alloc] init];
            item.display = str;
            [items addObject:item];
        }
        self.result = [NSArray arrayWithArray:items];
    }
    return self;
}

@end
