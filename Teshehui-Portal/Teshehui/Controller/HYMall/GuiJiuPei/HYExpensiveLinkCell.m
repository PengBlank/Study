//
//  HYExpensiveLinkCell.m
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveLinkCell.h"
#import "UIImage+Addition.h"
#import "HYGuijiupeiProductUrlView.h"
#import "SAMTextView.h"

@interface HYExpensiveLinkCell ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet SAMTextView *linkTextView;

@end

@implementation HYExpensiveLinkCell

- (void)awakeFromNib
{
    self.linkTextView.delegate = self;
    _linkTextView.placeholder = @"请输入本商品的天猫/京东链接";
    _linkTextView.backgroundColor = [UIColor colorWithWhite:.94 alpha:1.0f];
    _linkTextView.layer.borderWidth = 1.0;
    _linkTextView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0f] CGColor];
    _linkTextView.layer.cornerRadius = 4;
    _linkTextView.returnKeyType = UIReturnKeyDone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark textview
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expensiveLinkCellDidEndEditing:)])
    {
        [self.delegate expensiveLinkCellDidEndEditing:textView.text];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(expensiveLinkCellDidBeginEditing)])
    {
        [self.delegate expensiveLinkCellDidBeginEditing];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL enterReturn = [text isEqualToString:@"\n"];
    if (enterReturn)
    {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark private
- (IBAction)questionBtnAction:(UIButton *)sender
{
    HYGuijiupeiProductUrlView *view = [[HYGuijiupeiProductUrlView alloc]initMyNib];
    CGRect frame = view.frame;
    frame.origin.x += TFScalePoint(90);
    view.frame = frame;
    [self.contentView addSubview:view];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(expensiveLinkCellDidClickQustionButton)]) {
//        [self.delegate expensiveLinkCellDidClickQustionButton];
//    }
}


@end
