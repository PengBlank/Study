//
//  HYMallMainProductListCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductCellData.h"
#import "HYMallProductListCellDelegate.h"

@interface HYMallMainProductListCell : HYBaseLineCell

@property (nonatomic, weak) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) HYMallProductCellData *cellData;

@end
