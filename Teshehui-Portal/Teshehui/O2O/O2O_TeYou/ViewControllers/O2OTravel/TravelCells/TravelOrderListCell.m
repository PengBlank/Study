//
//  TravelOrderListCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelOrderListCell.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "NSString+Addition.h"
#import "ZXingObjC.h"

@implementation TravelOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _topMarkImage = [[UIImageView alloc] init];                         // 标题图标
        [_topMarkImage setImage:IMAGE(@"shopC")];
        [self.contentView addSubview:_topMarkImage];
        
        _titleLabel = [[UILabel alloc] init];                               // 标题
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_titleLabel];
        
        _orderNumLbale = [[UILabel alloc] init];                              // 订单号－－－
        [_orderNumLbale setFont:[UIFont systemFontOfSize:14]];
        [_orderNumLbale setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_orderNumLbale];
//        [_orderNumLbale setText:@"这里是订单号PNGH54214567"];
        
        _myTicketName = [[UILabel alloc] init];                             // 新的票名
        [_myTicketName setFont:[UIFont systemFontOfSize:14]];
        [_myTicketName setTextColor:[UIColor colorWithHexString:@"343434"]];
        [_myTicketName setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_myTicketName];
        
        _topLineView = [[UIView alloc] init];                               // 顶部线
        [_topLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_topLineView];
        
        _midLineView = [[UIView alloc] init];                               // 中间线
        [_midLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_midLineView];
        
        _bottomLineView = [[UIView alloc] init];                            // 底部线
        [_bottomLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_bottomLineView];
        
        _logoImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_logoImage];
        
        _economizeImage = [[UIImageView alloc] init];                       // 省图片
        [_economizeImage setImage:IMAGE(@"save")];
        [self.contentView addSubview:_economizeImage];
        
        _economizeLabel = [[UILabel alloc] init];                           // 省
        [_economizeLabel setFont:[UIFont systemFontOfSize:14]];
        [_economizeLabel setTextColor:[UIColor colorWithHexString:@"317ee7"]];
        [self.contentView addSubview:_economizeLabel];
        
        _priceLabel = [[UILabel alloc] init];                               // 价格
        [_priceLabel setFont:[UIFont systemFontOfSize:14]];
        [_priceLabel setTextColor:[UIColor colorWithHexString:@"b80000"]];
        [self.contentView addSubview:_priceLabel];
        
        _ticketType = [[UILabel alloc] init];
        [_ticketType setFont:[UIFont systemFontOfSize:14]];
        [_ticketType setTextColor:[UIColor colorWithHexString:@"424242"]];
        [self.contentView addSubview:_ticketType];
        
        _creationTime = [[UILabel alloc] init];                            // 订单创建时间－－－
        [_creationTime setFont:[UIFont systemFontOfSize:13]];
        [_creationTime setTextColor:[UIColor colorWithHexString:@"606060"]];
        [self.contentView addSubview:_creationTime];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];      // 评论按钮
        [_commentButton setTitle:@"去评价" forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
        [[_commentButton titleLabel]setFont:[UIFont systemFontOfSize:13]];
        [_commentButton.layer setCornerRadius:5.0f];
        [_commentButton.layer setBorderWidth:1.0];
        [_commentButton.layer setBorderColor:[UIColor colorWithHexString:@"b5b5b5"].CGColor];
        [self.contentView addSubview:_commentButton];
        
        _rightArrow = [[UIImageView alloc] init];                           // 右箭头
        [_rightArrow setImage:IMAGE(@"right")];
        [self.contentView addSubview:_rightArrow];
        
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);
// 标题图标
    [_topMarkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(14);
        make.size.mas_equalTo(CGSizeMake(18, 17));
    }];
// 顶部线
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).mas_equalTo(43);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];
// 商家图标
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom).offset(g_fitFloat(@[@15,@20,@(ScaleHEIGHT(20))]));
        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom).offset(12);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
//        make.size.mas_equalTo(CGSizeMake(ScaleWIDTH(60), ScaleWIDTH(60)));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
// 中间线
    [_midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.logoImage.mas_bottom).mas_equalTo(12);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];
