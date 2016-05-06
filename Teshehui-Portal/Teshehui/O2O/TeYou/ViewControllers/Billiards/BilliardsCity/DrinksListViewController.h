//
//  DrinksListViewController.h
//  zuoqiu
//
//  Created by wujianming on 15/11/5.
//  Copyright © 2015年 teshehui. All rights reserved.
//  酒水列表

#import "HYMallViewBaseController.h"

typedef void (^DrinksListBlock)(NSArray *goodsInfos);

@interface DrinksListViewController : HYMallViewBaseController

@property (nonatomic, copy) DrinksListBlock drinksListCallBack;

@property (nonatomic, copy) NSString *merId;
@property (nonatomic, copy) NSString *orderId;

@end
