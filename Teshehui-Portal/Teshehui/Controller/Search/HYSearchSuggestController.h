//
//  HYSearchSuggestController.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSearchSuggestItem.h"
@class HYMallSearchViewController;

@protocol HYSearchSuggestDelegate <NSObject>

- (void)suggestControllerDidSelectItem:(HYSearchSuggestItem *)item;

@end

@interface HYSearchSuggestController : UITableViewController

@property (nonatomic, strong) NSArray *suggests;

@property (nonatomic, weak) id<HYSearchSuggestDelegate> delegate;


@end
