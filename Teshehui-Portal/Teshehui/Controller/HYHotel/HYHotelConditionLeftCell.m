//
//  HYHotelConditionLeftCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelConditionLeftCell.h"

@implementation HYHotelConditionLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.contentView.backgroundColor = [UIColor clearColor];
        
//        _sImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 45)];
//        _sImageView.image = [UIImage imageNamed:@"btn_voice_blue"];
//        [self.contentView addSubview:_sImageView];
//        [_sImageView setHidden:YES];
//        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

//    // Configure the view for the selected state
//    self.backgroundColor = selected ? [UIColor blackColor] :[UIColor whiteColor];
//    self.contentView.backgroundColor = selected ? [UIColor blackColor] :[UIColor blueColor];
}

- (void)setCheck:(BOOL)check
{
    if (check != _check)
    {
        _check = check;
        if (check)
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            self.backgroundColor = [UIColor clearColor];
        }
    }
}

@end
