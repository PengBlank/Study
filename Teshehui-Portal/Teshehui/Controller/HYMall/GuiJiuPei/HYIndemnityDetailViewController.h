//
//  HYIndemnityDetailViewController.h
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 申请赔付的详情
 */

#import "HYMallViewBaseController.h"
#import "HYIndemnityinfo.h"

@interface HYIndemnityDetailViewController : HYMallViewBaseController
{
    UIScrollView *_contentView;
}

@property (nonatomic, strong) HYIndemnityinfo *indemnityInfo;

@end
