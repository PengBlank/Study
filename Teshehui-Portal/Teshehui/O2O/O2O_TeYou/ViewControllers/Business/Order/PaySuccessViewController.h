//
//  PaySuccessViewController.h
//  Teshehui
//
//  Created by xkun on 15/10/2.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "DefineConfig.h"
@interface PaySuccessViewController : HYMallViewBaseController

@property (nonatomic,strong) NSString   *merId;
@property (nonatomic,strong) NSString   *storeName;
@property (nonatomic,strong) NSString   *money;
@property (nonatomic,strong) NSString   *coupon;
@property (nonatomic,strong) NSString   *O2O_OrderNo;
@property (nonatomic,strong) NSString   *orderId;
@property (nonatomic,strong) NSString   *orderType;

@property (nonatomic,assign) BOOL       memberPay;
@property (nonatomic,assign) O2OPayType payType;


@end
