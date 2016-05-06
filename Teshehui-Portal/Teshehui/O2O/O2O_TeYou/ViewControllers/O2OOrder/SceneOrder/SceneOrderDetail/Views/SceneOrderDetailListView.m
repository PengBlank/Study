//
//  SceneOrderDetailListView.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneOrderDetailListView.h"

#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
#import "UIImageView+WebCache.h" // 图片加载

@interface SceneOrderDetailListView ()

//@property (nonatomic, strong) SceneOrderDetailModel *model;     // 数据

@property (nonatomic, strong) UILabel           *titleLabel;    // 标题
@property (nonatomic, strong) UIImageView       *titleImageView;// 商家头像
@property (nonatomic, strong) UILabel           *amountLabel;   // 金额
//@property (nonatomic, strong) UILabel           *ticketLabel;   // 现金券
@property (nonatomic, strong) UILabel           *dineDateLabel; // 就餐时间

@property (nonatomic, strong) UILabel           *quantityLabel; // 购买份数
//@property (nonatomic, strong) UIImageView       *arrowImageView;// 箭头
@property (nonatomic, strong) UILabel           *orderNumLabel; // 订单编号
@property (nonatomic, strong) UIButton          *statusbutton;  // 退款/取消订单 按钮

@property (nonatomic, strong) UILabel           *nameLabel;     // 联系人
@property (nonatomic, strong) UILabel           *phoneLabel;    // 电话

@property (nonatomic, strong) UILabel           *businessName;  // 商家名
@property (nonatomic, strong) UILabel           *businessPhone; // 商家电话
@property (nonatomic, strong) UILabel           *businessLocation;// 商家地址(盖button在上面)

@property (nonatomic, strong) UILabel           *consumeNumLabel; // 消费码
@property (nonatomic, strong) UILabel           *statuslabel;     // 订单状态
@property (nonatomic, strong) UILabel           *consumeDate;     // 消费日期

@property (nonatomic, assign) NSInteger       status;//订单状态0已使用1可使用2未付款3已取消4退款中5已退款
@property (nonatomic, copy) SceneDetailListViewBlock block;

@end

@implementation SceneOrderDetailListView

-(id)initWithFrame:(CGRect)frame WithStatus:(NSInteger)status Block:(SceneDetailListViewBlock)block
{
    if (self = [super initWithFrame:frame])
    {
        self.status = status;
        self.block = block;
        [self createUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)createUI
{
    WS(weakSelf);
    self.backgroundColor = [UIColor clearColor];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height+10, self.frame.size.width, 92)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.frame.origin.y+view2.frame.size.height+10, self.frame.size.width, 105)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view3];
    
#pragma mark -- view1UI
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14,@15])]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [view1 addSubview:self.titleLabel];
    self.titleLabel.text = @"品味一场无与伦比的意式风情海鲜餐 周末闺蜜聚餐好去处 不要错过";
    // 商家头像
    self.titleImageView = [[UIImageView alloc] init];
    [self.titleImageView setClipsToBounds:YES];
    [self.titleImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.titleImageView.layer setBorderWidth:0.5];
    [self.titleImageView.layer setBorderColor:[UIColor colorWithHexString:@"dedede"].CGColor];
    [view1 addSubview:self.titleImageView];
//    self.titleImageView.backgroundColor = [UIColor blackColor];
    // 金额
    self.amountLabel = [[UILabel alloc] init];
    [self.amountLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@13])]];
    [self.amountLabel setTextColor:[UIColor colorWithHexString:@"606060"]];
    [view1 addSubview:self.amountLabel];
    self.amountLabel.text = @"金额：¥9743+964现金券";
    // 现金券
