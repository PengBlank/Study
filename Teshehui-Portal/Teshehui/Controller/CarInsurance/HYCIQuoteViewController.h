//
//  HYCIQuoteViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"
#import "HYCIOwnerInfo.h"

/**
 * 精确报价界面
 */
@interface HYCIQuoteViewController : HYMallViewBaseController

@property (nonatomic, strong) NSArray *carInfoList;
@property (nonatomic, copy) NSString *carInfoKey;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) NSDictionary *packageTypeMap; //{"":"luxury"...}

@property (nonatomic, strong) HYCIOwnerInfo *ownerInfo;

@end
