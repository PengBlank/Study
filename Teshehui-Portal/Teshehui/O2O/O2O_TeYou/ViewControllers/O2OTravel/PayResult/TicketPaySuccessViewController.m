//
//  TicketPaySuccessViewController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TicketPaySuccessViewController.h"
#import "TicketPaySuccessTableViewCell.h"
#import "TYTicketCountModel.h"

#import "ZXingObjC.h"
#import "NSString+Addition.h"
#import "TicketScreenshot.h"
#import "METoast.h"
#import "MJExtension.h"

#import "UMSocial.h"
#import "CheckPayStatusRequest.h"
#import "DefineConfig.h"
#import "HYShareInfoReq.h"
#import "HYUserInfo.h"
#import "O2OShareInfoRequest.h"


#import "UIColor+hexColor.h"
#import "ShareButtonView.h"
#import "TravelOrderCodeCell.h"

static NSString * const STATIC_PAYSUCCESSCELLNIBNAME = @"TicketPaySuccessTableViewCell";
static NSString * const STATIC_PAYSUCCESSCELL_IDENTIFIER = @"ticketPaySuccessCell";

@interface TicketPaySuccessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CheckPayStatusRequest   *_checkOrderStatusRq;
    ShareButtonView         *_sbView;       // 分享按钮的view
}
@property (nonatomic, strong) NSTimer            *O2ORunTimer;
@property (weak, nonatomic  ) IBOutlet UILabel            *lblPayResult;
@property (weak, nonatomic  ) IBOutlet UILabel            *lblPaydate;
@property (weak, nonatomic  ) IBOutlet UIButton           *btnSavePrice;// 节省金额
@property (weak, nonatomic  ) IBOutlet UILabel            *lblPaymentPrice;
@property (weak, nonatomic  ) IBOutlet UIImageView        *imgQR;
@property (weak, nonatomic  ) IBOutlet UILabel            *lblScenicName;
@property (weak, nonatomic  ) IBOutlet UILabel            *lblTicketDate;
@property (weak, nonatomic  ) IBOutlet UITableView        *tbTickets;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *layoutButtonHeitht;// 控制节省金额显示隐藏的（原价的时候隐藏）

@property (weak, nonatomic  ) IBOutlet UIView             *viewHeader;

@property (weak, nonatomic  ) IBOutlet UIView             *viewQR;// 二维码

@property (weak, nonatomic  ) IBOutlet UIView             *viewFooter;
@property (weak, nonatomic  ) IBOutlet UIView             *viewTicketingFailure;
@property (weak, nonatomic  ) IBOutlet UIButton           *btnSaveQR;

@end

@implementation TicketPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"付款结果";
    
    if (_orderModel.tickets.count > 0) {
        
        _viewTicketingFailure.hidden = YES;
        
    }else{
        //////////*********** 这里后来又不用了，没有出票失败的情况了 **********//////////////
        // 设置footerview的高度，基本上是减去二维码的高度
        CGRect headerRect      = _viewHeader.frame;
        headerRect.size.height = 180.0f;
        _viewHeader.frame      = headerRect;
        
        // 设置footerview的高度，基本上是减去付款成功的高度和保存二维码的高度
        CGRect footerRect      = _viewFooter.frame;
        footerRect.size.height = [[UIScreen mainScreen] bounds].size.height - 180.0f - 50.0f - self.navigationController.navigationBar.frame.size.height - 20.0f;
        _viewFooter.frame      = footerRect;
        [_btnSavePrice setTitle:@"重新购票" forState:UIControlStateNormal];
        //////////*********** 这里后来又不用了，没有出票失败的情况了 **********//////////////
    }
    
    // 付款时间暂时显示系统时间
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    dateFormat.dateFormat       = @"yyyy-MM-dd HH:mm:ss";  //用大写的H 竟然不用加8小时？？
    NSString *date              = [dateFormat stringFromDate:[NSDate date]];
    _lblPaydate.text            = date;
    
    NSString *price = [_strAllPrice stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    
    if (price.floatValue != 0) { //当有支付有现金的时候才轮询订单;
        [self runLoopOrderStatus];
    }else{
        [self stopRunTimerSetPayResultViewShow:nil];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    CGFloat value = [UIScreen mainScreen].brightness;
//    // 设置系统屏幕的亮度值
//    [[UIScreen mainScreen] setBrightness:value + 0.2];
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; //设置屏幕长亮
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.O2ORunTimer invalidate];
    self.O2ORunTimer = nil;
//    CGFloat value = [UIScreen mainScreen].brightness;
//    // 设置系统屏幕的亮度值
//    [[UIScreen mainScreen] setBrightness:value - 0.2];
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//关闭屏幕长亮
}

