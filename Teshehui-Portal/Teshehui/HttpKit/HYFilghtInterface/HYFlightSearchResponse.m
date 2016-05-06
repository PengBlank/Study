//
//  HYFlightSearchResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightSearchResponse.h"
#import "HYFlightListSummary.h"

@interface HYFlightSearchResponse ()

@property (nonatomic, strong) NSArray *flightList;

@end

@implementation HYFlightSearchResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        NSDictionary *goodsData = GETOBJECTFORKEY(data, @"pagePO", NSDictionary);
        NSArray *fList = GETOBJECTFORKEY(goodsData, @"items", NSArray);

        if ([fList count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *d in fList)
            {
                HYFlightListSummary *f = [[HYFlightListSummary alloc] initWithJsonData:d];
                [muArray addObject:f];
            }
            
            self.flightList = muArray;
        }
    }
    
    return self;
}

@end
