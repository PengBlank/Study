//
//  DetailCell1.h
//  Teshehui
//
//  Created by apple_administrator on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "DLStarRatingControl.h"
#import "BusinessdetailInfo.h"
@interface DetailCell1 : BaseCell

@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,strong) UILabel                    *scoreLabel;
@property (nonatomic,strong) UILabel                    *countLabel;
@property (nonatomic,strong) UIImageView                *imageV;
@property (nonatomic,strong) DLStarRatingControl        *starView;

-  (void)bindDataWithDetailSection1:(BusinessdetailInfo *)info;
@end
