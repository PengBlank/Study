//
//  StoreBalanceTableViewCell.m
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "StoreBalanceTableViewCell.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
#import "UIImageView+WebCache.h" // 图片加载
#import "DefineConfig.h"

@interface StoreBalanceTableViewCell ()

@property (nonatomic, strong) UIView *bgView;               // 背景View
@property (nonatomic, strong) UIImageView *iconImageView;   // 图标View
@property (nonatomic, strong) UILabel *titleLabel;          // 店名Label
@property (nonatomic, strong) UILabel *moneyLabel;          // 钱Label
@property (nonatomic, strong) UILabel *sBLabel;             // 实体店余额文字
@property (nonatomic, strong) UIButton *prepayButton;       // 充值Btn
@property (nonatomic, strong) UIButton *billButton;         // 账单Btn

@property (nonatomic, strong) UIView *horizontalLineView;       // 横线View
@property (nonatomic, strong) UIView *verticalLinView;          // 竖线View

@property (nonatomic, copy) sbCellButtonBlock block;        // block
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) StoreBalanceInfo *model;

@end

@implementation StoreBalanceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        [self constraintUI];
    }
    return  self;
}
// 创建UI
- (void)createUI
{
    [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    // 背景
    self.bgView = [[UIView alloc] init];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview: self.bgView];
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    [self.iconImageView setClipsToBounds:YES];
    [self.iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.bgView addSubview: self.iconImageView];
    [self.iconImageView setImage:[UIImage imageNamed:@"loading"]];
    // 店名
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@16,@18])]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.bgView addSubview: self.titleLabel];
    self.titleLabel.text = @"喵味西餐啊";
    // 钱
    self.moneyLabel = [[UILabel alloc] init];
//    [self.moneyLabel setFont:[UIFont systemFontOfSize:22]];
    [self.moneyLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:22]];
    [self.moneyLabel setTextColor:[UIColor colorWithHexString:@"00b99b"]];
    [self.bgView addSubview: self.moneyLabel];
    self.moneyLabel.text = @"¥120";
    // 实体店余额
    self.sBLabel = [[UILabel alloc] init];
    [self.sBLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sBLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.bgView addSubview: self.sBLabel];
    self.sBLabel.text = @"实体店余额";
    // 横线
    self.horizontalLineView = [[UIView alloc] init];
    [self.horizontalLineView setBackgroundColor:[UIColor colorWithHexString:@"e8e8e8"]];
    [self.bgView addSubview:self.horizontalLineView];
    // 竖线
    self.verticalLinView = [[UIView alloc] init];
    [self.verticalLinView setBackgroundColor:[UIColor colorWithHexString:@"e8e8e8"]];
    [self.bgView addSubview:self.verticalLinView];
    
    // 充值按钮
    self.prepayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prepayButton setTitle:@"充值" forState:UIControlStateNormal];
    [self.prepayButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.prepayButton setBackgroundImage:[UIImage imageNamed:@"buttonClick-highlight"] forState:UIControlStateHighlighted]; // 高亮图片
    [self.prepayButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.bgView addSubview:self.prepayButton];
    
    self.prepayButton.tag = 1000;
    [self.prepayButton addTarget:self action:@selector(sbButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    // 账单按钮
    self.billButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.billButton setTitle:@"账单" forState:UIControlStateNormal];
    [self.billButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.billButton setBackgroundImage:[UIImage imageNamed:@"buttonClick-highlight"] forState:UIControlStateHighlighted]; // 高亮图片
    [self.billButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.bgView addSubview:self.billButton];
    
    self.billButton.tag = 1001;
    [self.billButton addTarget:self action:@selector(sbButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
// 约束UI
- (void)constraintUI
{
    WS(weakSelf);
    // 背景
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(10);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(10);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
    // 图标
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bgView.mas_left).with.offset(8);
        make.top.mas_equalTo(weakSelf.bgView.mas_top).with.offset(8);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    // 店名
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bgView.mas_top).with.offset(13);
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).with.offset(g_fitFloat(@[@24,@30]));
        make.right.mas_equalTo(weakSelf.bgView.mas_right);//.with.offset(-5);
    }];
    // 钱
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).with.offset(13);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).with.offset(-5);
    }];
    // 实体店余额文字
    [self.sBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.moneyLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(weakSelf.moneyLabel.mas_left);
    }];
    // 横线
    [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(weakSelf.bgView.mas_left);
        make.right.mas_equalTo(weakSelf.bgView.mas_right);
        make.height.mas_equalTo(@1);
    }];
    // 竖线
    [self.verticalLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.horizontalLineView.mas_bottom).with.offset(5);
        make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom).with.offset(-5);
        make.width.equalTo(@1);
    }];
    // 充值按钮
    [self.prepayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bgView.mas_left);//.with.offset(5);
        make.top.mas_equalTo(weakSelf.horizontalLineView.mas_bottom);//.with.offset(5);
        make.right.mas_equalTo(weakSelf.verticalLinView.mas_left).with.offset(1);
        make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom);//.with.offset(-5);
    }];
    // 账单
    [self.billButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.verticalLinView.mas_right).with.offset(-1);
        make.top.mas_equalTo(weakSelf.horizontalLineView.mas_bottom);//.with.offset(5);
        make.right.mas_equalTo(weakSelf.bgView.mas_right);//.with.offset(-5);
        make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom);//.with.offset(-5);
    }];
}

#pragma mark - 刷新数据
- (void)refreshUIDataWithModel:(StoreBalanceInfo *)sbInfo WithBlock:(sbCellButtonBlock)block
{
    // 图标
//    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",sbInfo.merchantLogo];
//    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",@"http://ppt360.com/background/UploadFiles_6733/201012/2010122016291897.jpg"];
    
    self.model = sbInfo;
    self.block = block;
    
//    DebugNSLog(@"商家logoURL== %@",sbInfo.merchantLogo);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:sbInfo.merchantLogo] placeholderImage:[UIImage imageNamed:@"loading"]];
    // 店名
    [self.titleLabel setText:sbInfo.merchantName];
    // 钱 不知道为何返回的string189.18 用NSString显示为189.17999999999...
    [self.moneyLabel setText:[NSString stringWithFormat:@"¥%.2f",[sbInfo.balance floatValue]]];
    // 判断是否充值
    WS(weakSelf);
    if ([sbInfo.enableCharge integerValue] == 0) {
        // 不充值
        [self.prepayButton setHidden:YES];
        [self.verticalLinView setHidden:YES];
        [self.billButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.bgView.mas_left);
            make.top.mas_equalTo(weakSelf.horizontalLineView.mas_bottom);
            make.right.mas_equalTo(weakSelf.bgView.mas_right);
            make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom);
        }];
    }else
    {// 充值
        [self.prepayButton setHidden:NO];
        [self.verticalLinView setHidden:NO];
        [self.billButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.verticalLinView.mas_right).with.offset(-1);
            make.top.mas_equalTo(weakSelf.horizontalLineView.mas_bottom);
            make.right.mas_equalTo(weakSelf.bgView.mas_right);
            make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom);
        }];
    }
}

#pragma mark - cellBlock
-(void)cellButtonClickBlock:(sbCellButtonBlock)block
{
    self.block = block;
}

#pragma mark - 按钮点击
-(void)sbButtonClick:(UIButton *)sender
{
    if (self.block) {
        self.block(self.model,sender.tag);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
