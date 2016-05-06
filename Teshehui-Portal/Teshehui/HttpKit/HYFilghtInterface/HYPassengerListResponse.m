//
//  HYPassengerListResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPassengerListResponse.h"

@interface HYPassengerListResponse ()

@property (nonatomic, strong) NSArray *passengerList;

@end

@implementation HYPassengerListResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSArray *fList = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if ([fList count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *d in fList)
            {
                HYPassengers *p = [[HYPassengers alloc] initWithDataInfo:d];
                [muArray addObject:p];
            }
            
            self.passengerList = muArray;
        }
    }
    
    return self;
}

@end
