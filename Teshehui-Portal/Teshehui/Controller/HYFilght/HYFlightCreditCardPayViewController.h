//
//  HYFlightCreditCardPayViewController.h
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 机票信用卡支付
 */

#import "HYFlightBaseViewController.h"
#import "HYBankViewController.h"

#import "HYCabins.h"
#import "HYFlightCity.h"
#import "HYFlightDetailInfo.h"
#import "HYAddressInfo.h"

@interface HYFlightCreditCardPayViewController : HYFlightBaseViewController
<
UITableViewDataSource,
UITableViewDelegate,
HYBankViewControllerDelegate
>

@property (nonatomic, readonly, strong) UITableView *tableView;

@property (nonatomic, strong) HYFlightSKU *cabin;
@property (nonatomic, strong) HYFlightDetailInfo *flight;
@property (nonatomic, strong) NSArray *passengers;
@property (nonatomic, strong) HYAddressInfo *invoiceAdds;
@property (nonatomic, assign) HYSpendingPatterns spendPattern;  //消费方式
@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) CGFloat totalPrice;  //总价

@end
