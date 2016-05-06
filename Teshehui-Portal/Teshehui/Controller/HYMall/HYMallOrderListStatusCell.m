//
//  HYMallOrderListStatusCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderListStatusCell.h"

@implementation HYMallOrderListStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        
        self.detailTextLabel.textColor = [UIColor colorWithRed:161.0/255.0
                                                         green:0
                                                          blue:0
                                                         alpha:1.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 14, 13)];
        _iconView.image = [UIImage imageNamed:@"icon_shop"];
        [self.contentView addSubview:_iconView];
        
//        UIImageView *assView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenRect.size.width-17, 13, 7, 12)];
//        assView.image = [UIImage imageNamed:@"cell_indicator"];
//        [self.contentView addSubview:assView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(28, 9, 250, 20);
    self.detailTextLabel.frame = CGRectMake(ScreenRect.size.width-106, 9, 86, 20);
}

#pragma mark setter/getter
- (void)setStatusDesc:(NSString *)statusDesc
{
    if (statusDesc != _statusDesc)
    {
        _statusDesc = statusDesc;
        self.detailTextLabel.text = statusDesc;
    }
}

- (void)setMainOrderTitle:(NSString *)mainOrderTitle
{
    if (mainOrderTitle != _mainOrderTitle)
    {
        _mainOrderTitle = mainOrderTitle;
        self.textLabel.text = [NSString stringWithFormat:@"主订单号：%@",mainOrderTitle];
    }
}

@end
