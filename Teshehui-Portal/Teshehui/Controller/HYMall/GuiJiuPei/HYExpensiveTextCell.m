//
//  HYExpensiveTextCell.m
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveTextCell.h"
#import "SAMTextView.h"
#import "UIImage+Addition.h"

@interface HYExpensiveTextCell ()
<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet SAMTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *stringCountLabel;

@end

@implementation HYExpensiveTextCell

- (void)awakeFromNib
{
    // Initialization code
    self.textView.backgroundColor = [UIColor colorWithWhite:.94 alpha:1.0f];
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0f] CGColor];
    self.textView.layer.cornerRadius = 4;
    self.textView.placeholder = @"请描述你的问题...";
    self.textView.delegate = self;
}

#pragma mark textview
-(void)textViewDidChange:(UITextView *)textView
{

    _stringCountLabel.text = [NSString stringWithFormat:@"%ld/100",textView.text.length];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expensiveTextCellDidGetText:)])
    {
        [self.delegate expensiveTextCellDidGetText:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _stringCountLabel.text = [NSString stringWithFormat:@"%lu/100",textView.text.length];
    
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (result.length > 100 && ![text isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
