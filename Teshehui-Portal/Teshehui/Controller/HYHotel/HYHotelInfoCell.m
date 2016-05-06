//
//  HYHotelInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoCell.h"
#import "UIColor+hexColor.h"

@interface HYHotelInfoCell ()

@end

@implementation HYHotelInfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithHexColor:@"353535" alpha:1.0];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.backgroundColor = [UIColor blueColor];
        self.detailTextLabel.textColor = [UIColor colorWithHexColor:@"a1a1a1" alpha:1.0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(16, 9, 16, 16);
    self.textLabel.frame = CGRectMake(38, 8, CGRectGetWidth(self.frame)-40, 18);
    
    CGSize size = [self.detailTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13]
                                        constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame)-40, MAXFLOAT)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    self.detailTextLabel.frame = CGRectMake(20, 30, CGRectGetWidth(self.frame)-40, size.height+4);
}


@end