// 价格
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.logoImage.mas_left);
        make.top.mas_equalTo(weakSelf.midLineView.mas_bottom).mas_equalTo(17.5);
    }];
// 底部线
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).mas_equalTo(17);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];
// －－－－－－订单创建时间
    [_creationTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNumLbale.mas_left);
        make.bottom.mas_equalTo(weakSelf.logoImage.mas_bottom);
    }];
// 顶部标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.topMarkImage.mas_right).offset(5);
        make.centerY.mas_equalTo(weakSelf.topMarkImage.mas_centerY);
      //  make.right.lessThanOrEqualTo(weakSelf.downloadImage.mas_left).with.offset(-2);
    }];
// 订单号
    [_orderNumLbale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.logoImage.mas_top);
        make.left.mas_equalTo(weakSelf.logoImage.mas_right).offset(10);
    }];
// 票名
    [_myTicketName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNumLbale.mas_left);
        make.centerY.mas_equalTo(weakSelf.logoImage.mas_centerY);
        make.right.mas_equalTo(weakSelf.rightArrow.mas_left).offset(-65);
    }];
// 省
    [_economizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.5);
        make.centerY.mas_equalTo(weakSelf.priceLabel.mas_centerY);
    }];
// 省图标
    [_economizeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(weakSelf.priceLabel.mas_centerY);
        make.right.mas_equalTo(weakSelf.economizeLabel.mas_left).with.offset(-5);
    }];
// 评论按钮
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.bottomLineView.mas_bottom).with.offset(g_fitFloat(@[@10.5,@7.5,@6.5])); //i5 10.5 i6 7.5 6p 6.5
        make.top.mas_equalTo(weakSelf.bottomLineView.mas_bottom).offset(8.5);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.5);
//        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-10);
//        make.width.mas_equalTo(60);
        make.size.mas_equalTo(CGSizeMake(74, 28));
    }];
// 右边箭头
    [_rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.5);
        make.centerY.mas_equalTo(weakSelf.logoImage.mas_centerY);
        make.width.mas_equalTo(9.3);
        make.height.mas_equalTo(15);
    }];
}

- (void)bindData:(TravelOrderInfo *)baseInfo type:(NSInteger)type{

    self.orderInfo = baseInfo;

    
    self.titleLabel.text        = [NSString stringWithFormat:@"%@",baseInfo.touristName];
    
    self.orderNumLbale.text = [NSString stringWithFormat:@"%@",baseInfo.tId];
    
    self.myTicketName.text        = [NSString stringWithFormat:@"%@",baseInfo.ticketName];
    
    NSString *urlStirng = [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h/%@",baseInfo.merchantLogo,@"180",@"180"];
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:urlStirng] placeholderImage:IMAGE(@"loading")];
    
    
// 价格－－－－－
    CGFloat price = baseInfo.price.floatValue;
    CGFloat coupon = baseInfo.coupon.floatValue;
    NSString *priceStr = @"";
    if(price == 0 && coupon != 0){
        
        priceStr  = [NSString stringWithFormat:@" %@现金券",baseInfo.price];
        
    }else if(price == 0 && coupon == 0){
        
    }else if (price != 0 && coupon == 0){
        
        priceStr  = [NSString stringWithFormat:@" ￥%@",baseInfo.price];
        
    }else{
        priceStr  = [NSString stringWithFormat:@" ￥%@＋%@现金券",baseInfo.price,baseInfo.coupon];
    }
    // 拼接价格 @"支付类型"
    NSString *payWay = baseInfo.payWay;
    if (payWay == nil) {
        payWay = @"";
    }
    NSMutableAttributedString *payType = [[NSMutableAttributedString alloc]initWithString:payWay
                                                                                attributes:@{NSForegroundColorAttributeName:
                                                                                                 [UIColor colorWithHexString:@"343434"]}];
    // 设置红色
    NSAttributedString *attPrice = [[NSAttributedString alloc]initWithString:priceStr
                                                                  attributes:@{NSForegroundColorAttributeName:
                                                                                   [UIColor colorWithHexString:@"b80000"]}];
    [payType appendAttributedString:attPrice];
    self.priceLabel.attributedText = payType;   // 价格
    
    
   // self.residueLabel.text      = [NSString stringWithFormat:@"剩余次数：%@",baseInfo.remainedDays];
    
    if (baseInfo.saveMoney.floatValue == 0) {
        self.economizeImage.hidden = YES;
        self.economizeLabel.hidden = YES;
    }else{
        self.economizeImage.hidden = NO;
        self.economizeLabel.hidden = NO;
        self.economizeImage.image   = IMAGE(@"saveticket");                 //省图片
        self.economizeLabel.text    = baseInfo.saveMoney;                   //省了多少钱
    }
    


  //  self.availabilityLabel.text = [NSString stringWithFormat:@"有效期截止日：%@",baseInfo.validityDate];
