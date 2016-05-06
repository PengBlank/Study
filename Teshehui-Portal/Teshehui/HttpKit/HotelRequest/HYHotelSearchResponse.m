//
//  HYHotelSearchResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelSearchResponse.h"
#import "HYHotelListSummary.h"

@interface HYHotelSearchResponse ()

@property (nonatomic, strong) NSArray *hotelList;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger currendPage;
@end

@implementation HYHotelSearchResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        NSDictionary *pageData = GETOBJECTFORKEY(data, @"pagePO", [NSDictionary class]);
        
        NSString *totalStr = GETOBJECTFORKEY(pageData, @"totalCount", [NSString class]);
        self.total = totalStr.integerValue;
        
        NSArray *hList = GETOBJECTFORKEY(pageData, @"items", [NSArray class]);
        
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableDictionary *tempDict = nil;
        for (NSDictionary *dict in hList)
        {
            tempDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
            NSDictionary *expan = GETOBJECTFORKEY(dict, @"expandedResponse", [NSDictionary class]);
            [tempDict addEntriesFromDictionary:expan];
            [tempDict removeObjectForKey:@"expandedResponse"];
            [tempArr addObject:tempDict];
        }
        
//        NSArray *expandedResponse = [tempArr copy];
        
        if ([tempArr count] > 0)
        {
            self.hotelList = [HYHotelListSummary arrayOfModelsFromDictionaries:tempArr];
        }
    }
    
    return self;
}

@end
