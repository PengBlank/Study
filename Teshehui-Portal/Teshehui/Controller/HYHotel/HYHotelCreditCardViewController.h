//
//  HYHotelCreditCardViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelViewBaseController.h"
#import "HYHotelInfoDetail.h"
#import "HYBankViewController.h"

@interface HYHotelCreditCardViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate,
HYBankViewControllerDelegate
>

@property (nonatomic, readonly, strong) UITableView *tableView;

@property (nonatomic, strong) HYHotelInfoDetail *hotelInfo;
@property (nonatomic, strong) HYHotelSKU *roomInfo;
@property (nonatomic, assign) HYSpendingPatterns spendPattern;  //消费方式

@property (nonatomic, copy) NSString *checkInDate;
@property (nonatomic, copy) NSString *checkOutDate;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) NSArray *hotelGuest;
@property (nonatomic, copy) NSString *spacialContent;
@property (nonatomic, copy) NSString *arrivalTime;
@property (nonatomic, copy) NSString *lastArrivalTime;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger quantity;


@end
