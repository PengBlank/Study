//
//  HYMallMailHotRecommendCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductListCellDelegate.h"

typedef enum _MallRecommendTpye
{
    WeeklyNewProduct = 1,
    HotScaleProduct
}MallRecommendTpye;

@interface HYMallMainHotRecommendCell : HYBaseLineCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) NSArray *hotScale;

@end
