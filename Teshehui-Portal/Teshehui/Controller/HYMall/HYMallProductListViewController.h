//
//  HYMallProductLIstViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 产品列表界面
 */

#import "HYMallViewBaseController.h"
#import "HYMallHomeItem.h"
#import "HYMallProductListCell.h"
#import "HYShoppingCarView.h"
#import "HYMallMainHotRecommendCell.h"
#import "HYMallSearchGoodsRequest.h"
#import "HYActivityGoodsRequest.h"
#import "HYMallMoreGoodsRequest.h"

typedef NS_ENUM(NSInteger, HYMallProductListStyle)
{
    ProductListStyleFlush,
    ProductListStyleRowCell
};

@interface HYMallProductListViewController : HYMallViewBaseController
<
UITableViewDelegate,
UITableViewDataSource,
HYMallProductListCellDelegate,
HYBuyCarViewDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) BOOL showRecommendGoods;  //是否显示推荐商品，显示推荐商品的时候不需要item信息，使用默认接口 默认NO

@property (nonatomic, strong) NSString *curSearchCategoryId;
@property (nonatomic, strong) NSString *curSearchBrandId;
@property (nonatomic, strong) HYMallSearchGoodsRequest *getSearchDataReq;
@property (nonatomic, strong) HYActivityGoodsRequest *getActiveDataReq;
@property (nonatomic, strong) HYMallMoreGoodsRequest *getMoreGoodsReq;

//Default Flush
@property (nonatomic, assign) HYMallProductListStyle style;


@end
