//
//  HYFlightPaymentSelectViewController.h
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 机票付款选择支付方式的界面
 */

#import "HYFlightBaseViewController.h"
#import "HYCabins.h"
#import "HYFlightCity.h"
#import "HYFlightDetailInfo.h"
#import "HYAddressInfo.h"

@interface HYFlightPaymentSelectViewController : HYFlightBaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) HYFlightSKU *cabin;
@property (nonatomic, strong) HYFlightDetailInfo *flight;
@property (nonatomic, strong) NSArray *passengers;
@property (nonatomic, strong) HYAddressInfo *invoiceAdds;
@property (nonatomic, assign) HYSpendingPatterns spendPattern;  //消费方式
@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) CGFloat totalPrice;  //总价

@end
