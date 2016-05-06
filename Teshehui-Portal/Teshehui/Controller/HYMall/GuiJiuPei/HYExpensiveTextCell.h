//
//  HYExpensiveTextCell.h
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@protocol HYExpensiveTextCellDelegate <NSObject>

- (void)expensiveTextCellDidGetText:(NSString *)string;

@end

@interface HYExpensiveTextCell : HYBaseLineCell

@property (nonatomic, weak) id <HYExpensiveTextCellDelegate> delegate;

@end
