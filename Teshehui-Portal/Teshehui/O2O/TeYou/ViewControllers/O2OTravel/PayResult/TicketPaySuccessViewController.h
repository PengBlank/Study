//
//  TicketPaySuccessViewController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "TYOrderNumModel.h"

@interface TicketPaySuccessViewController : HYMallViewBaseController

// 绑定cell用
@property ( nonatomic , weak ) NSArray *arrTicketsList;         //请求回来的所有门票列表
@property ( nonatomic , weak ) NSDictionary *dicTicketSelected; //选中的门票数量（保存有成人票和儿童票数量）
@property ( nonatomic , weak ) NSArray *arrCountSelected;       //门票数量大于0的 allkeys

// headerview 用
@property ( nonatomic , weak ) TYOrderNumModel *orderModel;          // 二维码信息
@property ( nonatomic , weak ) NSString *strScenicName; // 显示景点名称
@property ( nonatomic , weak ) NSString *strPayDate;    // 付款成功时间，暂时使用系统时间
@property ( nonatomic , weak ) NSString *strSavePrce;   // 节省的费用
@property ( nonatomic , weak ) NSString *strPaymentPrice;// 付款总额
@property ( nonatomic , weak ) NSString *strTicketDate; //票使用时间
@property ( nonatomic , weak ) NSString *strAllPrice; //消费的金额

@property ( nonatomic , weak ) NSString *O2O_OrderNo; //轮询接口使用

@end
