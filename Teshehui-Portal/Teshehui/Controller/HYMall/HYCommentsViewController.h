//
//  HYCommentsViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  评价展示界面
 */
@interface HYCommentsViewController : HYMallViewBaseController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *goods_id;

@property (nonatomic, assign) CGFloat commentLevel;
@property (nonatomic, assign) NSInteger commentNum;

@end
