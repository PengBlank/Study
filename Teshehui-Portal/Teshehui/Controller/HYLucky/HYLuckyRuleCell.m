//
//  HYLuckyRuleCell.m
//  Teshehui
//
//  Created by HYZB on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyRuleCell.h"
#import "UIImage+Addition.h"

@implementation HYLuckyRuleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
//        _lineView = [[UIImageView alloc] initWithFrame:TFRectMake(15, 102.5, 230, 3.5)];
//        _lineView.image = [UIImage imageWithNamedAutoLayout:@"kj_tm_line"];
//        [self.contentView addSubview:_lineView];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.numberOfLines = 1000;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 5, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-10);
//    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
//                                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-40, MAXFLOAT)
//                                          lineBreakMode:NSLineBreakByCharWrapping];
//    size.height += 14;
//    
//    CGRect frame = _lineView.frame;
//    frame.origin.y = size.height-3.5;
//    _lineView.frame = frame;
}

@end
