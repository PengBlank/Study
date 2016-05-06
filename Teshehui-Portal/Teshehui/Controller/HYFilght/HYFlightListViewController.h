//
//  HYFlightListViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightBaseViewController.h"
#import "HYFlightCity.h"
#import "HYCabins.h"

/**
 *  航班列表界面
 *  从机票搜索界面点击搜索按钮到达此处
 */
@interface HYFlightListViewController : HYFlightBaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) HYFlightCity *orgCity;
@property (nonatomic, strong) HYFlightCity *dstCity;
@property (nonatomic, strong) HYCabins *cabin;  //其实是cabin type
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *backDate;
//@property (nonatomic, assign) NSTimeInterval startTimestamp; //出发时间戳
//@property (nonatomic, assign) NSTimeInterval backTimestamp; //返回时间戳 不一定有,只有在查询往返航班的时候才有
@property (nonatomic, assign) BOOL singleWay;

@end
