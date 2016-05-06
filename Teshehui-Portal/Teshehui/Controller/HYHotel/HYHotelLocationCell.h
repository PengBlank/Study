//
//  HYHotelLocationCellV2.h
//  Teshehui
//
//  Created by RayXiang on 14-8-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelViewBaseCell.h"

@protocol HYHotelLocationCellV2Protocol <NSObject>
@optional
- (void)hotelLocationCellDidClickCityBtn;
- (void)hotelLocationCellDidClickLocateBtn;

@end

/**
 *  酒店搜索界面位置cell
 */
@interface HYHotelLocationCell : HYHotelViewBaseCell

@property (nonatomic, weak) id<HYHotelLocationCellV2Protocol> delegate;

@property (nonatomic, strong) UILabel *locationLab;

@end
