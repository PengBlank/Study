//
//  TravelCodeViewController.m
//  Teshehui
//
//  Created by macmini5 on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelCodeViewController.h"
#import "UIColor+expanded.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "ZXingObjC.h"
#import "NSString+Addition.h"
#import "TravelOrderDetailRequest.h"
#import "DefineConfig.h"
#import "UIView+Common.h"
#import "TravelOrderDetailInfo.h"
#import "METoast.h"
#import "TravelOrderInfo.h"
#import "TravelTicketInfo.h"
#import "DefineConfig.h"
#import "TicketScreenshot.h" // 保存二维码
#import "UIColor+hexColor.h"
#import "TravelOrderCodeCell.h"
#define SectionHeaderViewHeight 50

@interface TravelCodeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton    *_saveButton;       // 保存按钮
    UIView      *_tableHeaderView;
    UIImageView *_codeImageView;    // 二维码图片
    UILabel     *_titleLabel;       // 标题
    UILabel     *_remindLabel;      // 提醒
    UILabel     *_priceLabel;       // 价格
    UILabel     *_dateUsedLabel;    // 使用日期
//    UILabel     *_dateUsedLabel2;   // 保存二维码时显示在sectionHeaderView上的日期
}
@property (nonatomic,strong) UITableView              *myTableView;
@property (nonatomic,strong) TravelOrderDetailRequest *orderDetailRequest;
@property (nonatomic,strong) TravelOrderDetailInfo    *travelOrderDetailInfo;

@end

@implementation TravelCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"旅游订单二维码";
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor colorWithHexColor:@"F1F1F1" alpha:1];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    _myTableView.tableHeaderView = [self createTableHeaderView];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveButton setFrame:CGRectMake(0, self.view.frame.size.height-49-64, self.view.frame.size.width, 49)];
    [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"0xb80000"]];
    [_saveButton setTintColor:[UIColor whiteColor]];
    [[_saveButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [_saveButton setTitle:@"保存订单二维码" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    [_saveButton setEnabled:NO];    // 按钮不能点击
    
    if (self.travelOrderType == PastTraveOrder) //历史订单
    {
        self.title = @"旅游历史订单";
        [_myTableView setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64)];
        [_saveButton setHidden:YES];
    }
    
    [self loadOrderDetailData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    CGFloat value = [UIScreen mainScreen].brightness;
//    // 设置系统屏幕的亮度值
//    [[UIScreen mainScreen] setBrightness:value + 0.2];
//    
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; //设置屏幕长亮
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    CGFloat value = [UIScreen mainScreen].brightness;
//    // 设置系统屏幕的亮度值
//    [[UIScreen mainScreen] setBrightness:value - 0.2];
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//关闭屏幕长亮
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

// 创建TableHeaderView
-(UIView *)createTableHeaderView
{
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 345)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];               // 标题
    [_titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor colorWithHexString:@"b80000"]];
    [_tableHeaderView addSubview:_titleLabel];
    
    _codeImageView = [[UIImageView alloc] init];        // 二维码图片
    [_tableHeaderView addSubview:_codeImageView];
    
    _remindLabel = [[UILabel alloc] init];              // 提醒
    [_remindLabel setFont:[UIFont systemFontOfSize:13]];
    [_remindLabel setTextAlignment:NSTextAlignmentCenter];
    [_remindLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [_tableHeaderView addSubview:_remindLabel];
    
    _priceLabel = [[UILabel alloc] init];               // 价格
    [_priceLabel setFont:[UIFont systemFontOfSize:17]];
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    [_priceLabel setTextColor:[UIColor colorWithHexString:@"b80000"]];
    [_tableHeaderView addSubview:_priceLabel];
    
    _dateUsedLabel = [[UILabel alloc] init];            // 日期
    [_dateUsedLabel setFont:[UIFont systemFontOfSize:13]];
    [_dateUsedLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateUsedLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
    [_tableHeaderView addSubview:_dateUsedLabel];
    
    [self makeConstraints];
    
    return _tableHeaderView;
}
// 添加约束
- (void)makeConstraints
{
    // 标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableHeaderView.mas_top).offset(25);
        make.centerX.mas_equalTo(_titleLabel.superview.mas_centerX);
    }];
    // 提醒
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(_titleLabel.superview.mas_centerX);
    }];
    // 二维码图片
    [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_remindLabel.mas_bottom).offset(-20);
        make.height.equalTo(@265);
        make.width.equalTo(@265);
        make.centerX.mas_equalTo(_titleLabel.superview.mas_centerX);
    }];
    // 价格
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_remindLabel.mas_bottom).offset(223);
        make.centerX.mas_equalTo(_titleLabel.superview.mas_centerX);
    }];
    // 日期
    [_dateUsedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(_titleLabel.superview.mas_centerX);
    }];
    
}