- (void)dealloc{
    [HYLoadHubView dismiss];
    
    [_checkOrderStatusRq cancel];
    _checkOrderStatusRq = nil;
    
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


// 点击返回的时候，直接回到rootview
- (void) backToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 检查O2O商家付款状态
- (void)runLoopOrderStatus{
    
    //    //循环检查订单状态
    [HYLoadHubView show];
    self.O2ORunTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self
                                                      selector:@selector(checkO2OOrderStatus)
                                                      userInfo:nil repeats:YES];
    [self.O2ORunTimer fire];
}

- (void)checkO2OOrderStatus{
    
    _checkOrderStatusRq = [[CheckPayStatusRequest alloc] init];
    _checkOrderStatusRq.interfaceURL  = [NSString stringWithFormat:@"%@/OrderCommon/GetOrderStatus",ORDER_API_URL];
    _checkOrderStatusRq.interfaceType = DotNET;
    _checkOrderStatusRq.httpMethod    = @"POST";
    
    _checkOrderStatusRq.OrderNo       = self.O2O_OrderNo;
    _checkOrderStatusRq.Type          = @"1";
    
    WS(weakSelf);
    [_checkOrderStatusRq sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             if ([objDic[@"Result"] integerValue] == 1) { //状态值为1 代表已付款成功
                 
                 [HYLoadHubView dismiss];
                 [weakSelf stopRunTimerSetPayResultViewShow:objDic[@"Remark"]];
                 
             }
         }
     }];
}

- (void) stopRunTimerSetPayResultViewShow:(NSString *)result {
    if ([_O2ORunTimer isValid]) {
        [self.O2ORunTimer invalidate];
        self.O2ORunTimer = nil;
    }
    self.lblPayResult.text = result ? : @"付款成功";
    self.viewQR.hidden     = NO;
    self.viewFooter.hidden = NO;
    self.btnSaveQR.hidden  = NO;
    self.tbTickets.scrollEnabled = YES;
    [self creatQRCodeImage];
    [self showTicketsInfo];
    [_tbTickets reloadData];
}

// 创建二维码
- (void)creatQRCodeImage{
    
    if (_orderModel) {
        
        //  NSString *qrInfo = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",_orderModel.tId ,_orderModel.merId];
        NSString *qrInfo = [NSString stringWithFormat:@"id=%@",_orderModel.tId]; //修改二维码规则之后的修改
        
        //base64
        qrInfo               = [qrInfo base64EncodedString];
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.margin         = @1;
        
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result         = [writer encode:qrInfo
                                              format:kBarcodeFormatQRCode
                                               width:_imgQR.frame.size.width
                                              height:_imgQR.frame.size.height
                                               hints:hints
                                               error:nil];
        ZXImage *image = [ZXImage imageWithMatrix:result];
        _imgQR.image   = [UIImage imageWithCGImage:image.cgimage];
    }
    
}

