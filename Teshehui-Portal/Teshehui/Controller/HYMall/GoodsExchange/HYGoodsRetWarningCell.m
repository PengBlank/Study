//
//  HYGoodsRetWarningCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetWarningCell.h"

@interface HYGoodsRetWarningCell ()
@property (nonatomic, strong) UILabel *warningLabel;
@end

@implementation HYGoodsRetWarningCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(ScreenRect), 42);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.frame)-24-13, CGRectGetHeight(self.frame))];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.numberOfLines = 0;
        
        
        
        [self.contentView addSubview:label];
        self.warningLabel = label;
        //[self.view addSubview:label];
    }
    return self;
}

- (void)setWarning:(NSString *)warning
{
    if ([self.warningLabel respondsToSelector:@selector(setAttributedText:)])
    {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:warning];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [content addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:contentRange];
        self.warningLabel.textColor = [UIColor redColor];
        self.warningLabel.attributedText = content;
    }
    else
    {
        self.warningLabel.textColor = [UIColor redColor];
        self.warningLabel.text = warning;
    }
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

@end
