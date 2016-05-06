//
//  HYCommentCell.m
//  Teshehui
//
//  Created by RayXiang on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCommentCell.h"
#import "UIImage+Addition.h"
#import "UIView+Style.h"
#import "TQStarRatingView.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Addition.h"

@interface HYCommentCell ()
@property (nonatomic, strong) UIImageView *lineView;


@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) NSArray *imgViews;
@property (nonatomic, strong) NSArray *imgViewBgs;
@property (nonatomic, strong) NSArray *replyLabs;
@property (nonatomic, strong) NSArray *replyBgViews;
@property (nonatomic, strong) TQStarRatingView *ratingControl;
@property (nonatomic, strong) UITapGestureRecognizer *imgTap;

@end

@implementation HYCommentCell

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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLab.font = [UIFont systemFontOfSize:18.0];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLab];
        
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLab.font = [UIFont systemFontOfSize:14.0];
        self.contentLab.backgroundColor = [UIColor clearColor];
        self.contentLab.textColor = [UIColor grayColor];
        self.contentLab.numberOfLines = 0;
        [self.contentView addSubview:self.contentLab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLab.font = [UIFont systemFontOfSize:14.0];
        self.timeLab.backgroundColor = [UIColor clearColor];
        self.timeLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.timeLab];
        
        UIImage *replyBg = [UIImage imageNamed:@"comment_reply_bg"];
        NSMutableArray *replyBgs = [NSMutableArray array];
        replyBg = [replyBg utilResizableImageWithCapInsets:UIEdgeInsetsMake(15,  45, 10, 10)];
        for (NSInteger i = 0; i < 3; i++)
        {
            UIImageView *replyBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            replyBgView.image = replyBg;
            [self.contentView addSubview:replyBgView];
            [replyBgs addObject:replyBgView];
        }
        self.replyBgViews = [NSArray arrayWithArray:replyBgs];
        
        NSMutableArray *replyLabs = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++)
        {
            UILabel *replyLab = [[UILabel alloc] initWithFrame:CGRectZero];
            replyLab.font = [UIFont systemFontOfSize:14.0];
            replyLab.backgroundColor = [UIColor clearColor];
            replyLab.textColor = [UIColor grayColor];
            replyLab.numberOfLines = 0;
            [self.contentView addSubview:replyLab];
            [replyLabs addObject:replyLab];
        }
        self.replyLabs = [NSArray arrayWithArray:replyLabs];
        
        
        self.ratingControl = [[TQStarRatingView alloc]
                              initWithStar:[UIImage imageNamed:@"star_list_n"]
                              hilightedStar:[UIImage imageNamed:@"star_list_h"]
                              numberOfStar:5
                              spaceOfStar:5];
        self.ratingControl.enable = NO;
        [self.contentView addSubview:self.ratingControl];
        
        //[self setViewWithModel:<#(HYMallGoodCommentInfo *)#>];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction:)];
        [self.contentView addGestureRecognizer:tap];
        self.imgTap = tap;
    }
    return self;
}

- (void)imgTapAction:(UITapGestureRecognizer *)tap
{
    for (UIView *vi in self.imgViews)
    {
        if (CGRectContainsPoint(vi.frame, [tap locationInView:self.contentView]))
        {
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(commentCell:withInfo:didClickImageAtIndex:)])
            {
                NSInteger idx = [self.imgViews indexOfObject:vi];
                [self.delegate commentCell:self
                                  withInfo:self.commentInfo
                      didClickImageAtIndex:idx];
            }
        }
    }
}

- (void)setCommentInfo:(HYMallGoodCommentInfo *)commentInfo
{
    if (_commentInfo != commentInfo)
    {
        _commentInfo = commentInfo;
        [self setViewWithModel:_commentInfo];
    }
    
}

