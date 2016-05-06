//
//  HYHotelDetailSummaryCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYHotelInfoDetail.h"

@protocol HYHotelDetailSummaryCellDelegate <NSObject>

@optional
- (void)checkHotelPictures;
- (void)checkHotelRating;

@end

@interface HYHotelDetailSummaryCell : HYBaseLineCell

@property (nonatomic, strong) UILabel *hotelNameLab;
@property (nonatomic, strong) UILabel *hotelTypeLab;
@property (nonatomic, strong) UILabel *hotelScoreLab;
@property (nonatomic, strong) UILabel *hotelReviewLab;
@property (nonatomic, strong) UILabel *hotelEnvironmentLab;
@property (nonatomic, strong) UILabel *hotelDeviceLab;
@property (nonatomic, strong) UILabel *hotelServiceLab;
@property (nonatomic, strong) UILabel *hotelHealthLab;
@property (nonatomic, strong) UILabel *hotelPicTotaLab;
@property (nonatomic, strong) UIButton *iconBtn;

@property (nonatomic, weak) id<HYHotelDetailSummaryCellDelegate>delegate;
@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;
@property (nonatomic, strong) NSArray *picList;


@end
