//
//  HYInvoiceTitleAddViewController.h
//  Teshehui
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCustomNavItemViewController.h"

typedef enum {
    HYInvoiceTitleAdd,
    HYInvoiceTitleEdit
}HYInvoiceTitleAction;

/**
 *  @brief 增加发票抬头
 */
@interface HYInvoiceTitleAddViewController : HYCustomNavItemViewController

@property (nonatomic, assign) HYInvoiceTitleAction titleAction;

//已有的抬头，用来编辑
@property (nonatomic, strong) NSString *invoiceTitle;

@property (nonatomic, copy) void (^invoiceAddCallback)(NSString *newTitle);

@end
