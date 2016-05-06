//
//  HYMessageCell.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMessageCell.h"

@implementation HYMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _conLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _conLab.backgroundColor = [UIColor clearColor];
        _conLab.textColor = [UIColor darkTextColor];
        _conLab.lineBreakMode = NSLineBreakByCharWrapping;
        _conLab.numberOfLines = 0;
        _conLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_conLab];
        
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.textColor = [UIColor grayColor];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.font = [UIFont systemFontOfSize:12.0f];
        _timeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLab];
    }
    return self;
}


-(void)setList:(HYMessageInfo *)info
{
     NSDate* date = [NSDate dateWithTimeIntervalSince1970:[info.add_time floatValue]];
    _conLab.text = info.content;
    _timeLab.text = [self stringFromDate:date];
     CGSize titleSize = [info.content sizeWithFont:_conLab.font
                                 constrainedToSize:CGSizeMake(TFScalePoint(300), MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping];
    _conLab.frame = CGRectMake(10, 10, TFScalePoint(300), titleSize.height);
    _timeLab.frame = CGRectMake(10, titleSize.height+10, TFScalePoint(300), 20);
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
@end
