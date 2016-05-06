//
//  CommentViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家评论列表页
 **/

#import "HYMallViewBaseController.h"
#import "BusinessdetailInfo.h"
@interface CommentViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, assign) BOOL               isNext;
@property (nonatomic, strong) UITableView        *baseTableView;
@property (nonatomic, strong) BusinessdetailInfo *businessInfo;
@end
