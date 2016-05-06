//
//  HYProductDetailAdsScrollView.h
//  Teshehui
//
//  Created by Kris on 16/3/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAdsScrollView.h"
#import "HYMallGoodsDetail.h"

@protocol HYProductDetailAdsScrollViewDelegate <NSObject>
@end

@protocol HYProductDetailAdsScrollViewDataSource <NSObject>

@required
- (NSArray *)adsContents;

@end

@interface HYProductDetailAdsScrollView : UIView

@property (nonatomic, weak) id <HYProductDetailAdsScrollViewDelegate> delegate;
@property (nonatomic, weak) id <HYProductDetailAdsScrollViewDataSource> dataSource;
@property (nonatomic, assign) BOOL hasComparePriceData;

- (void)setGoodDetail:(HYMallGoodsDetail *)goodDetail;
- (void)reloadData;
@end


