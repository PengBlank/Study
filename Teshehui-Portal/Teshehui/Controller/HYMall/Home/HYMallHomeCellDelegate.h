//
//  HYMallHomeCellDelegate.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#ifndef HYMallHomeCellDelegate_h
#define HYMallHomeCellDelegate_h

@protocol HYMallHomeCellDelegate <NSObject>

@optional
- (void)didClickWithBoardType:(NSInteger)boardType itemAtIndex:(NSInteger)idx;

@end

#endif /* HYMallHomeCellDelegate_h */
