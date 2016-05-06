//
//  HYQrcodeResultViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYQrcodeResultViewControllerDelegate <NSObject>
@optional

- (void)resultViewControllerDidDismiss;
- (void)resultViewControllerDidCheckDetail:(NSString *)goodsid;
- (void)resultViewControllerDidAddCart;

@end

/**
 *  二维码扫码结果，商品详情界面
 */
@interface HYQrcodeResultViewController : UIViewController

- (void)showInView;
- (void)dismissInView;

@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, weak) id<HYQrcodeResultViewControllerDelegate> delegate;

@end
