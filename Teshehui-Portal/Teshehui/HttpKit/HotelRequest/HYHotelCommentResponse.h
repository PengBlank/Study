//
//  HYHotelCommentResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYHotelReview.h"
#import "HYHotelReviewDetail.h"

@interface HYHotelCommentResponse : CQBaseResponse

@property (nonatomic, readonly, strong) HYHotelReview *hotelReview;
@property (nonatomic, readonly, strong) NSArray *reviewList;

@end