- (void)loadOrderDetailData{

    WS(weakSelf);
    if (kNetworkNotReachability) {
        
        DebugNSLog(@"网络异常");
        [_myTableView configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:[[NSError alloc] init] reloadButtonBlock:^(id sender) {
            [weakSelf loadOrderDetailData];
        }];
        return;
    }

    [HYLoadHubView show];
    self.orderDetailRequest = [[TravelOrderDetailRequest alloc] init];
    self.orderDetailRequest.interfaceURL       = [NSString stringWithFormat:@"%@/v3/travel/GetTravelOrderDetails",TRAVEL_API_URL];
    self.orderDetailRequest.interfaceType      = DotNET2;
    self.orderDetailRequest.postType           = JSON;
    self.orderDetailRequest.httpMethod         = @"POST";
    
    self.orderDetailRequest.orderId             = self.travelOrderInfo.tId;  //tid 标示订单ID
    [self.orderDetailRequest sendReuqest:^(id result, NSError *error)
     {
         
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 NSDictionary *tmpDic = objDic[@"data"];
                 
                [TravelOrderDetailInfo setupObjectClassInArray:^NSDictionary *{
                    return @{@"tickets":@"TravelTicketInfo"};
                }];
                 
                 weakSelf.travelOrderDetailInfo  = [TravelOrderDetailInfo objectWithKeyValues:tmpDic];
                 
                 [weakSelf refreshUI];  // 赋值
                 [weakSelf.myTableView reloadData];
                 [_saveButton setEnabled:YES];    // 请求成功保存按钮可点击
                 
             }else{
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"获取订单详情失败"];
             }
         }else{
             [METoast toastWithMessage:@"无法连接服务器"];
         }
         
         [HYLoadHubView dismiss];
     }];
}


#pragma mark - UI赋值
- (void)refreshUI
{
    _titleLabel.text = self.travelOrderInfo.touristName;
    _remindLabel.text = @"（请出示该二维码以供验票）";
    if (self.travelOrderType == PastTraveOrder) //历史订单
    {
        _remindLabel.text = @"（此二维码已失效）";
    }
    // 二维码图片
    [self creatQRCodeImage];
    // 价格
    CGFloat price = self.travelOrderInfo.price.floatValue;
    CGFloat coupon = self.travelOrderInfo.coupon.floatValue;
    if(price == 0 && coupon != 0){
        
        _priceLabel.text  = [NSString stringWithFormat:@"%@现金券",self.travelOrderInfo.price];
        
    }else if(price == 0 && coupon == 0){
        
    }else if (price != 0 && coupon == 0){
        
        _priceLabel.text  = [NSString stringWithFormat:@"￥%@",self.travelOrderInfo.price];
        
    }else{
        _priceLabel.text  = [NSString stringWithFormat:@"￥%@＋%@现金券",self.travelOrderInfo.price,self.travelOrderInfo.coupon];
    }
    _dateUsedLabel.text = [NSString stringWithFormat:@"票使用日期：%@",self.travelOrderInfo.useDate];
//    _dateUsedLabel2.text = [NSString stringWithFormat:@"票使用日期：%@",self.travelOrderInfo.useDate];  // 保存二维码时用的
}

#pragma mark - 创建二维码图片
- (void)creatQRCodeImage{
    
//    NSString *dataStr = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",self.travelOrderInfo.tId ,self.travelOrderInfo.merId];
    NSString *dataStr = [NSString stringWithFormat:@"id=%@",self.travelOrderInfo.tId];
    
    //base64
    dataStr = [dataStr base64EncodedString];
    
    if (dataStr)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:dataStr
                                      format:kBarcodeFormatQRCode
                                       width:515
                                      height:515
                                       error:nil];
        
        if (result)
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            
            _codeImageView.image = [UIImage imageWithCGImage:image.cgimage];
        } else {
            _codeImageView.image = nil;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"用户登录信息不完整，请重新登录"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重新登录", nil];
        [alert show];
    }
}

