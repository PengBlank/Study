//
//  HYHotelInvoiceViewController.h
//  Teshehui
//
//  Created by apple on 15/3/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHotelViewBaseController.h"
#import "HYHotelInvoiceModel.h"
/**
 *  @brief  酒店订单发票界面
 */
@interface HYHotelInvoiceViewController : HYHotelViewBaseController

@property (nonatomic, assign) BOOL needInvoice;
@property (nonatomic, strong) HYHotelInvoiceModel *invoiceModel;

@property (nonatomic, copy) void (^invoiceCallback)(HYHotelInvoiceModel *model);

@end
