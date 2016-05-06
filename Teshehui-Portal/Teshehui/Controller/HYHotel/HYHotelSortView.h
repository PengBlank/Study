//
//  HYHotelSortView.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYPopUpView.h"

@protocol HYHotelSortDelegate <NSObject>
- (void)hotelSortViewDidSelectIndex:(NSInteger)index;
@end

@interface HYHotelSortView : HYPopUpView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<HYHotelSortDelegate> delegate;

@property (nonatomic, assign) NSInteger selectedIdx;

@end
