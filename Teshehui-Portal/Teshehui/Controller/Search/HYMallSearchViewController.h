//
//  HYMallSearchViewController.h
//  Teshehui
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"

@class HYSearchSuggestItem;

@interface HYMallSearchViewController : HYMallViewBaseController

@property (nonatomic, copy) NSString *searchKeyWord;

- (void)suggestControllerDidSelectItem:(HYSearchSuggestItem *)item;

@end
