//
//  HYMasterTableViewCell.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-8.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "SKSTableViewCell.h"

@interface HYMasterTableViewCell : SKSTableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong, readonly) UIImageView *indicatorImg;
@property (nonatomic, strong) UIImageView *icon;

@end
