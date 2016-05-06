//
//  HYCITableViewQuotePriceCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewQuotePriceCell.h"

@implementation HYCITableViewQuotePriceCell

- (void)awakeFromNib {
    // Initialization code
    self.hiddenLine = YES;
    
    UIImage *selectBg = [UIImage imageNamed:@"select_bj"];
    selectBg = [selectBg resizableImageWithCapInsets:UIEdgeInsetsMake(3, 4, 4, 15) resizingMode:UIImageResizingModeStretch];
    [self.selectBtn setBackgroundImage:selectBg forState:UIControlStateNormal];
    [self.selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [self.selectBtn addTarget:self
                       action:@selector(selectBtnAction:)
             forControlEvents:UIControlEventTouchUpInside];
    self.priceLab.textColor = [UIColor colorWithRed:161.0/255.0
                                              green:0
                                               blue:0
                                              alpha:1.0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //对于三个标题头label，重新排列以适应不同屏幕
    CGFloat width = CGRectGetWidth(self.bounds) / 3.0;
    CGRect frame = self.nameLab.frame;
    frame.origin.x = 10;
    frame.size.width = width-20;
    self.nameLab.frame = frame;
    
    frame = self.selectBtn.frame;
    frame.origin.x = width + 10;
    frame.size.width = width - 20;
    self.selectBtn.frame = frame;
    
    frame = self.priceLab.frame;
    frame.origin.x = 2*width + 10;
    frame.size.width = width - 20;
    self.priceLab.frame = frame;
}

- (void)setFillType:(HYCICarInfoFillType *)fillType
{
    if (_fillType != fillType)
    {
        _fillType = fillType;
        self.nameLab.text = fillType.inputShowName;
    }
    
    if (fillType.inputType.integerValue == 21)
    {
        self.nameLab.text = fillType.inputShowName;
        self.selectBtn.hidden = NO;
        UIImage *selectBg = [UIImage imageNamed:@"select_bj"];
        selectBg = [selectBg resizableImageWithCapInsets:UIEdgeInsetsMake(3, 4, 4, 15)
                                            resizingMode:UIImageResizingModeStretch];
        [self.selectBtn setBackgroundImage:selectBg forState:UIControlStateNormal];
        [self.selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        
        BOOL findValueDisplay = NO;
        for (HYCICarInfoValue* keyvalue in fillType.selectValueList)
        {
            if ([keyvalue.value isEqualToString:fillType.value])
            {
                [self.selectBtn setTitle:keyvalue.key
                                forState:UIControlStateNormal];
                findValueDisplay = YES;
                break;
            }
        }
        if (!findValueDisplay)
        {
            [self.selectBtn setTitle:fillType.value
                            forState:UIControlStateNormal];
        }
        self.priceLab.text = [NSString stringWithFormat:@"%.2f",
                              fillType.serverValue.floatValue];
    }
    else if (fillType.inputType.integerValue == 50) //label
    {
        self.nameLab.text = fillType.inputShowName;
        self.selectBtn.hidden = YES;
        self.priceLab.text = [NSString stringWithFormat:@"%.2f",
                              fillType.serverValue.floatValue];
    }
    else if (fillType.inputType.integerValue == 40) //date
    {
        self.nameLab.text = fillType.inputShowName;
        self.selectBtn.hidden = NO;
        self.priceLab.text = nil;
        
        UIImage *selectBg = [UIImage imageNamed:@"input_bj"];
        selectBg = [selectBg resizableImageWithCapInsets:UIEdgeInsetsMake(3, 4, 4, 3) resizingMode:UIImageResizingModeStretch];
        [self.selectBtn setBackgroundImage:selectBg forState:UIControlStateNormal];
        [self.selectBtn setTitleEdgeInsets:UIEdgeInsetsZero];
        [self.selectBtn setTitle:fillType.value forState:UIControlStateNormal];
    }
}

- (void)selectBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(quoteCellDidClick:)])
    {
        [self.delegate quoteCellDidClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