//    self.ticketLabel = [[UILabel alloc] init];
//    [self.ticketLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@11])]];
//    [self.ticketLabel setTextColor:[UIColor colorWithHexString:@"606060"]];
//    [view1 addSubview:self.ticketLabel];
//    self.ticketLabel.text = @"  已抵扣974现金券";
    // 就餐时间
    self.dineDateLabel = [[UILabel alloc] init];
    [self.dineDateLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@13])]];
    [self.dineDateLabel setTextColor:[UIColor colorWithHexString:@"606060"]];
    [view1 addSubview:self.dineDateLabel];
    self.dineDateLabel.text = @"就餐时间：2016-04-01";
    // 购买份数
    self.quantityLabel = [[UILabel alloc] init];
    [self.quantityLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@13])]];
    [self.quantityLabel setTextColor:[UIColor colorWithHexString:@"606060"]];
    [view1 addSubview:self.quantityLabel];
    self.quantityLabel.text = @"购买份数：1份";
    // 线
    UIView *lineView1 = [[UIView alloc] init];
    [lineView1 setBackgroundColor:[UIColor colorWithHexString:@"dedede"]];
    [view1 addSubview:lineView1];
    // 箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [arrowImageView setImage:[UIImage imageNamed:@"right"]];
    [view1 addSubview:arrowImageView];
    //订单编号
    self.orderNumLabel = [[UILabel alloc] init];
    [self.orderNumLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@13])]];
    [self.orderNumLabel setTextColor:[UIColor colorWithHexString:@"606060"]];
    [view1 addSubview:self.orderNumLabel];
    self.orderNumLabel.text = @"订单编号 PNGH54213635";
    // 按钮
    if (self.status == 1 || self.status == 2 || self.status == 3)
    {// 可使用 未付款 已取消
        self.statusbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statusbutton.layer.borderColor = [UIColor colorWithHexString:@"606060"].CGColor;
        self.statusbutton.layer.borderWidth = 0.5;
        self.statusbutton.layer.cornerRadius = 2;
        [self.statusbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.statusbutton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        self.statusbutton.tag = 1001;
        [self.statusbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
        [view1 addSubview:self.statusbutton];
    }
    // view1大按钮 点击进入套餐详情
    UIButton *view1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    view1Button.tag = 1000;
    [view1Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:view1Button];
    
#pragma mark -- View1约束
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left).with.offset(g_fitFloat(@[@10,@15]));
        make.top.mas_equalTo(view1.mas_top).with.offset(g_fitFloat(@[@17]));
        make.right.mas_equalTo(view1.mas_right).with.offset(g_fitFloat(@[@-15,@-30]));
    }];
    // 图片
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).with.offset(g_fitFloat(@[@12]));
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@75);
    }];
    // 金额
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.dineDateLabel.mas_left);
        make.right.mas_equalTo(arrowImageView.mas_left);
        make.bottom.mas_equalTo(weakSelf.dineDateLabel.mas_top).with.offset(-7);
    }];
    // 就餐时间
    [self.dineDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleImageView.mas_right).with.offset(8);
        make.right.mas_equalTo(arrowImageView.mas_left);
        make.centerY.mas_equalTo(weakSelf.titleImageView.mas_centerY);
    }];
    // 购买份数
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.dineDateLabel.mas_left);
        make.top.mas_equalTo(weakSelf.dineDateLabel.mas_bottom).with.offset(7);
        make.right.mas_equalTo(arrowImageView.mas_left);
    }];
    // 箭头arrowImageView
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view1.mas_right).with.offset(g_fitFloat(@[@-10,@-15]));
//        make.centerY.mas_equalTo(view1.mas_centerY);
        make.top.mas_equalTo(view1.mas_top).with.offset(59.5);
        make.width.mas_equalTo(@9);
        make.height.mas_equalTo(@15);
    }];
    // 线
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleImageView.mas_left);
        make.top.mas_equalTo(weakSelf.titleImageView.mas_bottom).with.offset(13);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(@0.5);
    }];
    // 订单编号
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView1.mas_left);
        make.top.mas_equalTo(lineView1.mas_bottom).with.offset(15);
//        make.bottom.mas_equalTo(view1.mas_bottom);
    }];
    // 按钮
    if (self.status == 1 || self.status == 2)
    {
        [self.statusbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view1.mas_right).with.offset(g_fitFloat(@[@-7,@-12]));
            make.width.mas_equalTo(@70);
            make.centerY.mas_equalTo(weakSelf.orderNumLabel.mas_centerY);
        }];
    }else if (self.status == 3)
    {
        [self.statusbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view1.mas_right).with.offset(0);
            make.width.mas_equalTo(@70);
            make.centerY.mas_equalTo(weakSelf.orderNumLabel.mas_centerY);
        }];
    }
    // view1大按钮
    [view1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(view1.mas_top);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(@140);
    }];
    
