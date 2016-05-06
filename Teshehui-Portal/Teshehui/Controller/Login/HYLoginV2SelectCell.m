//
//  HYLoginV2SelectCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLoginV2SelectCell.h"

@interface HYLoginV2SelectCell ()

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation HYLoginV2SelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.textLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
        self.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        UIImage *arrow = [UIImage imageNamed:@"cell_indicator"];
        
        UIImageView *arrowv = [[UIImageView alloc] initWithImage:arrow];
        arrowv.frame = CGRectMake(CGRectGetWidth(self.frame)-10-arrow.size.width, CGRectGetHeight(self.frame)/2-arrow.size.height/2, arrow.size.width, arrow.size.height);
        arrowv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.rightArrow = arrowv;
        [self.contentView addSubview:arrowv];
        
        _selectEnable = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(25, 0, 78, self.frame.size.height);
    //    self.textField.frame = CGRectMake(108, 0, self.frame.size.width-118, self.frame.size.height);
    CGFloat width = (self.frame.size.width- CGRectGetMaxX(self.textLabel.frame) - 25);
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), 0, width, self.frame.size.height);
}

- (void)setSelectEnable:(BOOL)selectEnable
{
    if (_selectEnable != selectEnable) {
        _selectEnable = selectEnable;
        if (selectEnable) {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.rightArrow.hidden = NO;
            self.userInteractionEnabled = YES;
        }
        else
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.rightArrow.hidden = YES;
            self.userInteractionEnabled = NO;
        }
    }
}

//- (void)setValuePlaceholder:(NSString *)valuePlaceholder
//{
//    _valuePlaceholder = valuePlaceholder;
//    if (valuePlaceholder.length > 0)
//    {
//        
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