//　显示其他信息
- (void) showTicketsInfo {
    
    // 节省金额
    if (_strSavePrce) {
        [_btnSavePrice setTitle:_strSavePrce forState:UIControlStateNormal];
    }else{
        _layoutButtonHeitht.constant = .0f; // 原价的时候隐藏节省金额
        [_btnSavePrice setTitle:@"" forState:UIControlStateNormal];
    }
    
    // 其它
    _lblPaymentPrice.text = [@"成功付款 " stringByAppendingString: _strPaymentPrice];
    _lblScenicName.text   = _strScenicName;
    _lblTicketDate.text   = [NSString stringWithFormat:@"票使用日期:%@",_strTicketDate];
    
}
- (IBAction)btnSaveQRImageClick:(id)sender {
    
    // 出票成功的时候，保存二维码
    if (_orderModel.tickets.count > 0) {
        
        if (_orderModel) {
//            NSString *qrInfo = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",_orderModel.tId ,_orderModel.merId];
            NSString *qrInfo = [NSString stringWithFormat:@"id=%@",_orderModel.tId]; //修改二维码规则之后的修改
            [[TicketScreenshot sharedConstant] setDataSource:self
                                                    Delegate:self
                                                 TicketTitle:_strScenicName
                                                     Payment:_strPaymentPrice
                                                     PayDate:_lblTicketDate.text
                                                      qrCode:qrInfo
                                                    callback:^(BOOL saveSuccess, NSError *error) {
                                                        if (saveSuccess) {
                                                            [METoast toastWithMessage:@"已保存到系统相册"];
                                                        }else{
                                                            [METoast toastWithMessage:@"保存失败"];
                                                        }
                                                    }];
        }
        
    }else{
        
        //　重新购票 // 后来又说不会有出票失败的情况，所以不做了
        // FIXME:
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewQR.hidden == YES)  // 付款未成功的时候，不显示门票
        return 0;
    return _orderModel.tickets.count + 1;
}

// 解决cell线不靠边的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets cellInsets = UIEdgeInsetsZero;
    if (indexPath.row != 0) 
        cellInsets = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:cellInsets];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [cell setPreservesSuperviewLayoutMargins:NO];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:cellInsets];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50.0f;
    }
    NSDictionary *dic = _orderModel.tickets[indexPath.row-1];
    TravelTicketInfo *tmpInfo = [TravelTicketInfo objectWithKeyValues:dic];
    NSArray *touristArr = [tmpInfo.tourists copy]; // 景点数组 touristName景点名
    NSMutableArray *touristNameArr = [NSMutableArray array]; // 保存景点名用
    for (NSDictionary *dic in touristArr) {
        [touristNameArr addObject:dic[@"touristName"]];
    }
    CGFloat height = [TravelOrderCodeCell cellHeightWithTouristNameArr:touristNameArr IsHistory:NO];
    if ((indexPath.row == 1) || (indexPath.row == _arrCountSelected.count))// 第二行或者最后一行的时候，间隔比较多
        return height + 7.0f-7.0f;
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 第一行cell代替section header view
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TicketingTableViewCell" owner:self options:nil];
            cell         = [nib objectAtIndex:1];
        }
        
        UILabel *lblTitle     = [cell viewWithTag:102];
        UILabel *lblDate      = [cell viewWithTag:103];
        UIImageView *imgRigth = [cell viewWithTag:104];
        lblTitle.text         = @"票信息";
        imgRigth.hidden       = YES;
        lblDate.hidden        = YES;
        
//        if (tableView == _tbTickets) {
//            lblDate.hidden = YES;
//        }else{
//            lblDate.text   = [NSString stringWithFormat:@"票使用日期:%@",_strTicketDate];
//            lblDate.hidden = NO;
//        }
        return cell;
    }else{
        
        static NSString *cellId = @"cell";
        TravelOrderCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[TravelOrderCodeCell alloc] initWithReuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithHexColor:@"F1F1F1" alpha:1];
            cell.isHistory = NO;
        }
        NSDictionary *dic = _orderModel.tickets[indexPath.row-1];
        TravelTicketInfo *tmpInfo = [TravelTicketInfo objectWithKeyValues:dic];
        [cell bindData:tmpInfo];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _tbTickets) {
        return 130.0f;
    }
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _sbView = [[ShareButtonView alloc] initWithPaySuccessViewController:self
                                                                  MerId:self.orderModel.merId
                                                           AndSavePrice:self.strSavePrce
                                                     AndBackgroundColor:[UIColor colorWithHexColor:@"F1F1F1" alpha:1]];
    return _sbView;
}

@end
