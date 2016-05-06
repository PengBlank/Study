//
//  HYMallBrandView.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYXibView.h"
#import "HYMallBrandViewController.h"

@interface HYMallBrandView : HYXibView

@property (nonatomic, weak) HYMallBrandViewController *userInterfaceDelegate;

- (void)reloadTableView;

@end
