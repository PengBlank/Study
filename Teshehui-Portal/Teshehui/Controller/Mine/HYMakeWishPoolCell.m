//
//  HYMakeWishPoolCell.m
//  Teshehui
//
//  Created by HYZB on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMakeWishPoolCell.h"

#define kLabelFont [UIFont systemFontOfSize:14]
#define kMargin TFScalePoint(10)

@interface HYMakeWishPoolCell ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *commentTitleLabel;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, assign) NSInteger commentMaxNumber;
@property (nonatomic, strong) UILabel *commentTextViewPlaceholderLabel;
@property (nonatomic, strong) UITextView *commentTextView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation HYMakeWishPoolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _commentTitleLabel = [[UILabel alloc] init];
        _commentTitleLabel.font = kLabelFont;
        [self.contentView addSubview:_commentTitleLabel];
        
        _commentTextView = [[UITextView alloc] init];
        _commentTextView.backgroundColor = [UIColor colorWithRed:240/250.0f green:240/250.0f blue:240/250.0f alpha:1.0];
        _commentTextView.delegate = self;
        [self.contentView addSubview:_commentTextView];
        
        _commentNumberLabel = [[UILabel alloc] init];
        _commentNumberLabel.font = kLabelFont;
        _commentNumberLabel.textAlignment = NSTextAlignmentRight;
        [_commentTextView addSubview:_commentNumberLabel];
        
        _commentTextViewPlaceholderLabel = [[UILabel alloc] init];
        _commentTextViewPlaceholderLabel.font = kLabelFont;
        _commentTextViewPlaceholderLabel.textColor = [UIColor colorWithRed:100/250.f green:100/250.f blue:100/250.f alpha:1.0];
        [_commentTextView addSubview:_commentTextViewPlaceholderLabel];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:233/250.0f green:233/250.0f blue:233/250.0f alpha:1.0];
        [self addSubview:_bottomView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _commentTitleLabel.frame = CGRectMake(kMargin, kMargin, 100, 20);
    
    _commentNumberLabel.frame = CGRectMake(_commentTextView.frame.size.width - 90, _commentTextView.frame.size.height-25, 80, 20);
    _commentNumberLabel.text = [NSString stringWithFormat:@"0/%ld", _commentMaxNumber];
    
    _commentTextViewPlaceholderLabel.frame = CGRectMake(10, (_commentTextView.frame.size.height / 2) - 10, 230, 20);
}

- (void)setupCellWithCommentTitleLabel:(NSString *)commentTitleLabel commentMaxNumber:(NSInteger)commentMaxNumber CommentTextViewPlaceholderLabel:(NSString *)commentTextViewPlaceholderLabel commentTextViewHeight:(NSInteger)commentTextViewHeight
{
    _commentTitleLabel.text = commentTitleLabel;
    _commentMaxNumber = commentMaxNumber;
    _commentTextViewPlaceholderLabel.text = commentTextViewPlaceholderLabel;
    
    _commentTextView.frame = CGRectMake(kMargin, TFScalePoint(40), self.frame.size.width - kMargin * 2, commentTextViewHeight);
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame)-15, TFScalePoint(320), 15);
}

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    _commentNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.length, _commentMaxNumber];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _commentTextViewPlaceholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!textView.text.length) {
        _commentTextViewPlaceholderLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (result.length > _commentMaxNumber && ![text isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}



@end
