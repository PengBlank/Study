//
//  HYFlowerMessageTableViewCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-9.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerMessageTableViewCell.h"

@interface HYFlowerMessageTableViewCell ()
{
    UIImageView *_arrView1;
}
@end

@implementation HYFlowerMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.backgroundColor = [UIColor clearColor];
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
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
                                  constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-45, 80)];
    
    self.textLabel.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame)-45, size.height);
}

@end
