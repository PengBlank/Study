//
//  HYHotelOrderViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 订单填写界面
 */

#import "HYHotelViewBaseController.h"
#import "HYHotelInfoDetail.h"
//#import "HYHotelRoom.h"
#import "HYPickerToolView.h"
#import "HYHotelFillUserInfoCell.h"
#import "HYSpecialRequestViewController.h"
#import "HYHotelCreditCardViewController.h"

@interface HYHotelFillOrderViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
HYPickerToolViewDelegate,
HYHotelFillUserInfoCellDelegate,
HYSpecialRequestViewControllerDelegale
>

@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;
@property (nonatomic, strong) HYHotelSKU *roomInfo;
@property (nonatomic, copy) NSString *checkInDate;
@property (nonatomic, copy) NSString *checkOutDate;

@property (nonatomic, assign) BOOL isPrePay;
@end