- (void)setViewWithModel:(HYMallGoodCommentInfo *)commentInfo
{
    NSString *name = commentInfo.user_name;
    NSString *content = commentInfo.comment;
    //content = @"接口太坑，差评";
    
//    NSTimeInterval timeInte = [commentInfo.created integerValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInte];
//    NSString *time = [date timeDescription];
    NSString * time = [NSString stringWithFormat:@"%@ %@", commentInfo.created, commentInfo.goods_spec_name];
    //NSString *reply = @"[客服人员]: \n包包都是正规渠道进货，绝对正品，假一罚十〜\n"
                        //"\n亲使用的过程中若有任何问题，请与我们联系哦〜";
    //NSString *reply2 = @"[hailong]: \n我去专框检查过了，是假货！";
    //NSString *reply3 = @"[客服人员]:\n绝对不可能，我们都是验过货的，你再这样，我要报警了哟！";
    NSMutableArray *replies = [NSMutableArray array];
    for (HYMallGoodCommentInfo *comment in commentInfo.replies)
    {
        NSString *replyStr = [NSString stringWithFormat:@"[%@]:\n%@", comment.user_name, comment.comment];
        [replies addObject:replyStr];
    }
    
    //文本边距15,顶部11
    CGFloat x = 15;
    CGFloat y = 11;
    CGFloat h = 0;
    CGFloat star_w = 80;
    UIFont *font = nil;
    
    //名
    CGFloat w = CGRectGetWidth(ScreenRect) - 2*x - star_w;
    font = self.nameLab.font;
    CGSize size = [name sizeWithFont:font
                   constrainedToSize:CGSizeMake(w, font.lineHeight)];
    self.nameLab.frame = CGRectMake(x, y, size.width, size.height);
    self.nameLab.text = name;
    
    //内容
    y += 5 + size.height;
    font = self.contentLab.font;
    w = CGRectGetWidth(ScreenRect) - 2*x;
    size = [content sizeWithFont:font constrainedToSize:CGSizeMake(w, 2000)];
    self.contentLab.frame = CGRectMake(x, y, size.width, size.height);
    self.contentLab.text = content;
    
    y += 5 + size.height;
    
    //图片
    if (self.imgViews)
    {
        for (UIView *v in self.imgViews) {
            [v removeFromSuperview];
        }
    }
    if (commentInfo.pics.count > 0)
    {
        CGFloat x_image = 20;
        CGFloat w_image = 40;
        NSMutableArray *imgViews = [NSMutableArray array];
        for (int i = 0; i < commentInfo.pics.count; i++)
        {
            CGFloat w_border = 1;
            UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(x_image, y, w_image, w_image)];
            [frame addBorder:w_border borderColor:[UIColor lightGrayColor]];
            [self.contentView addSubview:frame];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(w_border, w_border, w_image-2*w_border, w_image-2*w_border)];
            //iv.image = [UIImage imageNamed:@"img_l1.jpg"];
            NSDictionary *imgDict = [commentInfo.pics objectAtIndex:i];
            NSString *imgThumStr = [imgDict objectForKey:@"picSmallUrl"];
            [iv sd_setImageWithURL:[NSURL URLWithString:imgThumStr]];
            [frame addSubview:iv];
            
            [imgViews addObject:frame];
            
            x_image += w_image + 6;
        }
        self.imgViews = imgViews;
        y += w_image + 5;
    }
    
    //时间
    font = self.timeLab.font;
    w = CGRectGetWidth(ScreenRect) - 2*x;
    size = [time sizeWithFont:font];
    self.timeLab.frame = CGRectMake(x, y, size.width, size.height);
    self.timeLab.text = time;
    y += size.height;
    
    //回复
    for (UIView *v  in self.replyBgViews) {
        v.frame = CGRectZero;
    }
    for (UILabel *replyLab in self.replyLabs) {
        replyLab.frame = CGRectZero;
    }
    if (replies.count > 0)
    {
        for (NSInteger i = 0; i < replies.count; i++)
        {
            x = 22;
            NSString *reply = [replies objectAtIndex:i];
            UIImageView *replyBg = [self.replyBgViews objectAtIndex:i];
            UILabel *replyLab = [self.replyLabs objectAtIndex:i];
            
            y += 20;
            w = CGRectGetWidth(ScreenRect) - 2*x;
            font = replyLab.font;
            size = [reply sizeWithFont:font constrainedToSize:CGSizeMake(w, 2000)];
            replyLab.frame = CGRectMake(x, y, w, size.height);
            replyLab.text = reply;
            
            //回复背景
            x -= 10;
            y -= 17;
            w = CGRectGetWidth(ScreenRect) - 2*x;
            CGFloat h = size.height + 17 + 10;
            replyBg.frame = CGRectMake(x, y, w, h);
            
            y += h + 5;
        }
    }
    
    //星星
    CGFloat level = (commentInfo.goods_score+commentInfo.service_score+commentInfo.delivery_score)/3.0;
    x = CGRectGetWidth(ScreenRect) - x - star_w;
    h = 13;
    y = CGRectGetMidY(self.nameLab.frame) - h/2;
    self.ratingControl.frame = CGRectMake(x, y, star_w, h);
    self.ratingControl.fraction = YES;
    self.ratingControl.rating = level;
    //self.ratingControl.delegate = self;
}

