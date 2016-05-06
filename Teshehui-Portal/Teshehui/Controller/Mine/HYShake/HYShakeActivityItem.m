//
//  HYShakeActivityItem.m
//  Teshehui
//
//  Created by HYZB on 16/3/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeActivityItem.h"
#import "HYShakeViewModel.h"

@interface HYShakeActivityItem ()

@property (nonatomic, strong) UIImageView *activityImg;
@property (nonatomic, strong) UILabel *desc;


@end


@implementation HYShakeActivityItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView
{
    UIImageView *activityImg = [[UIImageView alloc] init];
    _activityImg = activityImg;
    [self addSubview:activityImg];
    
    // 162 171 174
    UILabel *desc = [[UILabel alloc] init];
    desc.textColor = [UIColor colorWithRed:162/255.0f green:171/255.0f blue:174/255.0f alpha:1.0f];
    _desc = desc;
    desc.font = [UIFont systemFontOfSize:20];
    desc.textAlignment = NSTextAlignmentCenter;
//    desc.text = @"把爱带回家-黄金专场";
    [self addSubview:desc];
    
    CGFloat btnY = CGRectGetMaxY(desc.frame)+20;
    // 246 61 82
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(self.center.x-50, btnY, 100, 40);
    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    detailBtn.layer.cornerRadius = 6;
    detailBtn.backgroundColor = [UIColor colorWithRed:246/255.0f green:61/255.0f blue:82/255.0f alpha:1.0f];
    _detailBtn = detailBtn;
    [self addSubview:detailBtn];
}

- (void)layoutSubviews
{
    CGFloat x = 10;
    CGFloat y = 30;
    CGFloat width = self.frame.size.width - 20;
    CGFloat height = 150;
    _activityImg.frame = CGRectMake(x, y, width, height);
    
    _desc.frame = CGRectMake(10, CGRectGetMaxY(_activityImg.frame)+20, CGRectGetWidth(_activityImg.frame), 23);
    
    CGFloat btnY = CGRectGetMaxY(_desc.frame)+10;
    _detailBtn.frame = CGRectMake(self.center.x-50, btnY, 100, 40);
}

- (void)setShakeModel:(HYShakeViewModel *)shakeModel
{
    _activityImg.image = [UIImage imageNamed:@"pic_shake_activity"];
    _desc.text = shakeModel.shakeName;
}

@end
