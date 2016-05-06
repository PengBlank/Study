//
//  HYMeiWeiQiQiViewController.h
//  Teshehui
//
//  Created by HYZB on 15/12/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface HYMeiWeiQiQiViewController : HYMallViewBaseController

@property (nonatomic, strong) UIWebView *meiWeiQiQiWebView;

- (void)loadURL:(NSURL *)URL;

@end
