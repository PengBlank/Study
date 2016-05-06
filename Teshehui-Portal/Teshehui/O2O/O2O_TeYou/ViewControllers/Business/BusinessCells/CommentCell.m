//
//  CommentCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CommentCell.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
#import "UIColor+hexColor.h"
#import "METoast.h"
#import "UIImageView+WebCache.h"
#define IMAGE_WIDTH g_fitFloat(@[@65,@77,@105])


@interface CommentCell ()
{
    UIImageView     *_imagev1;
    UIImageView     *_imagev2;
    UIImageView     *_imagev3;
    UIImageView     *_imagev4;
    UIImageView     *_imagev5;
    UIImageView     *_imagev6;
}
@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _headImage = [[UIImageView alloc] init];
        [_headImage.layer setCornerRadius:30];
        [_headImage setClipsToBounds:YES];
        [self.contentView addSubview:_headImage];
        
        _starView = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(10, 20, 100, 30) andStars:5 isFractional:YES];
        _starView.userInteractionEnabled = NO;
        _starView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_starView];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview: _nameLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:13.0];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"0x808080"]];
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        [_contentLabel setNumberOfLines:0];
        [self.contentView addSubview:_contentLabel];
        _contentString = _contentLabel.text;

        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setImage:IMAGE(@"praise") forState:UIControlStateNormal];
        [_praiseBtn setImage:IMAGE(@"p_h") forState:UIControlStateSelected];
        // [_praiseBtn setBackgroundImage:IMAGE(@"frame") forState:UIControlStateNormal];
        [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_praiseBtn addTarget:self action:@selector(PraiseClick:) forControlEvents:UIControlEventTouchUpInside];
        [_praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [[_praiseBtn layer] setBorderWidth:0.5];
        [[_praiseBtn layer] setCornerRadius:10];
        [[_praiseBtn layer] setBorderColor:[UIColor colorWithHexString:@"0x606060"].CGColor];
        [_praiseBtn setClipsToBounds:YES];
        [self.contentView addSubview:_praiseBtn];

        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(kPaddingLeftWidth);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(kPaddingLeftWidth);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_headImage.mas_centerY);
        make.left.mas_equalTo(_headImage.mas_right).offset(10);
        make.height.mas_equalTo(@20);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImage.mas_centerY).offset(5);
        make.left.mas_equalTo(_headImage.mas_right).offset(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(@20);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
    }];
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headImage.mas_bottom).offset(kPaddingLeftWidth);
        make.left.mas_equalTo(_headImage.mas_left).offset(5);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-kPaddingLeftWidth);
    }];
    
    [_praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(@52);
        make.height.mas_equalTo(@20);
    }];
    
}


//这个方法是在评论列表页面调用的
- (void)bindDataWithCommentView:(CommentInfo *)cInfo{
    
    if (cInfo == nil) {
        return;
    }
    
    _tmpCommentInfo = cInfo; //获取商家详情中的评论信息
    _tmpPhotoArray = _tmpCommentInfo.pics; //获取评论信息中的图片数组信息 数组中的元素是 CommentPhotoInfo 对象
    _starView.rating = _tmpCommentInfo.stars;
    [_timeLabel setText:_tmpCommentInfo.createdon];
    [_contentLabel setText:_tmpCommentInfo.content];
    _contentString = _contentLabel.text == nil ? @"临时" : _contentLabel.text;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_tmpCommentInfo.head_pic] placeholderImage:IMAGE(@"icon_headportrait")];
    
    if (_tmpCommentInfo.user_name.length != 0) {
        
        _nameLabel.text = [_tmpCommentInfo.user_name stringByReplacingCharactersInRange:NSMakeRange(_tmpCommentInfo.user_name.length - 4, 4) withString:@"****"];
    }

    [_praiseBtn setTitle:[NSString stringWithFormat:@"%@",@""] forState:UIControlStateNormal];
    if (_tmpCommentInfo.is_favorite == 1) { // 接口返回1 表示用户可以点赞
        _praiseBtn.selected = NO;
         [_praiseBtn setTitleColor:[UIColor colorWithHexColor:@"a7a7a7" alpha:1] forState:UIControlStateNormal];
    }else{
        _praiseBtn.selected = YES;
         [_praiseBtn setTitleColor:[UIColor colorWithHexColor:@"b80000" alpha:1] forState:UIControlStateNormal];
         [[_praiseBtn layer] setBorderColor:[UIColor colorWithHexString:@"0xb80000"].CGColor];
    }
    
    if (_tmpCommentInfo.likes == 0 ) {
        [_praiseBtn setTitle:[NSString stringWithFormat:@"%@",@"有用"] forState:UIControlStateNormal];
    }else {
        [_praiseBtn setTitle:[NSString stringWithFormat:@"%@",_tmpCommentInfo.likes == 0 ? @"" : @(_tmpCommentInfo.likes)] forState:UIControlStateNormal];
    }
    [self loadImage];

}

