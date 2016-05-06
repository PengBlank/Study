//
//  HYMallHomeLoadMoreView.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/5.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMallHomeLoadMoreView : UICollectionReusableView

@property (nonatomic, readonly, retain) UIActivityIndicatorView *loadView;
@property (nonatomic, readonly, retain) UILabel *loadText;

- (void)startLoadMore;
- (void)stopLoadMore;

@property (nonatomic, readonly,assign) BOOL loadFinish;

@end
