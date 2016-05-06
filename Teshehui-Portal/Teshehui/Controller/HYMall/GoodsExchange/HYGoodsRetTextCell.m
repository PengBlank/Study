//
//  HYGoodsRetDescCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGoodsRetTextCell.h"
#import "SAMTextView.h"
#import "UIImage+Addition.h"
#import "NSString+Addition.h"

@interface HYGoodsRetTextCell ()<UITextViewDelegate>

@property (nonatomic, strong) SAMTextView *commentView;

@property (nonatomic, strong) UILabel *charNumLab;

@end

@implementation HYGoodsRetTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isGray = NO;
        self.selectable = NO;
        self.keyLab.text = @"问题描述";
        self.valueLab.text = nil;
        
        CGFloat y = CGRectGetMaxY(self.grayView.frame);
        CGFloat x = CGRectGetMinX(self.nessaryImage.frame);
        CGFloat w = CGRectGetMaxX(self.indicator.frame) - x;
        
        UIImageView *textV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, 75)];
        UIImage *textImg = [UIImage imageNamed:@"comment_text"];
        textImg = [textImg utilResizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        textV.image = textImg;
        [self.contentView addSubview:textV];
        
        //x += 5;
        //y += 5;
        //w -= 10;
        SAMTextView *textView = [[SAMTextView alloc] initWithFrame:CGRectMake(x, y, w, 75)];
        textView.font = [UIFont systemFontOfSize:12];
        textView.returnKeyType = UIReturnKeyDefault;
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholder = @"问题描述，最多输入200字";
        textView.delegate = self;
        [self.contentView addSubview:textView];
        self.commentView = textView;
        
        x = CGRectGetMaxX(textV.frame) - 70;
        y = CGRectGetMaxY(textV.frame) + 5;
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 70, 10)];
        numLab.backgroundColor = [UIColor clearColor];
        numLab.textColor = [UIColor lightGrayColor];
        numLab.font = [UIFont systemFontOfSize:12.0];
        numLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:numLab];
        numLab.text = @"(0/200)";
        self.charNumLab = numLab;
    }
    return self;
}

- (void)setDescTxt:(NSString *)descTxt
{
    _descTxt = descTxt;
    self.commentView.text = descTxt;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(descCell:didGetText:)])
    {
        [self.delegate descCell:self didGetText:_commentView.text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    if (text.length >= 200)
    {
        text = [text stringByReplacingCharactersInRange:NSMakeRange(199, text.length-200) withString:@""];
        textView.text = text;
    }
    self.charNumLab.text = [NSString stringWithFormat:@"(%ld/200)", text.length];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSInteger count = [textView.text calculateCountWord];
//    if (count <= 200 || [text isEqualToString:@""])
//    {
//        self.charNumLab.text = [NSString stringWithFormat:@"(%d/200)", count];
//        return YES;
//    } else {
//        return NO;
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
