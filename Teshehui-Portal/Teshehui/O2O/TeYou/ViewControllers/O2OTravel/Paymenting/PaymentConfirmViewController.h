//
//  PaymentConfirmViewController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "TravelTicketsListModel.h"

@interface PaymentConfirmViewController : HYMallViewBaseController

@property ( nonatomic , weak ) TravelTicketsListModel *ticketsModel;         //请求回来的所有门票列表
@property ( nonatomic , weak ) NSDictionary *dicTicketSelected; //选中的门票数量（保存有成人票和儿童票数量）
@property ( nonatomic , weak ) NSString *strAllPrice;           //上个页面计算出的总价
@property ( nonatomic , weak ) NSString *strAllCoupon;          //上个页面计算出的总现金券
@property ( nonatomic , weak ) NSString *strSeletedDate;          //上个页面选择的日期

@end
