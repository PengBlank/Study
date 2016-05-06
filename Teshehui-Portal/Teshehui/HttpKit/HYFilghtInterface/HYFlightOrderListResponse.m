//
//  HYFlightOrderListResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderListResponse.h"
#import "HYFlightOrder.h"

@interface HYFlightOrderListResponse ()

@property (nonatomic, strong) NSArray *orderList;

@end

@implementation HYFlightOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *ordars = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in ordars)
        {
            HYFlightOrder *fOrder = [[HYFlightOrder alloc] initWithDictionary:dic error:nil];
            
//            if (fOrder.hasAlteredInfo)
            {
                [muArray addObject:fOrder];
            }
        }
        
        self.orderList = muArray;
    }
    
    return self;
}

@end
