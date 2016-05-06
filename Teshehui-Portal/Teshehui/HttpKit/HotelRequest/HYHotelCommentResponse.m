//
//  HYHotelCommentResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelCommentResponse.h"

@interface HYHotelCommentResponse ()

@property (nonatomic, strong) HYHotelReview *hotelReview;
@property (nonatomic, strong) NSArray *reviewList;

@end

@implementation HYHotelCommentResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"result", [NSDictionary class]);
        NSDictionary *rating = GETOBJECTFORKEY(dic, @"rating", [NSDictionary class]);
        
        if (rating)
        {
            self.hotelReview = [[HYHotelReview alloc] initWithDataInfo:rating];
        }
        
        NSArray *comment = GETOBJECTFORKEY(dic, @"comment", [NSArray class]);
        
        if ([comment count] > 0)
        {
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            for (NSDictionary *d in comment)
            {
                HYHotelReviewDetail *rd = [[HYHotelReviewDetail alloc] initWithDataInfo:d];
                [comments addObject:rd];
            }
            
            self.reviewList = comments;
        }
    }
    
    return self;
}

@end