- (CGFloat)calculateHeightForModel:(HYMallGoodCommentInfo *)model
{
    NSString *name = model.user_name;
    NSString *content = model.comment;
    //content = @"接口太坑，差评";
    
    NSTimeInterval timeInte = [model.created integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInte];
    NSString *time = [date timeDescription];
    time = [NSString stringWithFormat:@"%@ %@", time, model.goods_spec_name];
    //NSString *reply = @"[客服人员]: \n包包都是正规渠道进货，绝对正品，假一罚十〜\n"
    //"\n亲使用的过程中若有任何问题，请与我们联系哦〜";
    //NSString *reply2 = @"[hailong: \n我去专框检查过了，是假货！]";
    //NSString *reply3 = @"[客服人员]:\n绝对不可能，我们都是验过货的，你再这样，我要报警了哟！";
    NSMutableArray *replies = [NSMutableArray array];
    for (HYMallGoodCommentInfo *comment in model.replies)
    {
        NSString *replyStr = [NSString stringWithFormat:@"[%@]:\n%@", comment.user_name, comment.comment];
        [replies addObject:replyStr];
    }
    
    //文本边距15,顶部11
    CGFloat x = 15;
    CGFloat y = 11;
    CGFloat star_w = 80;
    UIFont *font = nil;
    
    //名
    CGFloat w = CGRectGetWidth(ScreenRect) - 2*x - star_w;
    font = self.nameLab.font;
    CGSize size = [name sizeWithFont:font
                   constrainedToSize:CGSizeMake(w, font.lineHeight)];
    y += size.height;
    
    //内容
    y += 5;
    font = self.contentLab.font;
    w = CGRectGetWidth(ScreenRect) - 2*x;
    size = [content sizeWithFont:font constrainedToSize:CGSizeMake(w, 2000)];
    y += size.height;
    
    //图片
    if (model.pics.count > 0) {
        y += 5 + 40;
    }
    
    //时间
    y += 5;
    font = self.timeLab.font;
    w = CGRectGetWidth(ScreenRect) - 2*x;
    size = [time sizeWithFont:font];
    y += size.height + 5;
    
    //回复
    if (replies.count > 0) {
        for (NSString *reply in replies)
        {
            x = 22;
            w = CGRectGetWidth(ScreenRect) - 2*x;
            font = [[self.replyLabs objectAtIndex:0] font];
            size = [reply sizeWithFont:font constrainedToSize:CGSizeMake(w, 2000)];
            y += size.height + 27 + 5;
        }
    }
    
    y += 10;
    
    return y;
}

+ (CGFloat)heightForModel:(id)model
{
    static HYCommentCell *cell = nil;
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"model"];
    }
    return [cell calculateHeightForModel:model];
}

//横线
#pragma mark - 横线
- (UIImageView *)lineView
{
    if (!_lineView)
    {
        CGFloat _separatorLeftInset = 10;
        CGFloat w = CGRectGetWidth(ScreenRect) - 2 * _separatorLeftInset;
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_separatorLeftInset, 0, w, 1.0)];
        _lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                        topCapHeight:0];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_lineView];
        //[self insertSubview:_lineView belowSubview:_sImgV];
    }
    
    return _lineView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.lineView.frame;
    frame.origin.y = CGRectGetHeight(self.frame) - 1;
    _lineView.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