// －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    
#pragma mark -- view2UI
    // 联系人
    UILabel *nLabel = [[UILabel alloc] init];
    [nLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
    [nLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [view2 addSubview:nLabel];
    nLabel.text = @"联系人";
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
    [self.nameLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [view2 addSubview:self.nameLabel];
    self.nameLabel.text = @"张三";
    // 线
    UIView *lineView2 = [[UIView alloc] init];
    [lineView2 setBackgroundColor:[UIColor colorWithHexString:@"dedede"]];
    [view2 addSubview:lineView2];
    // 手机号
    UILabel *pLabel = [[UILabel alloc] init];
    [pLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
    [pLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [view2 addSubview:pLabel];
    pLabel.text = @"手机号";
    self.phoneLabel = [[UILabel alloc] init];
    [self.phoneLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
    [self.phoneLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [view2 addSubview:self.phoneLabel];
    self.phoneLabel.text = @"15813808555";
    
#pragma mark -- view2约束
    // 联系人
    [nLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view2.mas_left).with.offset(g_fitFloat(@[@10,@15]));
        make.top.mas_equalTo(view2.mas_top);
        make.bottom.mas_equalTo(lineView2.mas_top);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view2.mas_right).with.offset(g_fitFloat(@[@-10,@-15]));
        make.centerY.mas_equalTo(nLabel.mas_centerY);
    }];
    // 线
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nLabel.mas_left);
        make.right.mas_equalTo(view2.mas_right);
        make.centerY.mas_equalTo(view2.mas_centerY);
        make.height.mas_equalTo(@0.5);
    }];
    // 手机
    [pLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nLabel.mas_left);
        make.top.mas_equalTo(lineView2.mas_bottom);
        make.bottom.mas_equalTo(view2.mas_bottom);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view2.mas_right).with.offset(g_fitFloat(@[@-10,@-15]));
        make.centerY.mas_equalTo(pLabel.mas_centerY);
    }];
    
#pragma mark -- view3UI
    UIImageView *icon1 = [[UIImageView alloc] init];
    [icon1 setImage:[UIImage imageNamed:@"ico_shop"]];
//    [icon1 setContentMode:UIViewContentModeScaleToFill];
    [view3 addSubview:icon1];
    
    UIImageView *icon2 = [[UIImageView alloc] init];
    [icon2 setImage:[UIImage imageNamed:@"ico_telephonedetail"]];
//    [icon2 setContentMode:UIViewContentModeScaleToFill];
    [view3 addSubview:icon2];
    
    UIImageView *icon3 = [[UIImageView alloc] init];
    [icon3 setImage:[UIImage imageNamed:@"ico_location"]];
//    [icon3 setContentMode:UIViewContentModeScaleToFill];
    [view3 addSubview:icon3];

    
    // 商家名
    self.businessName = [[UILabel alloc] init];
    [self.businessName setFont:[UIFont systemFontOfSize:g_fitFloat(@[@15])]];
    [self.businessName setTextColor:[UIColor colorWithHexString:@"343434"]];
    [view3 addSubview:self.businessName];
    self.businessName.text = @"Pizza Square 比萨格";
    // 商家电话label 可点击
    self.businessPhone = [[UILabel alloc] init];
    [self.businessPhone setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
    [self.businessPhone setTextColor:[UIColor colorWithHexString:@"343434"]];
    [self.businessPhone setNumberOfLines:2];
    [self.businessPhone setLineBreakMode:NSLineBreakByTruncatingTail];
    [view3 addSubview:self.businessPhone];
    self.businessLocation.text = @"123456789";
    // 商家地址按钮
    UIButton *bPButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bPButton.tag = 1002;
    [bPButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:bPButton];
    
    [view3 addSubview:self.businessPhone];
    // 商家地址label 可点击
    self.businessLocation = [[UILabel alloc] init];
    [self.businessLocation setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
    [self.businessLocation setTextColor:[UIColor colorWithHexString:@"343434"]];
    [self.businessLocation setNumberOfLines:2];
    [self.businessLocation setLineBreakMode:NSLineBreakByTruncatingTail];
    [view3 addSubview:self.businessLocation];
    self.businessLocation.text = @"深圳市南山区海岸城海德大道1008号Pizza Square 比萨格南山区海岸城海德大道1008号深圳市南山区海岸城海德大道";
    // 商家地址按钮
    UIButton *blButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blButton.tag = 1003;
    [blButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:blButton];
//    [blButton setBackgroundColor:[UIColor redColor]];
//    [bPButton setBackgroundColor:[UIColor yellowColor]];
    // 电话右边箭头
    UIImageView *view3PArrow = [[UIImageView alloc] init];
    [view3PArrow setImage:[UIImage imageNamed:@"right"]];
    [view3 addSubview:view3PArrow];
    // 地址右边箭头
    UIImageView *view3LArrow = [[UIImageView alloc] init];
    [view3LArrow setImage:[UIImage imageNamed:@"right"]];
    [view3 addSubview:view3LArrow];

#pragma mark -- view3约束
    // 商家
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view3.mas_left).with.offset(20);
        make.top.mas_equalTo(view3.mas_top).with.offset(12);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@15);
    }];
    // 电话
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(icon1.mas_left);
        make.centerX.mas_equalTo(icon1.mas_centerX);
        make.centerY.mas_equalTo(view3.mas_centerY);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@15);
    }];
    // 定位
    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(icon1.mas_left);
        make.centerX.mas_equalTo(icon1.mas_centerX);
        make.bottom.mas_equalTo(view3.mas_bottom).with.offset(-12);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@15);
    }];
    // 商家名
    [self.businessName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon1.mas_right).with.offset(7);
        make.centerY.mas_equalTo(icon1.mas_centerY);
    }];
    // 商家电话
    [self.businessPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.businessName.mas_left);
        make.right.mas_equalTo(view3.mas_right).with.offset(-25);
        make.centerY.mas_equalTo(icon2.mas_centerY);
    }];
    // 电话按钮
    [bPButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.businessPhone.mas_left);
        make.top.mas_equalTo(weakSelf.businessPhone.mas_top);
        make.right.mas_equalTo(weakSelf.businessPhone.mas_right).with.offset(15);
        make.bottom.mas_equalTo(weakSelf.businessPhone.mas_bottom);
    }];
    // 商家地址
    [self.businessLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.businessName.mas_left);
        make.right.mas_equalTo(view3.mas_right).with.offset(-25);
        make.centerY.mas_equalTo(icon3.mas_centerY);
    }];
    // 地址按钮
    [blButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.businessLocation.mas_left);
        make.top.mas_equalTo(weakSelf.businessLocation.mas_top);
        make.right.mas_equalTo(weakSelf.businessLocation.mas_right).with.offset(15);
        make.bottom.mas_equalTo(weakSelf.businessLocation.mas_bottom);
    }];
    // 电话箭头
    [view3PArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view3.mas_right).with.offset(g_fitFloat(@[@-10,@-15]));
        make.centerY.mas_equalTo(weakSelf.businessPhone.mas_centerY);
        make.width.mas_equalTo(@9);
        make.height.mas_equalTo(@15);
    }];
    // 地址箭头
    [view3LArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view3.mas_right).with.offset(g_fitFloat(@[@-10,@-15]));
        make.centerY.mas_equalTo(weakSelf.businessLocation.mas_centerY);
        make.width.mas_equalTo(@9);
        make.height.mas_equalTo(@15);
    }];
    
