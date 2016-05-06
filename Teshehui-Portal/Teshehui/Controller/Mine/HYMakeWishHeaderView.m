//
//  HYMakeWIshHeaderView.m
//  Teshehui
//
//  Created by HYZB on 15/11/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMakeWishHeaderView.h"

@interface HYMakeWishHeaderView ()

@property (nonatomic, strong) UILabel *nameLabNumber;
@property (nonatomic, strong) UILabel *descLabNumber;

@end

@implementation HYMakeWishHeaderView

- (void)awakeFromNib
{
    self.nameBottomView.frame = TFRectMakeFixWidth(0, 120, 320, 15);
    self.nameBottomView.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
    
    self.descBottomView.frame = TFRectMakeFixWidth(0, 300, 320, 15);
    self.descBottomView.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
    
    self.nameTextView.frame = TFRectMakeFixWidth(10, 40, 300, 60);
    self.nameTextView.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
    self.nameTextView.delegate = self;
    
    self.descTextView.frame = TFRectMakeFixWidth(10, 180, 300, 110);
    self.descTextView.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
    self.descTextView.delegate = self;
    
    _nameLabNumber = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(220), 10, 80, 20)];
//    _nameLabNumber = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(220), 75, 80, 20)];
//    _nameLabNumber.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
    _nameLabNumber.font = [UIFont systemFontOfSize:14];
    _nameLabNumber.text = @"0/25";
    _nameLabNumber.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameLabNumber];
  
    _descLabNumber = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(220), 152, 80, 20)];
//    _descLabNumber = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(220), 265, 80, 20)];
//    _descLabNumber.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
    _descLabNumber.font = [UIFont systemFontOfSize:14];
    _descLabNumber.text = @"0/200";
    _descLabNumber.textAlignment = NSTextAlignmentRight;
    [self addSubview:_descLabNumber];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (textView == self.nameTextView) {
        
        _namePlaceHolderLab.hidden = YES;
        _nameLabNumber.text = [NSString stringWithFormat:@"%ld/25", _nameTextView.text.length];
    } else {
        
        _descPlaceHolderLab.hidden = YES;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.nameTextView) {
        
        _nameLabNumber.text = [NSString stringWithFormat:@"%ld/25", _nameTextView.text.length];
    } else {
        
        _descLabNumber.text = [NSString stringWithFormat:@"%ld/200", _descTextView.text.length];
    }
    
    if ([self.delegate respondsToSelector:@selector(confirmBtnSetting)]) {
        
        [self.delegate confirmBtnSetting];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@" "]) {
        
        return NO;
    } else {
        
        if (textView == self.nameTextView) {
            
            if (result.length > 25 && ![text isEqualToString:@""])
            {
                return NO;
            } else {
                
                return YES;
            }
        } else {
            
            if (result.length > 200 && ![text isEqualToString:@""])
            {
                return NO;
            } else {
                
                return YES;
            }
        }
    }
    
    //点回车键时调的方法
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (textView == self.nameTextView && textView.text.length == 0) {
        
        _namePlaceHolderLab.hidden = NO;
    } else if (textView == self.descTextView && textView.text.length == 0) {
        
        _descPlaceHolderLab.hidden = NO;
    }
}

@end
