//
//  HYFolwerShowPicDetailViewController.h
//  Teshehui
//
//  Created by ichina on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFolwerViewBaseController.h"

@interface HYFolwerShowPicDetailViewController : HYFolwerViewBaseController <UIWebViewDelegate>

@property(nonatomic,retain) UIWebView* myWeb;

@property(nonatomic,retain) NSString* Mytitle;

@property(nonatomic,retain) NSString* htmlString;

@end