#pragma mark -- view4
    // 要根据status来判断
    if (self.status != 2 && self.status !=3)
    {
        // 如果不是 未支付、已取消 状态
        CGFloat vHeight = 51;
        if (self.status == 0){
            vHeight = 70; // 已使用（多一个使用时间label）
        }
        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.frame.origin.y+view3.frame.size.height+10, self.frame.size.width, vHeight)];
        [view4 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:view4];
        
        // 消费码
        self.consumeNumLabel = [[UILabel alloc] init];
        [self.consumeNumLabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@16])]];
        [self.consumeNumLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [view4 addSubview:self.consumeNumLabel];
        self.consumeNumLabel.text = @"消费码：000 000";
        // 状态
        self.statuslabel = [[UILabel alloc] init];
        [self.statuslabel setFont:[UIFont systemFontOfSize:g_fitFloat(@[@15])]];
        [self.statuslabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [view4 addSubview:self.statuslabel];
        // 消费吗
        [self.consumeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view4.mas_left).with.offset(17);
//            make.top.mas_equalTo(view4.mas_top).with.offset(12);
            make.centerY.mas_equalTo(view4.mas_centerY);
        }];
        // 状态
        [self.statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view4.mas_right).with.offset(-19);
            make.centerY.mas_equalTo(view4.mas_centerY);
        }];
        
        if(self.status == 0)
        {// 已使用
            // 验证时间
            self.consumeDate = [[UILabel alloc] init];
            [self.consumeDate setFont:[UIFont systemFontOfSize:g_fitFloat(@[@14])]];
            [self.consumeDate setTextColor:[UIColor colorWithHexString:@"343434"]];
            [view4 addSubview:self.consumeDate];
            self.consumeDate.text = @"验码时间：2016-04-01  18:30:22";
            
            // 消费码
            [self.consumeNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view4.mas_left).with.offset(17);
                make.top.mas_equalTo(view4.mas_top).with.offset(12);
            }];
            
            [self.consumeDate mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.consumeNumLabel.mas_left);
                make.bottom.mas_equalTo(view4.mas_bottom).with.offset(-8);
            }];
        }
    }
}

