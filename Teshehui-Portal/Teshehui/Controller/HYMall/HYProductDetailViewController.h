//
//  HYMallProductDetailWithFilterController.h
//  Teshehui
//
//  Created by Kris on 16/3/28.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "RKBasePageViewController.h"

@interface HYProductDetailViewController : RKBasePageViewController

@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, assign) BOOL loadFromPayResult;  //是否从支付结果界面跳转过来的，对应的返回页面不同

@end
