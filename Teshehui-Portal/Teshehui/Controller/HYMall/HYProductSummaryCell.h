//
//  HYProductSummaryCell.h
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *  商品详情界面的摘要
 */
#import "HYBaseLineCell.h"
#import "HYMallGoodsDetail.h"
@protocol HYProductSummaryCellDelegate <NSObject>

@optional
- (void)beginRighting;
- (void)playVideoWithUrl:(NSURL *)url;
- (void)shareProduct;
- (void)memberUpgrad;
- (void)comparePrice;
- (void)checkServiceDesc;
- (void)quantityChange:(NSUInteger)qunatity callBack:(void(^)(BOOL finished))callBack;

@end

@interface HYProductSummaryCell : HYBaseLineCell

@property (nonatomic, strong, readonly) UIImageView *cameraView;

@property (nonatomic, strong) HYMallGoodsDetail *goodsDetail;
@property (nonatomic, weak) id<HYProductSummaryCellDelegate>delegate;
@property (nonatomic, copy) NSString *stgId;

- (void)setPlayAnimations:(BOOL)play;
- (void)showComparePriceButton;

@end

