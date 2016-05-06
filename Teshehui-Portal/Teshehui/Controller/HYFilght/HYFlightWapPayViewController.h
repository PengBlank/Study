//
//  HYFlightWapPayViewController.h
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 机票携程的wap界面支付
 */
#import "HYFlightBaseViewController.h"

@protocol HYFlightWapPayViewControllerDelegate <NSObject>

@optional
- (void)didPaymentResult:(BOOL)succ;

@end

@interface HYFlightWapPayViewController : HYFlightBaseViewController
{
    UIWebView *_webView;
}

@property (nonatomic, assign) id<HYFlightWapPayViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *orderNO;

@end
