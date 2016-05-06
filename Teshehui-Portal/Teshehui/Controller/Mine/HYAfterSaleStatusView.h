//
//  HYAfterSaleStatusView.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallAfterSaleInfo.h"

/**
 *  售后服务处理详情
 *  处理进度, 头部, 蓝色
 */
@interface HYAfterSaleStatusView : UIView

@property (nonatomic, strong) NSString *statusDesc;

@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;

@end
