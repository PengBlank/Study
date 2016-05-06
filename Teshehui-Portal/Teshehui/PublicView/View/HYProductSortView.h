//
//  HYProductFilterView.h
//  Teshehui
//
//  Created by HYZB on 14-9-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ProductSortType{
    SortWithPrice = 1,
    SortWithSales,
    SortWithCreateTime
}ProductSortType;

@protocol HYProductSortViewDelegate <NSObject>

@optional
- (void)didSortWithType:(ProductSortType)sortType ascend:(BOOL)ascend;

@end

@interface HYProductSortView : UIView

@property(nonatomic, weak) id<HYProductSortViewDelegate> delegate;
@property(nonatomic, assign) BOOL needRelayout;
@property(nonatomic, assign) BOOL showTopLine;
@property(nonatomic, strong) UIButton *shaiXuanBtn;

//- (void)relayoutBtn;

@end
