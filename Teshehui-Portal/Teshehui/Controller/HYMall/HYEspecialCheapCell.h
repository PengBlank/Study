//
//  HYEspecialCheapCell.h
//  Teshehui
//
//  Created by Kris on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallProductListCellDelegate.h"

@interface HYEspecialCheapCell : HYBaseLineCell

@property (nonatomic, assign) id<HYMallProductListCellDelegate> delegate;
@property (nonatomic, strong) NSArray *especialCheapData;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIButton *more;
@property (nonatomic, strong) NSArray *items;
//@property (nonatomic, strong) NSArray *hotScale;
@end
