//
//  HYCIFillCarInfoViewController.h
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 * 填写车的信息
 */

#import "HYMallViewBaseController.h"
#import "HYCIGetCarFillInfoListReq.h"
@class HYCIQuoteViewController;

@protocol AdditionInfoDelegate <NSObject>
@required
- (void)setCarInfoList:(NSArray *)list;
- (void)loadQuoteInfo;
@end

@interface HYCIFillCarInfoViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) HYCIOwnerInfo *ownerInfo;

@property (nonatomic, copy) NSString *infoKey;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) NSDictionary *packageTypeMap;
@property (nonatomic, strong) NSArray *carInfoFillList;
@property (nonatomic, strong) NSArray *carInfoAllList;

@property (nonatomic, assign) BOOL isAdditionInfo;  //补录
@property (nonatomic, weak) id<AdditionInfoDelegate> additionForController;

@property (nonatomic, strong) NSString *vichelSearchKey;
@end
