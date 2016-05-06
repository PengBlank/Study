//
//  HYMallHomeCategoryCell.m
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeCategoryCell.h"
#import "UIImageView+WebCache.h"
#import "HYAutolayoutBtn.h"

@interface HYMallHomeCategoryCell ()
{
    
}
@end

@implementation HYMallHomeCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        
        UIImageView *_lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        _lineView1.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:0];
        _lineView1.tag = 10000;
        [self addSubview:_lineView1];
        
        UIImageView *_lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, frame.size.width, 1)];
        _lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                      topCapHeight:0];
        _lineView1.tag = 10001;
        [self addSubview:_lineView2];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(6, 7, 160, 20);
}

#pragma mark - private methods
- (void)updateView
{
    for (UIView *v in [self.contentView subviews])
    {
        [v removeFromSuperview];
    }
    
    for (int i=0; i<[self.categorys count]; i++)
    {
        HYMallHomeItem *s = [self.categorys objectAtIndex:i];
        HYAutolayoutBtn *btn = [[HYAutolayoutBtn alloc] initWithTitle:s.name
                                                                image:nil];
        
        
        btn.frame = CGRectMake(ScreenRect.size.width/2*(i%2), i/2*64+35, ScreenRect.size.width/2-1, 62);
        btn.imageView.frame = CGRectMake(btn.frame.size.width-61, 1, 60, 60);
        btn.titleLabel.frame = CGRectMake(10, 21, 60, 20);
        
        [btn.titleLabel setTextColor:[UIColor blackColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.tag = i;
        [btn.imageView setClipsToBounds:YES];
        [btn addTarget:self
                action:@selector(didCheckCategory:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn.imageView sd_setImageWithURL:[NSURL URLWithString:s.pictureUrl]];
        [self.contentView addSubview:btn];
        
        if (!(i%2))
        {
            UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width,
                                                                                   btn.frame.origin.y,
                                                                                   1,
                                                                                   64)];
            lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                       topCapHeight:2];
            [self.contentView addSubview:lineView1];
            
            UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, i/2*64+98, ScreenRect.size.width, 1)];
            lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
                                                                                         topCapHeight:2];
            [self.contentView addSubview:lineView2];
        }
    }
}

#pragma mark setter/getter
- (void)setTitle:(NSString *)title
{
    if (title != _title)
    {
        _title = title;
        self.textLabel.text = title;
    }
}

- (void)setCategorys:(NSArray *)categorys
{
    if (categorys != _categorys)
    {
        _categorys = categorys;
        [self updateView];
    }
}

#pragma mark private methods
- (void)didCheckCategory:(UIButton *)sender
{
    if (sender.tag < [self.categorys count])
    {
        HYMallHomeItem *s = [self.categorys objectAtIndex:sender.tag];
        
        if ([self.delegate respondsToSelector:@selector(checkProductDetail:)])
        {
            [self.delegate checkProductDetail:s];
        }
    }
}

@end
