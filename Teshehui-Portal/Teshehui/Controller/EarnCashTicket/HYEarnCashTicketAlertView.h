//
//  HYEarnCashTicketAlertView.h
//  Teshehui
//
//  Created by HYZB on 16/4/16.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 赚现金券提示页面
 */
@interface HYEarnCashTicketAlertView : UIView

@property (nonatomic, strong) UIButton *agreedBtn;
@property (nonatomic, strong) UIWebView *contentWebV;

- (void)show;
- (void)dismiss;

@end
