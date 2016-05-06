//
//  SceneOrderListCell.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneOrderListCell.h"

#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
#import "UIImageView+WebCache.h" // 图片加载

@interface SceneOrderListCell ()
{
    UIImageView     *_imageView;    // 头像
    UILabel         *_titleLable;   // 订单名
    UILabel         *_quantityLable;// 数量
    UILabel         *_priceLable;   // 价格
//    UILabel         *_ticketLable;  // 现金券
    UIImageView     *_arrowImage;   // 右边箭头
    UIView          *_lineView;     // 线
    UILabel         *_dateLabel;    // 日期
    UIButton        *_statusButton; // 状态Button
    
    buttonBlock     _buttonBlock;   // 按钮点击回调block
    NSInteger       _status;        // 订单状态
}
@end

@implementation SceneOrderListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self constraintUI];
    }
    return  self;
}

#pragma mark - 创建UI
-(void)createUI
{
    // 图片
    _imageView = [[UIImageView alloc] init];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [_imageView.layer setBorderWidth:0.5];
    [_imageView.layer setBorderColor:[UIColor colorWithHexString:@"dedede"].CGColor];
    [self.contentView addSubview:_imageView];
//    _imageView.backgroundColor = [UIColor orangeColor];
    // 标题
    _titleLable = [[UILabel alloc] init];
    [_titleLable setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14,@15])]];
    [_titleLable setTextColor:[UIColor colorWithHexString:@"343434"]];
    [_titleLable setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:_titleLable];
    _titleLable.text =  @"品味一场无与伦比的意式风情浪漫aaaaa";
    // 份量
    _quantityLable = [[UILabel alloc] init];
    [_quantityLable setFont:[UIFont systemFontOfSize:g_fitFloat(@[@13,@14])]];
    [_quantityLable setTextColor:[UIColor colorWithHexString:@"606060"]];
    [_quantityLable setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:_quantityLable];
    _quantityLable.text = @"份数：1份";
    // 价格
    _priceLable = [[UILabel alloc] init];
    [_priceLable setFont:[UIFont systemFontOfSize:g_fitFloat(@[@13,@14])]];
    [_priceLable setTextColor:[UIColor colorWithHexString:@"606060"]];
    [self.contentView addSubview:_priceLable];
    NSString *priceStr = [NSString stringWithFormat:@"金额：¥%@+%@现金券",@"9763",@"984"];
    NSInteger len = priceStr.length;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(3, len-3)];
    _priceLable.attributedText = attrStr;
    // 现金券
//    _ticketLable = [[UILabel alloc] init];
//    [_ticketLable setFont:[UIFont systemFontOfSize:12]];
//    [_ticketLable setTextColor:[UIColor colorWithHexString:@"606060"]];
//    [self.contentView addSubview:_ticketLable];
//    _ticketLable.text = @"  已抵扣974现金券";
    // 箭头
    _arrowImage = [[UIImageView alloc] init];
    [_arrowImage setImage:[UIImage imageNamed:@"right"]];
    [self.contentView addSubview:_arrowImage];
    // 线
    _lineView = [[UIView alloc] init];
    [_lineView setBackgroundColor:[UIColor colorWithHexString:@"dedede"]];
    [self.contentView addSubview:_lineView];
    // 日期
    _dateLabel = [[UILabel alloc] init];
    [_dateLabel setFont:[UIFont systemFontOfSize:13]];
    [_dateLabel setTextColor:[UIColor colorWithHexString:@"606060"]];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.text = @"2016-03-08 18:36:30";
    // 状态按钮
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_statusButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_statusButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [_statusButton setEnabled:NO]; // 不可点击
    _statusButton.layer.borderColor = [UIColor clearColor].CGColor;
    _statusButton.layer.borderWidth = 0.5;
    _statusButton.layer.cornerRadius = 2;
    // 根据类型来设置熟悉
    [self.contentView addSubview:_statusButton];
}

#pragma mark - 约束
-(void)constraintUI
{
    WS(weakSelf);
// 图片
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(g_fitFloat(@[@10,@15]));
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(g_fitFloat(@[@10,@15]));
//        make.width.mas_equalTo(@100);
//        make.height.mas_equalTo(@75);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@75);
    }];
// 标题
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_right).with.offset(10);
        make.top.mas_equalTo(_imageView.mas_top);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(g_fitFloat(@[@-15,@-45]));
        
    }];
