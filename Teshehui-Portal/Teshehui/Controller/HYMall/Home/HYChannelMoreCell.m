//
//  HYChannelMoreCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelMoreCell.h"

@interface HYChannelMoreCell ()

@property (nonatomic, strong) HYChannelMoreProductView *leftView;
@property (nonatomic, strong) HYChannelMoreProductView *rightView;
@end

@implementation HYChannelMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        _leftView = [[HYChannelMoreProductView alloc] initWithFrame:
                     CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        [self.contentView addSubview:_leftView];
        
        _rightView = [[HYChannelMoreProductView alloc] initWithFrame:
                      CGRectMake(self.frame.size.width/2,
                                 0,
                                 self.frame.size.height/2,
                                 self.frame.size.height)];
        [self.contentView addSubview:_rightView];
        [_leftView addTarget:self action:@selector(checkDetail:) forControlEvents:UIControlEventTouchUpInside];
        [_rightView addTarget:self action:@selector(checkDetail:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _leftView.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    _rightView.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
}

- (void)checkDetail:(UIControl *)ctl
{
    HYChannelMoreProductView *view = nil;
    if ([ctl isKindOfClass:[HYChannelMoreProductView class]])
    {
        view = (HYChannelMoreProductView *)ctl;
    }
    if ([self.delegate respondsToSelector:@selector(checkBannerItem:withBoard:)])
    {
        if (view.item != nil)
        {
            [self.delegate checkBannerItem:view.item withBoard:nil];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
