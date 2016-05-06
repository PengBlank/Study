//
//  HYPointLogCell.m
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPointLogCell.h"

@implementation HYPointLogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _TimeLab = [[UILabel alloc]initWithFrame:TFRectMakeFixWidth(10,5,160, 20)];
        _TimeLab.backgroundColor = [UIColor clearColor];
        _TimeLab.textColor = [UIColor darkGrayColor];
        _TimeLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_TimeLab];
        
        _NameLab = [[UILabel alloc]initWithFrame:TFRectMakeFixWidth(180,5,130, 20)];
        _NameLab.backgroundColor = [UIColor clearColor];
        _NameLab.textColor = [UIColor colorWithRed:1.0f green:0.49f blue:0.075 alpha:1.0f];
        _NameLab.textAlignment = NSTextAlignmentRight;
        _NameLab.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.contentView addSubview:_NameLab];
        
        
        _VauleLab = [[UILabel alloc]initWithFrame:TFRectMakeFixWidth(10, 32,300,0)];
        _VauleLab.textColor = [UIColor darkTextColor];
        _VauleLab.numberOfLines = 0;
        _VauleLab.backgroundColor = [UIColor clearColor];
        _VauleLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_VauleLab];

    }
    return self;
}

-(void)setList:(HYPointLogInfo *)info andType:(NSInteger)type
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[info.created floatValue]];
    _TimeLab.text = [self stringFromDate:date];
    
    switch (type) {
        case 1:
        {
            _NameLab.text = [NSString stringWithFormat:@"+%@",info.points];
            break;
        }
        case 2:
        {
            _NameLab.text = [NSString stringWithFormat:@"%@",info.points];
            break;
        }
        default:
            break;
    }
    _VauleLab.text = info.logs;
    CGSize titleSize = [info.logs sizeWithFont:_VauleLab.font
                             constrainedToSize:CGSizeMake(_VauleLab.frame.size.width, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByCharWrapping];
    _VauleLab.frame = CGRectMake(10, 32, _VauleLab.frame.size.width, titleSize.height);
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
@end