// 份量
    [_quantityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLable.mas_left);
        make.top.mas_equalTo(_titleLable.mas_bottom).with.offset(12);
        make.right.mas_equalTo(_arrowImage.mas_left).with.offset(-10);
        
    }];
// 价格
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLable.mas_left);
//        make.top.mas_equalTo(_quantityLable.mas_bottom).with.offset(4);
        make.bottom.mas_equalTo(_imageView.mas_bottom);
//        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-10);
    }];
// 现金券
//    [_ticketLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_priceLable.mas_right);
//        make.bottom.mas_equalTo(_imageView.mas_bottom);
////        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-10);
//    }];
// 箭头
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-13);
        make.centerY.mas_equalTo(_imageView.mas_centerY);
        make.width.mas_equalTo(@9);
        make.height.mas_equalTo(@15);
    }];
// 线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_left);
        make.top.mas_equalTo(_imageView.mas_bottom).with.offset(g_fitFloat(@[@10,@15]));
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@0.5);
    }];
// 日期
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_left);
        make.top.mas_equalTo(_lineView.mas_bottom);
        //        make.right.mas_equalTo(_stateButton.mas_left).with.offset(-10);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
// 状态按钮
    [_statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(_dateLabel.mas_centerY);
        make.width.mas_equalTo(@65);
    }];
    
}

#pragma mark - cell加载UI数据（block回调）
-(void)refreshUIWithModel:(SceneOrderListModel *)model Type:(NSInteger)type ButtonClickBlock:(buttonBlock)block
{
    _buttonBlock = block;
    model.btn = _statusButton;
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h/%@",model.url,@"200",@"150"];  七牛的方法
    
    NSString *urlStr = [NSString stringWithFormat:@"%@@%@h_%@w_1l_2e",model.url,@"150",@"200"]; // 阿里云
//    DebugNSLog(@"商家logoURL== %@",urlStr);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    _titleLable.text = model.packageName;
    _quantityLable.text = [NSString stringWithFormat:@"份数：%@份",model.packageCount];
   
    NSString *priceStr = [NSString stringWithFormat:@"金额：¥%@+%@现金券",model.amount,model.coupon];
    NSInteger len = priceStr.length;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(3, len-3)];
    _priceLable.attributedText = attrStr;
    
//    _ticketLable.text = [NSString stringWithFormat:@"  已抵扣%@现金券",model.coupon];
    _dateLabel.text = [NSString stringWithFormat:@"下单时间：%@",model.createdon];
    
    _status = [model.status integerValue];
    [self buttonChangeWithStatus:_status Type:type]; // 如果时1可使用列表 不要文字
    
}

#pragma mark - 按钮
// 改版按钮类型
-(void)buttonChangeWithStatus:(NSInteger)status Type:(NSInteger)type
{// 订单状态 0已使用1可使用2未付款3已取消4退款中5已退款
    switch (status) {
        case 0:
        {// 已使用
            [_statusButton setTitle:@"已使用" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
            [_statusButton setEnabled:NO];
            _statusButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        case 1:
        {// 可使用
//            if (type == 1) {
//                [_statusButton setTitle:@"" forState:UIControlStateNormal]; //如果是1可使用列表 不要文字
//            }else

            [_statusButton setTitle:@"可使用" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHexString:@"02b293"] forState:UIControlStateNormal];
            [_statusButton setEnabled:NO];
            _statusButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        case 2:
        {// 未付款
            [_statusButton setTitle:@"去支付" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHexString:@"343434"] forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [_statusButton setEnabled:YES];
            _statusButton.layer.borderColor = [UIColor colorWithHexString:@"606060"].CGColor;
        }
            break;
        case 3:
        {// 已取消
            [_statusButton setTitle:@"已取消" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
            [_statusButton setEnabled:NO];
            _statusButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        case 4:
        {// 退款中
            [_statusButton setTitle:@"退款中" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHexString:@"ff7d25"] forState:UIControlStateNormal];
            [_statusButton setEnabled:NO];
            _statusButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
        case 5:
        {// 已退款
            [_statusButton setTitle:@"已退款" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
            [_statusButton setEnabled:NO];
            _statusButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
            break;
            
        default:
            break;
    }
}
-(void)buttonClick
{// 只有去支付可以点击
    if ([_statusButton.titleLabel.text isEqualToString:@"取消中"]){
        return;
    }
    if (_buttonBlock) {
        _buttonBlock(YES); // yes代表是按钮
    }
    // 
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
