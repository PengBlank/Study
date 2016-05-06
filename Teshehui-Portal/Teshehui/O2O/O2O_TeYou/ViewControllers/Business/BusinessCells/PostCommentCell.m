//
//  PostCommentCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "PostCommentCell.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
@implementation PostCommentCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10,kScreen_Width - 20,100)];
        [_textView setBackgroundColor:[UIColor clearColor]];
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"0xf0f0f0"].CGColor;
        [_textView setPlaceholder: @"请输入您对商家的评价"];
        [self.contentView addSubview:_textView];
    }
    return self;
}


@end