// 票信息
- (NSMutableAttributedString *)ticketsLabelTextString:(TravelTicketInfo *)ticketInfo
{
    NSInteger adult = ticketInfo.adultTickets.integerValue;
    NSInteger child = ticketInfo.childTickets.integerValue;
    
    
    NSMutableAttributedString *arrStr;
    
    // 成人票
    if (adult > 0) {
        NSString *adilt = [NSString stringWithFormat:@"%@张",@(adult)];
        arrStr = [[NSMutableAttributedString alloc]initWithString:@"成人票"
                                                         attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        // 设置红色
        NSAttributedString *aditCount = [[NSAttributedString alloc]initWithString:adilt
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"b80000"]}];
        [arrStr appendAttributedString:aditCount];
    }
    
    // 儿童票
    if (child > 0) {
        NSString *childCount = [NSString stringWithFormat:@"%@张",@(child)];
        NSAttributedString *attChild = [[NSAttributedString alloc]initWithString:@"+儿童票"
                                                                      attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        // 设置红色
        NSAttributedString *attChildCount = [[NSAttributedString alloc]initWithString:childCount
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"b80000"]}];
        if (arrStr) {
            [arrStr appendAttributedString:attChild];
        }else{
            arrStr = [[NSMutableAttributedString alloc]initWithString:@"儿童票"
                                                             attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        }
        [arrStr appendAttributedString:attChildCount];
    }
    return arrStr;
}

#pragma mark - UITableView代理方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *ticketArray = self.travelOrderDetailInfo.tickets;
    return ticketArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"cell";
    TravelOrderCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TravelOrderCodeCell alloc] initWithReuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexColor:@"F1F1F1" alpha:1];
        if (self.travelOrderType) // 0为可用订单 1为历史订单
        {
            cell.isHistory = YES;
        }
    }
    NSMutableArray *ticketArray = self.travelOrderDetailInfo.tickets;
    TravelTicketInfo *tmpInfo = [ticketArray objectAtIndex:indexPath.row];
    
    [cell bindData:tmpInfo];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 143.0f; //163
    NSMutableArray *ticketArray = self.travelOrderDetailInfo.tickets;
    TravelTicketInfo *tmpInfo = [ticketArray objectAtIndex:indexPath.row];
    NSArray *touristArr = tmpInfo.tourists; // 景点数组 touristName景点名
    NSMutableArray *touristNameArr = [NSMutableArray array]; // 保存景点名用
    for (NSDictionary *dic in touristArr) {
        [touristNameArr addObject:dic[@"touristName"]];
    }
    BOOL b = self.travelOrderType?YES:NO;
    return [TravelOrderCodeCell cellHeightWithTouristNameArr:touristNameArr IsHistory:self.travelOrderType?YES:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSMutableArray *ticketArray = self.travelOrderDetailInfo.tickets;
    if (ticketArray.count == 0) {
        return 0.0000001;
    }
    return SectionHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *ticketArray = self.travelOrderDetailInfo.tickets;
    if (ticketArray.count == 0) {
        return nil;
    }
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, SectionHeaderViewHeight)];
    [bgview setBackgroundColor:[UIColor colorWithHexColor:@"F1F1F1" alpha:1]];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    view.layer.borderColor = [UIColor colorWithHexColor:@"a7a7a7" alpha:1].CGColor;
    view.layer.borderWidth = .6f;
    [bgview addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.superview.mas_top);
        make.left.mas_equalTo(view.superview.mas_left).offset(-1);
        make.right.mas_equalTo(view.superview.mas_right).offset(1);
        make.bottom.mas_equalTo(view.superview.mas_bottom);
    }];
    
    UIImageView *markImage = [[UIImageView alloc] init];
    [markImage setImage: [UIImage imageNamed:@"ticketlist"]];
    [view addSubview: markImage];
    
    UILabel *title = [[UILabel alloc] init];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor colorWithHexString:@"343434"]];
    title.text = @"票信息";
    [view addSubview:title];

//    [view addSubview:_dateUsedLabel2];
    
    [markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(17, 15)); // 1.15 : 1
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(markImage.mas_right).offset(5);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    return bgview;
}

#pragma mark - 保存二维码按钮
- (void) buttonClick
{
//    NSString *dataStr = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",self.travelOrderInfo.tId ,self.travelOrderInfo.merId];
    NSString *dataStr = [NSString stringWithFormat:@"id=%@",self.travelOrderInfo.tId];

    NSString *touristName = self.travelOrderInfo.touristName;
    [[TicketScreenshot sharedConstant] setDataSource:self
                                            Delegate:self
                                         TicketTitle:touristName
                                             Payment:_priceLabel.text
                                             PayDate:_dateUsedLabel.text
                                              qrCode:dataStr
                                            callback:^(BOOL saveSuccess, NSError *error) {
                                                NSString *msg = nil ;
                                                if(error != NULL){
                                                    msg = @"保存失败" ;
                                                }else{
                                                    msg = @"已保存到系统相册" ;
                                                }
                                                [METoast toastWithMessage:msg];
                                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
