//
//  PostCommentViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/**
    O2O附近商家发表评论页
 **/

#import "HYMallViewBaseController.h"
#import "CommentInfo.h"
#import "BusinessdetailInfo.h"
#import "BilliardsOrderInfo.h"
#import "TravelOrderInfo.h"
#import "DefineConfig.h"
@interface PostCommentViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) CommentInfo *curPost;;
@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, copy  ) NSString    *MerId;
@property (nonatomic, copy  ) NSString    *MerName;
@property (nonatomic, copy  ) NSString    *money;
@property (nonatomic, copy  ) NSString    *coupon;
@property (nonatomic, copy  ) NSString    *orderDate;

@property (nonatomic, assign  ) NSInteger   orderType;//1 标示发现订单  2 标示旅游订单  3 桌球
@property (nonatomic, copy  ) NSString    *orderId;

@property (nonatomic, assign) O2OBackType    backType;

@property (nonatomic, assign  ) BOOL    payPush;

@end
