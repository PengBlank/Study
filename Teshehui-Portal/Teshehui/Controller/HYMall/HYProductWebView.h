//
//  HYProductWebView.h
//  Teshehui
//
//  Created by HYZB on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYProductWebView : UIView

@property (nonatomic, copy) NSString *htmlStr;

- (void)showWithAnimation:(BOOL)animation;
- (void)dismiss;

@end
