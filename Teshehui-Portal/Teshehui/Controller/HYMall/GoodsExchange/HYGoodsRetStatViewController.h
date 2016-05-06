//
//  HYGoodsRetStatViewController.h
//  Teshehui
//
//  Created by RayXiang on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYMallReturnsInfo.h"
#import "HYGoodsRetGrayCell.h"
#import "HYGoodsRetDetailCell.h"
#import "HYGoodsRetPhotoCell.h"
#import "HYGoodsRetWarningCell.h"
#import "HYGoodsRetEntryCell.h"

#define HYGoodsRet_DetailCellHeight 80
#define HYGoodsRet_PhotoCellHeight  80
#define HYGoodsRet_ProgressCellHeight 95
#define HYGoodsRet_NormalCellHeight 42

/**
 *  退换货状态
 */

@interface HYGoodsRetStatViewController : HYMallViewBaseController
<UITableViewDataSource, UITableViewDelegate>
{
    HYRefundStatus _refundStatus;
    NSInteger _refundType;
    UITableView *_tableView;
}
@property (nonatomic, strong) HYMallReturnsInfo *returnsInfo;
@property (nonatomic, assign) HYRefundStatus refundStatus;
@property (nonatomic, assign) NSInteger refundType;
@property (nonatomic, strong, readonly) UITableView *tableView;

+ (instancetype)statViewControllerWithRetusnInfo:(HYMallReturnsInfo *)retufnInfo;

//protected 这些都是可复用的cell
- (HYGoodsRetGrayCell *)statCell;
- (HYGoodsRetGrayCell *)serviceTypeCell;
- (UITableViewCell *)progressCell;
- (HYGoodsRetDetailCell *)detailCell;
- (UITableViewCell *)photoCell;
- (UITableViewCell *)numCell;
- (HYGoodsRetGrayCell *)infoCellWithInfo:(NSDictionary *)info;
- (HYGoodsRetWarningCell *)warningCellWithWarning:(NSString *)warning;

//public 返回步数，用于显示prgress，由refundStatus得到
- (NSInteger)refundStep;

@property (nonatomic, copy) void (^refundCallback)(HYMallReturnsInfo *returnInfo, HYRefundStatus status);

@end
