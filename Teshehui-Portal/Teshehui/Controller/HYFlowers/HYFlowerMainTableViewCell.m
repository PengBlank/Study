//
//  HYFlowerMainTableViewCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-5-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerMainTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HYFlowerMainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        
        _textBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2)];
        _textBgView.image = [UIImage imageNamed:@"flower_text_bg"];
        [self.contentView addSubview:_textBgView];
        
        self.textLabel.textColor = [UIColor colorWithRed:243.0/255.5
                                                   green:41.0/255.5
                                                    blue:62.0/255.5
                                                   alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.frame)/2;
    CGFloat orig_x = _evenIndex ? 0 : w;
    self.imageView.frame = CGRectMake(w - orig_x, 0, w, w);
    self.textLabel.frame = CGRectMake(orig_x, w/2-10, w, 20);
    _textBgView.frame = CGRectMake(orig_x, 0, w, w);
}

#pragma mark setter/getter
- (void)setItem:(HYFlowerTypeInfo *)item
{
    if (item != _item)
    {
        _item = item;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.categoryPicUrl]
                          placeholderImage:[UIImage imageNamed:@"logo_loading"]];
        self.textLabel.text = item.categoryName;
    }
}

@end
