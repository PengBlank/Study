//
//  HYFlowerTranInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerTranInfoCell.h"

@interface HYFlowerTranInfoCell ()

@end


@implementation HYFlowerTranInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10, 10, 50, 18);
    self.detailTextLabel.frame = CGRectMake(10, 32, 64, 18);
    
    CGSize size = [self.descLabel.text sizeWithFont:[UIFont systemFontOfSize:14]
                                  constrainedToSize:CGSizeMake(220, 80)];
    size.height = (size.height>18) ? size.height : 18;
    self.descLabel.frame = CGRectMake(80, 32, 220, size.height);
}

#pragma mark setter/getter
- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 18)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self.contentView addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel)
    {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 32, 220, 18)];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _descLabel.numberOfLines = 0;
        [self.contentView addSubview:_descLabel];
    }
    
    return _descLabel;
}
@end
