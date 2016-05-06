//
//  ConfirmPayViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/24.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家确认订单页（主动）
 **/

typedef NS_ENUM(NSInteger, ConfirmPayType)
{
    ConfirmCateringPay     = 1, //快餐
    ConfirmBilliardsPay    = 2, //桌球
    ConfirmCommonPay       = 3 //普通
    
};

#import "HYMallViewBaseController.h"
#import "BusinessdetailInfo.h"
@interface ConfirmPayViewController : HYMallViewBaseController

@property (nonatomic,strong) BusinessdetailInfo *businessdetailInfo;
@property (nonatomic,assign) ConfirmPayType payType;
@property (nonatomic,assign) BOOL isChange;  // 是否改变字段

@end
