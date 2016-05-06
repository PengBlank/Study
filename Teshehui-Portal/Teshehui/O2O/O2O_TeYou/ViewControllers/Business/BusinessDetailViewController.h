//
//  BusinessDetailViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家详情页
 **/

#import "HYMallViewBaseController.h"
#import "BusinessListInfo.h"
@interface BusinessDetailViewController : HYMallViewBaseController

@property (nonatomic, weak) BusinessListInfo *businessInfo;

@end
