//
//  HYChannelCategoryCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelCategoryCell.h"

@interface HYChannelCategoryCell ()
@property (nonatomic, strong) UIScrollView *cateScroll;
@end

@implementation HYChannelCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        _cateScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _cateScroll.bounces = NO;
        _cateScroll.scrollsToTop = NO;
        [self.contentView addSubview:_cateScroll];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _cateScroll.frame = self.bounds;
}

- (void)setItems:(NSArray<HYChannelCategory*> *)items
{
    if (_items != items)
    {
        _items = items;
        
        CGFloat x = 0;
        CGFloat space = 10;
        for (int i = 0; i < _items.count; i++)
        {
            HYChannelCategory *cate = [_items objectAtIndex:i ];
            CGFloat titleWidth = [cate.categoryName sizeWithFont:[UIFont systemFontOfSize:14.0]].width;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, titleWidth+2*space, self.frame.size.height)];
            btn.tag = i + 1;
            [btn setTitle:cate.categoryName forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [btn addTarget:self action:@selector(cateAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor colorWithWhite:.33 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:60/255.0 blue:85/255.0 alpha:1] forState:UIControlStateSelected];
            [self.cateScroll addSubview:btn];
            x += titleWidth + 2*space;
            if (i != items.count - 1)
            {
                UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(x, 10, .5, self.frame.size.height-20)];
                sep.backgroundColor = [UIColor colorWithWhite:.83 alpha:1];
                [self.cateScroll addSubview:sep];
            }
        }
        self.cateScroll.contentSize = CGSizeMake(x, self.cateScroll.frame.size.height);
        if (x < self.cateScroll.frame.size.width)
        {
            CGFloat offset = (self.cateScroll.frame.size.width - x) / 2;
            self.cateScroll.contentInset = UIEdgeInsetsMake(0, offset, 0, offset);
        }
        _selectedIdx = -1;
    }
}

- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    if (_selectedIdx != selectedIdx)
    {
        _selectedIdx = selectedIdx;
        for (UIView *view in self.cateScroll.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)view;
                if (btn.tag - 1 == _selectedIdx)
                {
                    btn.selected = YES;
                }
                else
                {
                    btn.selected = NO;
                }
            }
        }
    }
}

- (void)cateAction:(UIButton *)btn
{
    //HYChannelCategory *cate = [self.items objectAtIndex:btn.tag-1];
    if (self.cateCallback)
    {
        self.cateCallback(btn.tag - 1);
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
