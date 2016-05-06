//
//  HYMallNullView.h
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYNullView.h"

@protocol HYMallNullViewDelegate <NSObject>

@optional
- (void)goBackToMallHomeFromButton:(UIButton *)sender;

@end

@interface HYMallNullView : HYNullView

@property (nonatomic, assign) NSInteger filterype;
@property (nonatomic, weak) id<HYMallNullViewDelegate> delegate;

@end
