//
//  HYCommentAddViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-9-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYMallOrderSummary.h"

/*
 * 评价添加界面，被HYCommentAddOneStepViewController替换
 * 此页面在售后服务曾经使用过
 */
@interface HYCommentAddViewController : HYMallViewBaseController

@property (nonatomic, strong) HYMallOrderSummary *orderInfo;

@property (nonatomic, copy) void (^addCommentCallback)(BOOL success);

@end
