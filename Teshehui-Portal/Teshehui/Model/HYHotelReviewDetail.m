//
//  HYHotelReviewDetail.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelReviewDetail.h"

@implementation HYHotelReviewDetail

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        NSString *all = GETOBJECTFORKEY(data, @"Rating", [NSString class]);
        self.RatingAll = all.floatValue;
        NSString *room = GETOBJECTFORKEY(data, @"RatingRoom", [NSString class]);
        self.RatingRoom = room.floatValue;
        NSString *posit = GETOBJECTFORKEY(data, @"RatingPosit", [NSString class]);
        self.RatingPosit = posit.floatValue;
        NSString *service = GETOBJECTFORKEY(data, @"RatingService", [NSString class]);
        self.RatingService = service.floatValue;
        NSString *costBenefit = GETOBJECTFORKEY(data, @"RatingCostBenefit", [NSString class]);
        self.RatingCostBenefit = costBenefit.floatValue;

        self.UID = GETOBJECTFORKEY(data, @"UID", [NSString class]);
        self.WritingDate = GETOBJECTFORKEY(data, @"WritingDate", [NSString class]);
        self.Content = GETOBJECTFORKEY(data, @"Content", [NSString class]);
    }
    
    return self;
}

@end
