//
//  HYHotelReview.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelReview.h"

@implementation HYHotelReview

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        /*
         RatingAll;
         RatingRoom;
         RatingPosit;
         RatingService;
         RatingCostBenefit
         ratingCount;
         */
        NSString *all = GETOBJECTFORKEY(data, @"RatingAll", [NSString class]);
        self.RatingAll = all.floatValue;
        NSString *room = GETOBJECTFORKEY(data, @"RatingRoom", [NSString class]);
        self.RatingRoom = room.floatValue;
        NSString *posit = GETOBJECTFORKEY(data, @"RatingPosit", [NSString class]);
        self.RatingPosit = posit.floatValue;
        NSString *service = GETOBJECTFORKEY(data, @"RatingService", [NSString class]);
        self.RatingService = service.floatValue;
        NSString *costBenefit = GETOBJECTFORKEY(data, @"RatingCostBenefit", [NSString class]);
        self.RatingCostBenefit = costBenefit.floatValue;
        NSString *count = GETOBJECTFORKEY(data, @"ratingCount", [NSString class]);
        self.ratingCount = count.intValue;
    }
    
    return self;
}

@end
