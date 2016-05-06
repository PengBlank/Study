//
//  HYTaxiResponseInfoView.h
//  Teshehui
//
//  Created by 成才 向 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CCNibLoadView.h"
#import "HYTaxiOrderView.h"

/**
 *  司机应答
 *  滴滴打车叫车界面, 司机信息
 */
@interface HYTaxiResponseInfoView : CCNibLoadView

/**
 *  点击电话按钮
 */
@property (nonatomic, copy) void (^didClickPhoneBtn)(void);

/**
 *
 */
@property (nonatomic, strong) HYTaxiOrderView *orderView;

@end
