//
//  HYAllCategoryViewDataSource.h
//  Teshehui
//
//  Created by Kris on 15/6/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYQRCodeGetShopCategoryResponse.h"


@interface HYAllCategoryViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, assign) NSInteger filterType;
@property (nonatomic, strong) NSMutableArray<HYQRCodeGetShopCategory> *categoryItems;
@property (nonatomic, strong) NSMutableArray<HYQRCodeGetShopCategory> *secondLevelItems;
@property (nonatomic, strong) NSMutableArray *sortItems;
@property (nonatomic, weak) UITableView *allCategorySelectTableView;


@end
