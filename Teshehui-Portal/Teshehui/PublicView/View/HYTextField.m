//
//  HYTextField.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYTextField.h"

@implementation HYTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setAutoSpace:(BOOL)autoSpace
{
    if (autoSpace != _autoSpace)
    {
        _autoSpace = autoSpace;
    }
}

- (void)setText:(NSString *)text
{
    if (self.autoSpace && [text length] > 1)
    {
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSMutableString *muText = [NSMutableString stringWithString:text];
        int index = 4;
        while (index < [muText length])
        {
            [muText insertString:@" " atIndex:index];
            index += 5;
        }
        
        [super setText:muText];
    }
    else
    {
        [super setText:text];
    }
}

- (void)insertText:(NSString *)text
{
    if (self.autoSpace && (text.length*self.text.length) > 0)
    {
        self.text = [self.text stringByAppendingString:text];
    }
    else
    {
        [super insertText:text];
    }
}

- (void)deleteBackward
{
    [super deleteBackward];
    if (self.autoSpace && self.text.length > 0)
    {
        NSRange rang;
        rang.location = self.text.length -1;
        rang.length = 1;
        NSString *str = [self.text substringWithRange:rang];
        if ([str isEqualToString:@" "])
        {
            [super deleteBackward];
        }
    }
}
@end
