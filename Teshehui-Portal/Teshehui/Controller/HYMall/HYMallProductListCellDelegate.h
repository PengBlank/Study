//
//  HYMallProductListCellDelegate.h
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallHomeBoard.h"
#import "HYMallChannelBoard.h"

@protocol HYMallProductListCellDelegate <NSObject>

@optional
- (void)checkProductDetail:(id)product;
- (void)didSelectType:(BusinessType)type;
- (void)refreshRecomment;
- (void)checkMoreStore;
- (void)checkMoreSpecialCheap;
- (void)checkVideoWithURL:(NSString *)url;

- (void)checkBannerItem:(id)product withBoard:(id)board;

@end