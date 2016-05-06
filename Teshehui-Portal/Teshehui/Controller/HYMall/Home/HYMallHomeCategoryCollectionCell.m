//
//  HYMallHomeCategoryCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeCategoryCollectionCell.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"
#import "UIImageView+WebCache.h"

@interface HYMallHomeCategoryCollectionCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation HYMallHomeCategoryCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.font = [UIFont systemFontOfSize:13.0];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor colorWithHexColor:@"121212" alpha:1];
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 2;
        [self.contentView addSubview:title];
        self.titleLab = title;
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectZero];
        desc.font = [UIFont systemFontOfSize:12.0];
        desc.backgroundColor = [UIColor clearColor];
        desc.textColor = [UIColor colorWithHexColor:@"888888" alpha:1];
        desc.numberOfLines = 2;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:desc];
        self.descLab = desc;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:img];
        img.contentMode = UIViewContentModeScaleAspectFit;
        self.icon = img;
        
        //这里避免设置不成功
        _style = 3;
        
        //默认测试数 据
        self.icon.image = [UIImage imageNamed:@"loading"];
        
        //line
        //竖线
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*0.4, 0, 1, frame.size.height)];
//        lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
//                                                                                   topCapHeight:2];
        lineView1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
        
        //横线
        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*0.4, frame.size.height/2, frame.size.width*0.6, 1)];
//        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setStyle:(HYMallHomeCategoryStyle)style
{
    if (_style != style)
    {
        _style = style;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_style == HYMallHomeCategoryHorizontal)
    {
        CGRect frame = self.icon.frame;
        frame.size = CGSizeMake(self.frame.size.width*0.42, self.frame.size.height*0.82);
        frame.origin.y = self.frame.size.height/2 - frame.size.height/2;
        frame.origin.x = self.frame.size.width - 12 - frame.size.width;
        self.icon.frame = frame;
        
        frame = self.titleLab.frame;
        frame.origin.x = 10;
        frame.origin.y = 8;
        frame.size.width = CGRectGetMinX(_icon.frame)-frame.origin.x;
//        frame.size.height = self.frame.size.height - frame.origin.y;
        frame.size.height = _titleLab.font.lineHeight;
        self.titleLab.frame = frame;
        
        if (self.frame.size.height - CGRectGetMaxY(_titleLab.frame) >= _descLab.font.lineHeight)
        {
            frame = _descLab.frame;
            frame.origin.x = CGRectGetMinX(_titleLab.frame);
            frame.origin.y = CGRectGetMaxY(_titleLab.frame);
            frame.size.width = CGRectGetMinX(_icon.frame)-frame.origin.x;
            frame.size.height = self.frame.size.height - CGRectGetMaxY(_titleLab.frame);
            _descLab.frame = frame;
            [_descLab sizeToFit];
        }
        else
        {
            _descLab.frame = CGRectZero;
        }
    }
    else
    {
        CGRect frame = self.icon.frame;
        frame.size.width = self.frame.size.width * 0.75;
        frame.size.height = self.frame.size.height * 0.56;
        frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = self.frame.size.height - 8 - frame.size.height;
        self.icon.frame = frame;
        
        frame = self.titleLab.frame;
        frame.origin.x = 8;
        frame.origin.y = 8;
        frame.size.width = self.frame.size.width - 8 - frame.origin.x;
//        frame.size.height = CGRectGetMinY(_icon.frame) - frame.origin.y;
        frame.size.height = self.titleLab.font.lineHeight;
        self.titleLab.frame = frame;
//        self.titleLab.numberOfLines = 1;
//        [self.titleLab sizeToFit];
        
        if (CGRectGetMinY(_icon.frame) - CGRectGetMaxY(_titleLab.frame) >= _descLab.font.lineHeight)
        {
            frame = self.descLab.frame;
            frame.origin.y = CGRectGetMaxY(_titleLab.frame);
            frame.origin.x = _titleLab.frame.origin.x;
            frame.size.width = self.frame.size.width - frame.origin.x*2;
            frame.size.height = _icon.frame.origin.y - CGRectGetMaxY(_titleLab.frame);
            self.descLab.frame = frame;
            [self.descLab sizeThatFits:frame.size];
        }
        else
        {
            self.descLab.frame = CGRectZero;
        }
    }
}

- (void)setItem:(HYMallHomeItem *)item
{
    if (_item != item)
    {
        _item = item;
        if (item.pictureUrl.length > 0)
        {
            NSURL *url = [NSURL URLWithString:item.pictureUrl];
            [self.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        self.titleLab.text = item.name;
        self.descLab.text = item.advertMessage;
//        self.titleLab.text = @"长度测试长度测试长度测试长度测试长度测试";
//        self.descLab.text = @"长度测试长度测试长度测试长度测试长度测试";
        [self setNeedsLayout];
    }
}

@end
