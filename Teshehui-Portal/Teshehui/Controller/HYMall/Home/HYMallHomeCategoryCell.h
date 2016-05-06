//
//  HYMallHomeCategoryCell.h
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallHomeItem.h"
#import "HYMallProductListCellDelegate.h"

@interface HYMallHomeCategoryCell : HYBaseLineCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, weak) id<HYMallProductListCellDelegate> delegate;

@end
