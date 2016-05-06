//
//  GetCommentViewController.h
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 评论成功页面
 **/

#import "HYMallViewBaseController.h"

@interface GetCommentViewController : HYMallViewBaseController
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong)   UITableView     *baseTableView;

@property (nonatomic, copy)     NSString        *MerId;
@property (nonatomic, copy)     NSString        *MerName;
@property (nonatomic, copy)     NSString        *money;
@property (nonatomic, copy)     NSString        *coupon;
@property (nonatomic, copy)     NSString        *orderDate;

@property (nonatomic, assign)   NSInteger       starNum;        // 星星数
@property (nonatomic, copy)     NSString        *commentText;   // 评论内容
@property (nonatomic, strong)   NSArray         *images;        // 图片数组

@property (nonatomic, copy)     NSString        *orderType;     // 1发现订单 2旅游订单

@end
