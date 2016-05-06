//
//  HYFavoritesCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallFavouriteItem.h"

@protocol HYFavoritesCellDelegate <NSObject>

@optional
- (void)didDeleteFavoriteWithGoods:(HYMallFavouriteItem *)goodsinfo;
- (void)didSelectStoreWithGoods:(HYMallFavouriteItem *)goodsInfo;
@end

@interface HYFavoritesCell : HYBaseLineCell

@property (nonatomic, weak) id<HYFavoritesCellDelegate>delegate;
@property (nonatomic, strong) HYMallFavouriteItem *goodsinfo;

@end
