//
//  RKPageContentViewController.h
//  Kuke
//
//  Created by 成才 向 on 15/10/28.
//  Copyright © 2015年 RK. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface RKPageContentViewController : HYMallViewBaseController

@property (nonatomic, copy) void (^viewDidLoadCallback)(void);
@property (nonatomic, copy) void (^viewWillAppearCallback)(void);
@property (nonatomic, copy) void (^viewWillDisapearCallback)(void);

@end
