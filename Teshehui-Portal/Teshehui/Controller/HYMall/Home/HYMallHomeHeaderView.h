//
//  HYMallHomeHeaderView.h
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYAdsScrollView.h"

#import "HYMallProductListCellDelegate.h"
#import "HYMallHomeCellDelegate.h"

@interface HYMallHomeHeaderView : UIView
<
HYAdsScrollViewDataSource,
HYAdsScrollViewDelegate
>
{
    HYAdsScrollView *_adsView;
    
    UIButton *_lastBtn;
    UILabel *_lastLab;
}

@property (nonatomic, assign) id<HYMallHomeCellDelegate> delegate;
//@property (nonatomic, strong) HYMallHomeBoard *board;
@property (nonatomic, strong) HYMallChannelBoard *channelBoard;
@property (nonatomic, strong) NSArray *adsData;
@property (nonatomic, assign) BOOL supportCarInsurance;

@property (nonatomic, assign) NSInteger boardType;


@end
