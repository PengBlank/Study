//
//  HYMineInfoOrderCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMineInfoOrderCell.h"
#import "HYImageButton.h"
#import "Masonry.h"

@interface HYMineInfoOrderCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HYMineInfoOrderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //height 60
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(ScreenRect), 60);
        self.separatorLeftInset = 0;
        
        CGFloat width = CGRectGetWidth(self.frame) /4;
        
        NSArray *imgs = [NSArray arrayWithObjects:[UIImage imageNamed:@"mine_icon_order1"],
                         [UIImage imageNamed:@"mine_icon_order2"],
                         [UIImage imageNamed:@"mine_icon_order3"],
                         [UIImage imageNamed:@"mine_icon_order4"],
                        nil];
        
        NSArray *titles = nil;
        titles = [NSArray arrayWithObjects:@"待付款",
                  @"待发货",
                  @"待收货",
                  @"售后服务",
                   nil];
        
        
        CGFloat x = 0;
        CGFloat h = CGRectGetHeight(self.frame);
        for (int i = 0; i < titles.count; i++)
        {
            HYImageButton *btn = [[HYImageButton alloc] initWithFrame:CGRectMake(x, 0, width, h)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setImage:imgs[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
            btn.spaceInTestAndImage = 5;
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            btn.tag = 1000 + i;
            
            x += width + 1;
        }
    }
    return self;
}

- (void)setCount:(NSInteger)count forType:(HYMineInfoOrderActionType)type
{
    if (count > 0)
    {
        NSString *showCount = [NSString stringWithFormat:@"%ld", (long)count];
        if (count < 9) {
            showCount = [NSString stringWithFormat:@" %ld ", (long)count];
        }
        [[self countLabelForType:type] setText:showCount];
        [[self countLabelForType:type] setNeedsLayout];
    }
    else
    {
        
        UILabel *label = [self countLabelForType:type];
        label.hidden = YES;
    }
}

- (UILabel *)countLabelForType:(HYMineInfoOrderActionType)type
{
    UILabel *label = (UILabel *)[self viewWithTag:type+2000];
    if (!label)
    {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 6.5;
        label.hidden = NO;
        label.tag = 2000 + type;
        [self.contentView addSubview:label];
        
        HYImageButton *btn = [self viewWithTag:type+1000];
        if (btn)
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.imageView.mas_right);
                make.centerY.equalTo(btn.imageView.mas_top);
            }];
        }
    }
    label.hidden = NO;
    [label setNeedsLayout];
    [label layoutIfNeeded];
    return label;
}

- (void)btnAction:(UIButton *)btn
{
    if (self.orderCellCallback)
    {
        self.orderCellCallback(btn.tag - 1000);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