//这个方法是在详情页面调用的
- (void)bindData:(BusinessdetailInfo *)dInfo{
    _praiseBtn.hidden = YES;
    
    if (dInfo == nil) {
        return;
    }
   
    _tmpCommentInfo = dInfo.Comment; //获取商家详情中的评论信息
    _tmpPhotoArray = _tmpCommentInfo.pics; //获取评论信息中的图片数组信息 数组中的元素是 CommentPhotoInfo 对象
    _starView.rating = _tmpCommentInfo.stars;
    [_timeLabel setText:_tmpCommentInfo.createdon];
    [_contentLabel setText:_tmpCommentInfo.content];
    _contentString = _contentLabel.text == nil ? @"临时" : _contentLabel.text;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_tmpCommentInfo.head_pic] placeholderImage:IMAGE(@"icon_headportrait")];
    
    if (_tmpCommentInfo.user_name.length != 0) {
        
        _nameLabel.text = [_tmpCommentInfo.user_name stringByReplacingCharactersInRange:NSMakeRange(_tmpCommentInfo.user_name.length - 4, 4) withString:@"****"];
    }

    [self loadImage];
}


//加载排版评论图片
- (void)loadImage{
    if (_tmpPhotoArray.count != 0) {
        
        if (_imageBgView == nil) {
            _imageBgView = [[UIView alloc] init];
            _imageBgView.userInteractionEnabled = YES;
            [self.contentView addSubview:_imageBgView];
        }
        
        [_imageBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(_contentLabel.mas_right);
            make.height.mas_equalTo(_tmpPhotoArray.count > 3 ? (IMAGE_WIDTH + 10) * 2 : (IMAGE_WIDTH + 10));
        }];
        
        NSInteger marin = 10;
        _imagev1.hidden = YES;
        _imagev2.hidden = YES;
        _imagev3.hidden = YES;
        _imagev4.hidden = YES;
        _imagev5.hidden = YES;
        _imagev6.hidden = YES;
        
        
        for (NSInteger i = 0; i < _tmpPhotoArray.count; i++) {
            
            CommentPhotoInfo *photo = [_tmpPhotoArray objectAtIndex:i];
            
            switch (i) {
                case 0:
                {
                    if(!_imagev1){
                        _imagev1 = [[UIImageView alloc] init];
                    }
                    
                    _imagev1.hidden = NO;
                    
                    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",photo.Url]; //格式化是为了从服务器获取指定大小的图片
                    DebugNSLog(@"评论图片的地址：%@",url);
                    [_imagev1 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"loading")];
                    _imagev1.contentMode = UIViewContentModeScaleAspectFill;
                    [_imageBgView addSubview:_imagev1];
                    
                    _imagev1.tag = i;
                    _imagev1.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagedidTap:)];
                    [_imagev1 addGestureRecognizer:tap];
                    
                    [_imagev1 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(i%4 * IMAGE_WIDTH + i%4 * marin);
                        make.top.mas_equalTo(i/4 *IMAGE_WIDTH + i/4 *marin);
                        make.width.mas_equalTo(IMAGE_WIDTH);
                        make.height.mas_equalTo(IMAGE_WIDTH);
                    }];
                    
                }
                    break;
                case 1:
                {
                    if(!_imagev2){
                        _imagev2 = [[UIImageView alloc] init];
                    }
                    
                    _imagev2.hidden = NO;
                    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",photo.Url]; //格式化是为了从服务器获取指定大小的图片
                     DebugNSLog(@"评论图片的地址：%@",url);
                    [_imagev2 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"loading")];
                    _imagev2.contentMode = UIViewContentModeScaleAspectFill;
                    [_imageBgView addSubview:_imagev2];
                    
                    _imagev2.tag = i;
                    _imagev2.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagedidTap:)];
                    [_imagev2 addGestureRecognizer:tap];
                    
                    
                    [_imagev2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(i%4 * IMAGE_WIDTH + i%4 * marin);
                        make.top.mas_equalTo(i/4 *IMAGE_WIDTH + i/4 *marin);
                        make.width.mas_equalTo(IMAGE_WIDTH);
                        make.height.mas_equalTo(IMAGE_WIDTH);
                    }];
                    
                }
                    break;
                case 2:
                {
                    if(!_imagev3){
                        _imagev3 = [[UIImageView alloc] init];
                    }
                    _imagev3.hidden = NO;
                    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",photo.Url]; //格式化是为了从服务器获取指定大小的图片
                     DebugNSLog(@"评论图片的地址：%@",url);
                    [_imagev3 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"loading")];
                    _imagev3.contentMode = UIViewContentModeScaleAspectFill;
                    [_imageBgView addSubview:_imagev3];
                    
                    _imagev3.tag = i;
                    _imagev3.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagedidTap:)];
                    [_imagev3 addGestureRecognizer:tap];
                    
                    
                    [_imagev3 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(i%4 * IMAGE_WIDTH + i%4 * marin);
                        make.top.mas_equalTo(i/4 *IMAGE_WIDTH + i/4 *marin);
                        make.width.mas_equalTo(IMAGE_WIDTH);
                        make.height.mas_equalTo(IMAGE_WIDTH);
                    }];
                    
                }
                    break;
                case 3:
                {
                    if(!_imagev4){
                        _imagev4 = [[UIImageView alloc] init];
                    }
                    _imagev4.hidden = NO;
                    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",photo.Url]; //格式化是为了从服务器获取指定大小的图片
                     DebugNSLog(@"评论图片的地址：%@",url);
                    [_imagev4 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"loading")];
                    _imagev4.contentMode = UIViewContentModeScaleAspectFill;
                    [_imageBgView addSubview:_imagev4];
                    
                    _imagev4.tag = i;
                    _imagev4.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagedidTap:)];
                    [_imagev4 addGestureRecognizer:tap];
                    
                    
                    [_imagev4 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(i%4 * IMAGE_WIDTH + i%4 * marin);
                        make.top.mas_equalTo(i/4 *IMAGE_WIDTH + i/4 *marin);
                        make.width.mas_equalTo(IMAGE_WIDTH);
                        make.height.mas_equalTo(IMAGE_WIDTH);
                    }];
                    
                }
                    break;
                case 4:
                {
                    if(!_imagev5){
                        _imagev5 = [[UIImageView alloc] init];
                    }
                    _imagev5.hidden = NO;
                    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",photo.Url]; //格式化是为了从服务器获取指定大小的图片
                     DebugNSLog(@"评论图片的地址：%@",url);
                    [_imagev5 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"loading")];
                    _imagev5.contentMode = UIViewContentModeScaleAspectFill;
                    [_imageBgView addSubview:_imagev5];
                    
                    _imagev5.tag = i;
                    _imagev5.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagedidTap:)];
                    [_imagev5 addGestureRecognizer:tap];
                    
                    
                    [_imagev5 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(i%4 * IMAGE_WIDTH + i%4 * marin);
                        make.top.mas_equalTo(i/4 *IMAGE_WIDTH + i/4 *marin);
                        make.width.mas_equalTo(IMAGE_WIDTH);
                        make.height.mas_equalTo(IMAGE_WIDTH);
                    }];
                    
                }
                    break;
                case 5:
                {
                    if(!_imagev6){
                        _imagev6 = [[UIImageView alloc] init];
                    }
                    _imagev6.hidden = NO;
                    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",photo.Url]; //格式化是为了从服务器获取指定大小的图片
                     DebugNSLog(@"评论图片的地址：%@",url);
                    [_imagev6 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"loading")];
                    _imagev6.contentMode = UIViewContentModeScaleAspectFill;
                    [_imageBgView addSubview:_imagev6];
                    
                    _imagev6.tag = i;
                    _imagev6.userInteractionEnabled = YES;
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagedidTap:)];
                    [_imagev6 addGestureRecognizer:tap];
                    
                    [_imagev6 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(i%4 * IMAGE_WIDTH + i%4 * marin);
                        make.top.mas_equalTo(i/4 *IMAGE_WIDTH + i/4 *marin);
                        make.width.mas_equalTo(IMAGE_WIDTH);
                        make.height.mas_equalTo(IMAGE_WIDTH);
                    }];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }else{
        [_imageBgView removeFromSuperview];
        _imageBgView    = nil;
        _tmpPhotoArray  = nil;
        _imagev1        = nil;
        _imagev2        = nil;
        _imagev3        = nil;
        _imagev4        = nil;
        _imagev5        = nil;
        _imagev6        = nil;
        
    }
}


