//
//  HYChannelBrandCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelBrandCell.h"
#import "UIButton+WebCache.h"


@interface HYChannelBrandCell()
//UI Buttons
//爆力解决法!
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIImageView *lineView1;
@property (nonatomic, strong) UIImageView *lineView2;
@property (nonatomic, strong) UIImageView *lineView3;
@property (nonatomic, strong) UIImageView *lineView4;
@end

@implementation HYChannelBrandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        //竖线
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView1];
        _lineView1 = lineView1;
        
        UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        lineView2.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView2];
        _lineView2 = lineView2;
        
        //横线
        
//        UIImageView *lineView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
//        lineView4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
//        [self.contentView addSubview:lineView4];
//        _lineView4 = lineView4;
        
        _buttons = [NSMutableArray array];
        for (int i = 0; i < 3; i++)
        {
            UIButton *btn = [self createButton];
            btn.tag = i + 1;
            [_buttons addObject:btn];
        }
    }
    return self;
}

- (UIButton *)createButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.tag = 1;
    [btn addTarget:self
            action:@selector(checkItemDetail:)
  forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGFloat xsep1 = frame.size.width/3;
    CGFloat xsep2 = frame.size.width/3*2;
//    CGFloat ysep2 = frame.size.height;
    
    //竖线
    _lineView1.frame = CGRectMake(xsep1, 0, 1, frame.size.height);
    _lineView2.frame = CGRectMake(xsep2, 0, 1, frame.size.height);
    //横线
//    _lineView4.frame = CGRectMake(0, ysep2, frame.size.width, 0.5);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = frame.size.width/3;
    CGFloat height = frame.size.height;
    for (int i = 0; i < 3; i++)
    {
        UIButton *btn = [_buttons objectAtIndex:i];
        btn.frame = CGRectMake(x, y, width, height);
        x += width + 1;
    }
}

- (void)setChannelBoard:(HYMallChannelBoard *)channelBoard
{
    if (_channelBoard != channelBoard) {
        _channelBoard = channelBoard;
    }
}

- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        
        for (int i = 0; i < _items.count && i < 3; i++)
        {
            HYMallChannelItem *item = [_items objectAtIndex:i];
            UIButton *button = [_buttons objectAtIndex:i];
            if (item.image.length > 0)
            {
                NSURL *url = [NSURL URLWithString:item.image];
                [button sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading"]];
            }
        }
    }
}

#pragma mark - private methods
- (void)checkItemDetail:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkBannerItem:withBoard:)])
    {
        if ((sender.tag-1) < [self.items count])
        {
            HYMallChannelItem *item = [self.items objectAtIndex:(sender.tag-1)];
            [self.delegate checkBannerItem:item withBoard:self.channelBoard];
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
