//
//  ShareButtonView.h
//  Teshehui
//
//  Created by macmini5 on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//
// 分享按钮View

#import <UIKit/UIKit.h>
#import "O2OShareInfoRequest.h"

@interface ShareButtonView : UIView

@property (nonatomic,strong) O2OShareInfoRequest    *shareInfoRequest;

- (id)initWithViewController:(UIViewController *)viewController MerId:(NSString *)merId AndSavePrice:(NSString *)savePrice AndBackgroundColor:(UIColor *)color;

// 这个方法是给购票成功后后调用的 因为UI距离不一样
- (id)initWithPaySuccessViewController:(UIViewController *)viewController MerId:(NSString *)merId AndSavePrice:(NSString *)savePrice AndBackgroundColor:(UIColor *)color;


@end