//详情页面加载没有评论的隐藏相关控件
- (void)bindDataWithNoCommnet{
    _starView.hidden = YES;
    _timeLabel.hidden = YES;
    _nameLabel.hidden = YES;
    _contentLabel.hidden = YES;
    _headImage.hidden = YES;
    _praiseBtn.hidden = YES;
}



//点击图片事件
- (void)imagedidTap:(UITapGestureRecognizer *)tap{
    
    UIImageView *tmpImageV = (UIImageView *)tap.view;
    if (_delegate && [_delegate respondsToSelector:@selector(commentImageClick:index:)]) {
        [_delegate commentImageClick:_tmpCommentInfo index:tmpImageV.tag];
    }
}

//点赞事件
- (void)PraiseClick:(UIButton *)btn{
    
    if (!btn.selected) {
        btn.selected = YES;
        [btn setTitle:[NSString stringWithFormat:@"%@",@(_tmpCommentInfo.likes)] forState:UIControlStateNormal];
         [_praiseBtn setTitleColor:[UIColor colorWithHexColor:@"b80000" alpha:1] forState:UIControlStateNormal];
    }else{
        [METoast toastWithMessage:@"不能重复点赞"];
        return;
    }
   
    if(_praisedBlock){
        _praisedBlock(_tmpCommentInfo,btn);
    }
}

- (CGFloat)cellHeight{

    CGSize size = [_contentString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width - 100, 10000000)];
    return size.height + 15 + 60 + 15 + 15 + 40 +
    (_tmpPhotoArray.count == 0 ? -5 : (_tmpPhotoArray.count > 4 ? (IMAGE_WIDTH + 10) * 2 : (IMAGE_WIDTH + 10)) - 8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
