//
//  HYChannelHotCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelHotCell.h"
#import "Masonry.h"
#import "HYMallHomeItem.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface HYChannelHotCellView : UIView

@property (nonatomic, strong) UIImageView *title;
@property (nonatomic, strong) UIImageView *content;

@end

@implementation HYChannelHotCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectZero];
        title.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(12);
        }];
        self.title = title;
        
        UIImageView *content = [[UIImageView alloc] initWithFrame:CGRectZero];
        content.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(title.mas_bottom).offset(10);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-1);
        }];
        self.content = content;
    }
    return self;
}

@end

@interface HYChannelHotCell ()

@property (nonatomic, strong) HYChannelHotCellView *button1;
@property (nonatomic, strong) HYChannelHotCellView *button2;
@property (nonatomic, strong) UIButton *button3;

@end

@implementation HYChannelHotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        lineView2.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView2];
        
        _button1 = [[HYChannelHotCellView alloc] initWithFrame:CGRectZero];
        _button1.tag = 1;
        _button1.title.image = [UIImage imageNamed:@"hot_title"];
        [self.contentView addSubview:_button1];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_button1 addGestureRecognizer:tap1];
        
        _button2 = [[HYChannelHotCellView alloc] initWithFrame:CGRectZero];
        _button2.tag = 2;
        _button2.title.image = [UIImage imageNamed:@"new_title"];
        [self.contentView addSubview:_button2];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_button2 addGestureRecognizer:tap2];
        
        _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button3.frame = CGRectZero;
        _button3.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _button3.tag = 3;
        [_button3 addTarget:self
                     action:@selector(checkItemDetail:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button3];
        
        //layout
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.contentView.mas_right).dividedBy(3.);
            make.width.mas_equalTo(.5);
        }];
        
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.contentView.mas_right).multipliedBy(0.66);
            make.width.mas_equalTo(0.5);
        }];
        
        [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.equalTo(self.contentView.mas_width).dividedBy(3.0);
            make.height.equalTo(self.contentView.mas_height);
        }];
        
        [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(lineView1.mas_right);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.contentView.mas_width).dividedBy(3.0);
        }];
        
        [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(lineView2.mas_right);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.contentView.mas_width).dividedBy(3.0);
        }];
    }
    return self;
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

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self checkItemDetail:(UIButton *)tap.view];
}

//- (void)setChannelBoard:(HYMallChannelBoard *)channelBoard
//{
//    if (_channelBoard != channelBoard) {
//        _channelBoard = channelBoard;
//        [self setItems:channelBoard.channelBannerList];
//    }
//}

- (void)setItems:(NSArray<HYMallChannelItem*> *)items
{
    if (items != _items)
    {
        _items = items;
        
        for (int i=0; i<3&&i<[items count]; i++)
        {
            HYMallChannelItem *item = [self.items objectAtIndex:i];
            
            if (i == 0)
            {
                [_button1.content sd_setImageWithURL:[NSURL URLWithString:item.image]
                            placeholderImage:[UIImage imageNamed:@"loading"]];
            }
            else if (i == 1)
            {
                [_button2.content sd_setImageWithURL:[NSURL URLWithString:item.image]
                            placeholderImage:[UIImage imageNamed:@"loading"]];
            }
            else if (i == 2)
            {
                [_button3 sd_setImageWithURL:[NSURL URLWithString:item.image]
                                     forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"loading"]];
            }
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
