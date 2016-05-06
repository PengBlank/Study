//
//  HYActivityTableViewCell.m
//  Teshehui
//
//  Created by HYZB on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HYActivityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        
        _textBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat orig_x = _evenIndex ? 0 : 160;
    self.imageView.frame = CGRectMake(160-orig_x, 0, 160, 160);
    self.textLabel.frame = CGRectMake(orig_x, 70, 160, 20);
    _textBgView.frame = CGRectMake(orig_x, 0, 160, 160);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithCategory:(HYProductListSummary *)category
{
    if (category != _category)
    {
        _category = category;
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:category.productPicUrl]
                       placeholderImage:[UIImage imageNamed:@"logo_loading"]];
        self.textLabel.text = category.productName;
    }
}

@end
