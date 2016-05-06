//
//  HYChindLoginV2RadioCell.m
//  Teshehui
//
//  Created by Kris on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChindLoginV2RadioCell.h"

@implementation HYChindLoginV2RadioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0f];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x += 13;
    self.textLabel.frame = frame;
}

@end
