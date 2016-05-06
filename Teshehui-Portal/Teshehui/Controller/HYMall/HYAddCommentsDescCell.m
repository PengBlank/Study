//
//  HYAddCommentsDescCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAddCommentsDescCell.h"
#import "SAMTextView.h"
#import "UIImage+Addition.h"

@interface HYAddCommentsDescCell ()<UITextViewDelegate>

@property (nonatomic, strong) SAMTextView *commentView;

@end

@implementation HYAddCommentsDescCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat y = 10;
        CGFloat x = 20;
        CGFloat w = CGRectGetWidth(ScreenRect) - 2*x;
        UIImageView *textV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, 75)];
        UIImage *textImg = [UIImage imageNamed:@"comment_text"];
        textImg = [textImg utilResizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        textV.image = textImg;
        [self addSubview:textV];
        
        SAMTextView *textView = [[SAMTextView alloc] initWithFrame:CGRectMake(x, y, w, 75-10)];
        textView.font = [UIFont systemFontOfSize: 14];
        textView.returnKeyType = UIReturnKeyDefault;
        textView.backgroundColor = [UIColor clearColor];
        textView.delegate = self;
        
        [self addSubview:textView];
        self.commentView = textView;
    }
    return self;
}

- (void)setCommentModel:(HYCommentModel *)commentModel
{
    if (_commentModel != commentModel)
    {
        _commentModel = commentModel;
        self.commentView.text = commentModel.comment;
        if (commentModel.evaluable == HYCanEvaluation)
        {
            self.commentView.placeholder = @"写点评价吧，对其他特奢汇会员帮助很大的〜";
        }
        else if (commentModel.evaluable == HYCanAddEvaluation)
        {
            self.commentView.placeholder = @"宝贝好用吗？可以追评哦〜";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _commentModel.comment = textView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(descCellDidBeginEditing:)])
    {
        [_delegate descCellDidBeginEditing:self];
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
