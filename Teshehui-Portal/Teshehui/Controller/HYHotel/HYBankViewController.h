//
//  HYBankViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelViewBaseController.h"
#import "HYCreditCardInfo.h"

@protocol HYBankViewControllerDelegate;
@interface HYBankViewController : HYHotelViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, weak) id<HYBankViewControllerDelegate>delegate;
@property (nonatomic, readonly, strong) UITableView *tableView;

@end


@protocol HYBankViewControllerDelegate <NSObject>

@optional
- (void)didSelectBankInfo:(HYCreditCardInfo *)bankInfo;

@end