#pragma mark - 刷新数据
-(void)refreshUIWithModel:(SceneOrderDetailModel *)model
{
//    self.model = model;
    
// 标题
    [self.titleLabel setText:model.packageName];
//图片
    //    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h/%@",model.url,@"200",@"150"];  七牛的方法
    
    NSString *urlStr = [NSString stringWithFormat:@"%@@%@h_%@w_1l_2e",model.url,@"150",@"200"]; // 阿里云
    //    DebugNSLog(@"商家logoURL== %@",urlStr);
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading"]];
// 金额
    NSString *priceStr = [NSString stringWithFormat:@"金额：¥%@+%@现金券",model.amount,model.coupon];
    NSInteger len = priceStr.length;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(3, len-3)];
    [self.amountLabel setAttributedText:attrStr];
// 就餐时间
    NSString *dineStr = model.useDate?:@"";
    if ([dineStr isEqualToString:@""]) {
        dineStr = @"未选择";
    }
    [self.dineDateLabel setText:[NSString stringWithFormat:@"预约时间：%@",dineStr]];
// 购买份数
    [self.quantityLabel setText:[NSString stringWithFormat:@"份数：%@份",model.packageCount?:@""]];
// 订单编号
    [self.orderNumLabel setText:[NSString stringWithFormat:@"订单编号  %@",model.o2oTradeNo?:@""]];
    
    
// 联系人
    [self.nameLabel setText:[NSString stringWithFormat:@"%@",model.userName?:@""]];
// 手机号
    [self.phoneLabel setText:[NSString stringWithFormat:@"%@",model.mobile?:@""]];
    
    
// 商家名
    [self.businessName setText:[NSString stringWithFormat:@"%@",model.merchantName?:@""]];
// 商家电话
    [self.businessPhone setText:[NSString stringWithFormat:@"%@",model.merchantMobile?:@""]];
// 商家地址
    [self.businessLocation setText:[NSString stringWithFormat:@"%@",model.merchantAddress?:@""]];
    
// 消费码
    [self.consumeNumLabel setText:[NSString stringWithFormat:@"消费码：%@",model.validCode?:@""]];
// 消费日期
    [self.consumeDate setText:[NSString stringWithFormat:@"消费时间：%@",model.validTime?:@""]];
    
    // 订单状态
    switch ([model.status integerValue])
    {
        case 0:
            self.statuslabel.text = @"已使用";
            break;
        case 1:
        {
            self.statuslabel.text = @"可使用";
            self.statuslabel.textColor = [UIColor colorWithHexString:@"02b293"];
            // 消费码 变色
            NSString *priceStr = [NSString stringWithFormat:@"消费码：%@",model.validCode?:@""];
            NSInteger len = priceStr.length;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"02b293"] range:NSMakeRange(4, len-4)];
            [self.consumeNumLabel setAttributedText:attrStr];
        }
            break;
        case 4:
            self.statuslabel.text = @"退款中";
            self.statuslabel.textColor = [UIColor colorWithHexString:@"ff7d25"];
            break;
        case 5:
            self.statuslabel.text = @"已退款";
            break;
            
        default:
            self.statuslabel.text = @"";
            break;
    }
    
    // 退款 取消按钮
    switch ([model.status integerValue])
    {
        case 1:
        {// 申请退款
            [self.statusbutton setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.statusbutton setTitleColor:[UIColor colorWithHexString:@"ff7d25"] forState:UIControlStateNormal];
            self.statusbutton.layer.borderColor = [UIColor colorWithHexString:@"ff7d25"].CGColor;
        }
            break;
        case 2:
        {// 未支付
            [self.statusbutton setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.statusbutton setTitleColor:[UIColor colorWithHexString:@"343434"] forState:UIControlStateNormal];
            self.statusbutton.layer.borderColor = [UIColor colorWithHexString:@"606060"].CGColor;
        }
            break;
        case 3:
        {// 已取消取消
            [self.statusbutton setTitle:@"已取消" forState:UIControlStateNormal];
            [self.statusbutton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
            self.statusbutton.layer.borderColor = [UIColor clearColor].CGColor;
            self.statusbutton.enabled = NO; // 不可点
        }
            break;
            
        default:
//            [self.statusbutton setTitle:@"" forState:UIControlStateNormal];
            break;
    }
    
    
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)sender
{
    NSInteger type = sender.tag;
    if(self.status == 1 && sender.tag == 1001)
    {//申请退款退款
        type = 1011;
    }
    if (self.block) {
        self.block(type); // 1000第一个view进入套餐详情 1001取消订单 1011退款 1002电话 1003地址
    }
}


@end
