//
//  HYHotelDetailViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店详情
 */
#import "HYHotelViewBaseController.h"

#import "HYHotelListSummary.h"
#import "HYHotelCityInfo.h"
#import "HYHotelRoomTypeCell.h"
#import "HYHotelDetailSummaryCell.h"
#import "HYHotelDetailDateInfoCell.h"
#import "HYDateSettingViewController.h"
#import "HYAdvanceBookingDelegate.h"

@interface HYHotelDetailViewController : HYHotelViewBaseController
<
HYHotelDetailSummaryCellDelegate,
HYAdvanceBookingDelegate,
HYHotelDetailDateInfoCellDelegate,
CQDateSettingViewControllerDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYHotelListSummary *hotleSummary;
@property (nonatomic, strong) HYHotelCityInfo *hotleCity;
@property (nonatomic, copy) NSString *checkInDate;
@property (nonatomic, copy) NSString *checkOutDate;

@end
