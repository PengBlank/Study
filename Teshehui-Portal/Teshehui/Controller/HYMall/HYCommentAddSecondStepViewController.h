//
//  HYCommentAddSecondStepViewController.h
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYCommentAddOneStepModel.h"

/**
 * 发表评价及追加评价
 */
@interface HYCommentAddSecondStepViewController : HYMallViewBaseController

@property (nonatomic, strong) HYCommentAddOneStepModel *infoModel;
@property (nonatomic, assign) BOOL isReply; //default no

// 提交按钮
@property (nonatomic, strong) UIButton *commitBtn;

@end
