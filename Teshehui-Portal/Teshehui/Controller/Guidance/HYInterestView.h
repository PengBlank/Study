//
//  HYInterestView.h
//  Teshehui
//
//  Created by Charse on 16/4/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYInterestView : UIView

@property (nonatomic, assign) NSInteger maxSelectCount;
@property (nonatomic, copy) void (^completeSelect)(NSArray *selectedIdxs);
@property (nonatomic, copy) void (^skip)(void);

- (void)bindWithData:(NSArray *)data selectedIndexs:(NSArray *)data2;

@end