//    self.useDateLabel.text = [NSString stringWithFormat:@"票使用日期：%@",baseInfo.useDate];
    self.creationTime.text = [NSString stringWithFormat:@"%@",baseInfo.orderDate]; // 创建时间
    
    if (type == 1) {
//        self.codeImage.hidden = YES;
//        self.codeLabel.hidden = YES;
//        self.downloadImage.hidden = YES;
        // 是否已评论 0否 1是!baseInfo.isComment
        if ([baseInfo.isComment integerValue] == 1) {
            [self.commentButton setTitle:@"已评价" forState:UIControlStateNormal];
            [self.commentButton.layer setBorderColor:[UIColor clearColor].CGColor];
        }else
        {
            [_commentButton setTitle:@"去评价" forState:UIControlStateNormal];
            [_commentButton.layer setBorderColor:[UIColor colorWithHexString:@"b5b5b5"].CGColor];
        }
        [self.commentButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }else{

        // 可用订单页面 隐藏底部线和按钮
        self.bottomLineView.hidden = YES;
        self.commentButton.hidden = YES;

//        [self creatQRCodeImage];
        //二期改版 二维码点击事件去处
//        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
//        [self.codeImage addGestureRecognizer:imageTap];

        // 点击保存二维码
//        UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction:)];
//        [self.codeLabel addGestureRecognizer:labelTap];
//        
//        UITapGestureRecognizer *downloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction:)];
//        [self.downloadImage addGestureRecognizer:downloadTap];
    }
}

//- (void)creatQRCodeImage{
//    NSString *dataStr = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",self.orderInfo.tId,self.orderInfo.merId];
//
//    //base64
//    dataStr = [dataStr base64EncodedString];
//    
//    if (dataStr)
//    {
//        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
//        ZXBitMatrix *result = [writer encode:dataStr
//                                      format:kBarcodeFormatQRCode
//                                       width:48
//                                      height:48
//                                       error:nil];
//        
//        if (result)
//        {
//            ZXImage *image = [ZXImage imageWithMatrix:result];
//            
//            self.codeImage.image = [UIImage imageWithCGImage:image.cgimage];
//        } else {
//            self.codeImage.image = nil;
//        }
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                        message:@"用户登录信息不完整，请重新登录"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"重新登录", nil];
//        [alert show];
//    }
//}
// 点击二维码图片暂时不用
//- (void)imageTapAction:(UITapGestureRecognizer *)tap{
//    if (self.codeImageClickBlock) {
//        self.codeImageClickBlock(self.orderInfo);
//    }
//}
// 点击保存二维码按钮的
//- (void)labelTapAction:(UITapGestureRecognizer *)tap{
//    if (self.saveQRImageClickBlock) {
//        self.saveQRImageClickBlock(self.orderInfo.ticketName,self.orderInfo.merId);
//    }
//    
//}

#pragma mark - 评论按钮点击
- (void)buttonClick
{
    WS(weakSelf);
    if (self.commentButtonClickBlock)
    {
        // YES为button
        weakSelf.commentButtonClickBlock(self.orderInfo,0,YES);
    }
}

@end
