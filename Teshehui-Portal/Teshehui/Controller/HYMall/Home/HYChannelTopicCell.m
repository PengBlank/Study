//
//  HYChannelTopicCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelTopicCell.h"
#import "HYMallHomeItem.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"

@interface HYChannelTopicCell ()

//UI Buttons
//爆力解决法!
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIImageView *lineView1;
@property (nonatomic, strong) UIImageView *lineView2;
@property (nonatomic, strong) UIImageView *lineView3;
@property (nonatomic, strong) UIImageView *lineView4;
@end

@implementation HYChannelTopicCell

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
        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
                                                                                     topCapHeight:2];
        [self.contentView addSubview:lineView3];
        _lineView3 = lineView3;
        
        UIImageView *lineView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
        lineView4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
                                                                                     topCapHeight:2];
        [self.contentView addSubview:lineView4];
        _lineView4 = lineView4;
        
        self.button1 = [self createButton];
        self.button1.tag = 1;
        
        self.button2 = [self createButton];
        self.button2.tag = 2;
        
        self.button3 = [self createButton];
        self.button3.tag = 3;
        
        self.button4 = [self createButton];
        self.button4.tag = 4;
        
        self.button5 = [self createButton];
        self.button5.tag = 5;
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
    CGFloat xsep1 = frame.size.width*0.4;
    CGFloat xsep2 = frame.size.width*0.7;
    CGFloat ysep = frame.size.height/2;
    
    //竖线
    _lineView1.frame = CGRectMake(xsep1, 0, 1, frame.size.height);
    _lineView2.frame = CGRectMake(xsep2, 0, 1, frame.size.height);
    //横线
    _lineView3.frame = CGRectMake(xsep1, ysep, frame.size.width-xsep1, 1);
//    _lineView4.frame = CGRectMake(0, frame.size.height-1, frame.size.width, .5);
    
    self.button1.frame = CGRectMake(0, 0, xsep1, frame.size.height);
    self.button2.frame = CGRectMake(xsep1+1, 0, xsep2-xsep1-1, ysep);
    self.button3.frame = CGRectMake(xsep2+1, 0, self.frame.size.width-xsep2, ysep);
    self.button4.frame = CGRectMake(xsep1+1, ysep, xsep2-xsep1-1, ysep);
    self.button5.frame = CGRectMake(xsep2+1, ysep, self.frame.size.width-xsep2, ysep);
}

- (void)setChannelBoard:(HYMallChannelBoard *)channelBoard
{
    if (_channelBoard != channelBoard) {
        _channelBoard = channelBoard;
        [self setItems:channelBoard.channelBannerList];
    }
}


- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        for (int i=0; i<5&&i<[items count]; i++)
        {
            HYMallChannelItem *item = [self.items objectAtIndex:i];
            
            if (i == 0)
            {
                [_button1 sd_setImageWithURL:[NSURL URLWithString:item.image]
                                    forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                [_button2 sd_setImageWithURL:[NSURL URLWithString:item.image]
                                    forState:UIControlStateNormal];
            }
            else if (i == 2)
            {
                [_button3 sd_setImageWithURL:[NSURL URLWithString:item.image]
                                    forState:UIControlStateNormal];
            }
            else if (i == 3)
            {
                [_button4 sd_setImageWithURL:[NSURL URLWithString:item.image]
                                    forState:UIControlStateNormal];
            }
            else if (i == 4)
            {
                [_button5 sd_setImageWithURL:[NSURL URLWithString:item.image]
                                    forState:UIControlStateNormal];
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
