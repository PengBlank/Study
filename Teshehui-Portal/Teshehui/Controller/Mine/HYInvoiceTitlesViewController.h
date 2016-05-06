//
//  HYInvoiceTitlesViewController.h
//  Teshehui
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCustomNavItemViewController.h"

/**
 *  对发票抬头的操作
 */
typedef enum {
    HYInvoiceTitlesSelect,    //选择
    HYInvoiceTitlesView       //查看
}HYInvoiceTitlesAction;


/**
 *  @brief  常用发票抬头
 */
@interface HYInvoiceTitlesViewController : HYCustomNavItemViewController

@property (nonatomic, assign) HYInvoiceTitlesAction titlesAction;

@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, copy) void (^invoiceTitlesCallback)(NSString *title);

@end
