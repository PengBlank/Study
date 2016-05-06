//
//  TravelCodeCell.m
//  Teshehui
//
//  Created by macmini5 on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelCodeCell.h"
#import "UIColor+hexColor.h"

@implementation TravelCodeCell

- (void)awakeFromNib {
    // Initialization code
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = .6f;
    [self.contentView setBackgroundColor:[UIColor colorWithHexColor:@"F1F1F1" alpha:1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
