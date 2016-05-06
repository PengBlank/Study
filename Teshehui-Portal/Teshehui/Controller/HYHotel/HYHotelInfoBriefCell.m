//
//  HYHotelInfoBriefCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoBriefCell.h"
#import "MDHTMLLabel.h"

@interface HYHotelInfoBriefCell ()
{
//    MDHTMLLabel *_label;
    UILabel *_label;
}
@end

@implementation HYHotelInfoBriefCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByCharWrapping;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor grayColor];
//        _label.lineHeightMultiple = 1.4;
//        _label.userInteractionEnabled = NO;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setBrief:(NSString *)brief
{
    if (brief != _brief)
    {
        _brief = [brief copy];
        CGFloat maxwidth = [UIScreen mainScreen].bounds.size.width - 40;
        CGSize size = [self.brief sizeWithFont:[UIFont systemFontOfSize:15]
                             constrainedToSize:CGSizeMake(maxwidth, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByCharWrapping];
        
        _label.frame = CGRectMake(20, 7, size.width, size.height);
        _label.text = brief;;
    }
}

@end
