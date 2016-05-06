//
//  BusinessDetailCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
#import "BusinessdetailInfo.h"
@interface BusinessDetailCell : BaseCell
{
    NSString *string;
    NSInteger _index;
}
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UILabel        *contentLabel;
@property (nonatomic,strong) UIImageView    *imageV;
@property (nonatomic,strong) UIButton       *phoneBtn;

- (void)bindData:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)indexPath;
- (CGFloat)cellHeight;
@end
