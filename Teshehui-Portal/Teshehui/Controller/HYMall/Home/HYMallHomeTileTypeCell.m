//
//  HYMallHomeTileTypeCell.m
//  Teshehui
//
//  Created by HYZB on 15/1/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeTileTypeCell.h"
#import "UIButton+WebCache.h"

@interface HYMallHomeTileTypeCell ()
{
    UIButton *_item1Btn;
    UIButton *_item2Btn;
    UIButton *_item3Btn;
}
@end

@implementation HYMallHomeTileTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect frame = [[UIScreen mainScreen] bounds];
        
        UIImageView *_lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        _lineView1.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:0];
        [self.contentView addSubview:_lineView1];
        
        UIImageView *_lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, frame.size.width, 1)];
        _lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                      topCapHeight:0];
        [self.contentView addSubview:_lineView2];
        
        UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 34, 1, TFScalePoint(180))];
        lineView1.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView1];

        UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 34+TFScalePoint(180)/2, frame.size.width/2, 1)];
        lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
                                                                                   topCapHeight:2];
        [self.contentView addSubview:lineView2];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        
        _item1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item1Btn.frame = CGRectMake(0,
                                     35,
                                     frame.size.width/2,
                                     TFScalePoint(180)-1);
        _item1Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item1Btn.tag = 1;
        [_item1Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item1Btn];
        
        _item2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item2Btn.frame = CGRectMake(frame.size.width/2+1,
                                     35,
                                     frame.size.width/2-1,
                                     TFScalePoint(180)/2-1);
        _item2Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item2Btn.tag = 2;
        [_item2Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item2Btn];
        
        _item3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _item3Btn.frame = CGRectMake(frame.size.width/2+1,
                                     35+TFScalePoint(180)/2,
                                     frame.size.width/2-1,
                                     TFScalePoint(180)/2-1);
        _item3Btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _item3Btn.tag = 3;
        [_item3Btn addTarget:self
                      action:@selector(checkItemDetail:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_item3Btn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(6, 7, 160, 20);
}

#pragma mark - private methods
- (void)checkItemDetail:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(checkProductDetail:)])
    {
        if ((sender.tag-1) < [self.items count])
        {
            HYMallHomeItem *item = [self.items objectAtIndex:(sender.tag-1)];
            [self.delegate checkProductDetail:item];
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

- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        
        for (int i=0; i<3&&i<[items count]; i++)
        {
            HYMallHomeItem *item = [self.items objectAtIndex:i];
            
            if (i == 0)
            {
                [_item1Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                [_item2Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
            else if (i == 2)
            {
                [_item3Btn sd_setImageWithURL:[NSURL URLWithString:item.pictureUrl]
                                     forState:UIControlStateNormal];
            }
        }
    }
}
@end
