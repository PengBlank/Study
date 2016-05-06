//
//  TicketingViewController.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TicketingViewController.h"
#import "TicketingTableViewCell.h"
#import "PaymentConfirmViewController.h"
#import "TicketDateViewController.h"

#import "TravelSightRequest.h"
#import "TravelTicketsListModel.h"
#import "TYTicketCountModel.h"
#import "MJExtension.h"
#import "NSDate+Addition.h"
#import "METoast.h"
#import "UIImageView+WebCache.h"
#import "DefineConfig.h"
#import "ActionSheetStringPicker.h"
//#import "DHSmartScreenshot.h"
//#import "ALAssetsLibrary+CustomPhotoAlbum.h"
//#import "ZXingObjC.h"
//#import "NSString+Addition.h"


#define CSS_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString * const STATIC_CELLNIBNAME           = @"TicketingTableViewCell";
static NSString * const STATIC_DATENIBNAME           = @"TicketDateViewController";
static NSString * const STATIC_TICKETCELL_IDENTIFIER = @"ticketCell";

@interface TicketingViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    UILabel *_lblSelectedDate;
    TravelTicketsListModel *_ticketsModel;   //返回的景点门票信息
    NSMutableDictionary    *_dicCount;       //用来保存选中的门票数量（保存有成人票、儿童票数量）
    NSString               *_strSelectedDate;
    CGFloat _fTicketsAllPrice;
    CGRect _rctViewHead;
}

@property (weak, nonatomic) IBOutlet UIView      *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewBlur;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewLogo;
@property (weak, nonatomic) IBOutlet UILabel     *lblImageTitle;

@property (weak, nonatomic) IBOutlet UITableView *tbTicket;
@property (weak, nonatomic) IBOutlet UILabel     *lblAllPrice;
@property (weak, nonatomic) IBOutlet UILabel     *lblAllCoupon;

@end

@implementation TicketingViewController

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.0f, self.navigationItem.titleView.frame.size.width, 15.0f)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor     = CSS_ColorFromRGB(0x343434);
    title.font          = [UIFont systemFontOfSize:17.0f];
    title.text          = @"购票";
    
    UILabel *titleSub = [[UILabel alloc]initWithFrame:CGRectMake(-20.0f, 20.0f, self.navigationItem.titleView.frame.size.width+40.0f, 10.0f)];
    titleSub.textAlignment   = NSTextAlignmentCenter;
    titleSub.textColor       = CSS_ColorFromRGB(0x343434);
    titleSub.font            = [UIFont systemFontOfSize:11.0f];
    titleSub.text            = @"可预订7天内(含今日)门票";
    
    [self.navigationItem.titleView addSubview:title];
    [self.navigationItem.titleView addSubview:titleSub];
    
    //　去请求门票信息
    if (_strScenicId) {
        _dicCount = [NSMutableDictionary new];
        [self networkGetTicketsInfo];
    }
    
    // 设置footerview，一来隐藏没有数据的cell线，二来遮蔽透明层
    UIView *footer            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.0f)];
    footer.backgroundColor    = self.view.backgroundColor;
    _tbTicket.tableFooterView = footer;
    _tbTicket.scrollsToTop    = YES;
    _rctViewHead              = _viewHeader.frame;
    _lblImageTitle.hidden     = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击事件
//　点击确定支付按钮
- (IBAction)btnConfirmBuyTicketClick:(id)sender {
    
    if (_strSelectedDate.length == 0) {
        [METoast toastWithMessage:@"请选择票使用日期"];
        [self.tbTicket setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    if (_fTicketsAllPrice == 0) {
        [METoast toastWithMessage:@"请选择票"];
        return;
    }
    
    PaymentConfirmViewController *paymentcontroller = [[PaymentConfirmViewController alloc]initWithNibName:@"PaymentConfirmViewController" bundle:nil];
    paymentcontroller.ticketsModel      = _ticketsModel;
    paymentcontroller.dicTicketSelected = _dicCount;
    paymentcontroller.strAllPrice       = _lblAllPrice.text;
    paymentcontroller.strAllCoupon      = _lblAllCoupon.text;
    paymentcontroller.strSeletedDate    = _strSelectedDate;
    [self.navigationController pushViewController:paymentcontroller animated:YES];
    
}

#pragma mark ---  此处修改不用日历控件。
//将日历添加到最外层controller
- (void) btnSectionSelectDateClick{
    if (_ticketsModel) {
        
//        TicketDateViewController *dateController = [[TicketDateViewController alloc]initWithNibName:STATIC_DATENIBNAME bundle:nil];
//        dateController.serverDate = _ticketsModel.serverDate;
//        if (_strSelectedDate) {
//            dateController.selectedDate = _strSelectedDate;
//        }
//        
//        // 日历页面回调
//        TicketingViewController * __weak weakSelf = self;
//        [dateController setTicketDateSelected:^(NSString *date) {
//            [weakSelf setSelectedTicketDate:date];
//        }];
//        
//        dateController.view.frame = self.view.window.rootViewController.view.frame;
//        
//        [self.view.window.rootViewController addChildViewController:dateController];
//        [self.view.window.rootViewController.view addSubview:dateController.view];
//        [dateController didMoveToParentViewController:self.view.window.rootViewController];

        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 * i sinceDate:[NSDate date]];//计算后六天
            NSString *dateString = [nextDate toStringWithFormat:@"yyyy-MM-dd"];
            NSInteger weeek = [nextDate getWeekday];
            NSString *weekNum = [self arabicNumeralsToChinese:weeek];
            [arr addObject:[NSString stringWithFormat:@"%@  星期%@",dateString,weekNum]];
        }
        
       
        WS(weakSelf);
        [ActionSheetStringPicker showPickerWithTitle:nil rows:@[arr] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray * selectedIndex, NSArray *selectedValue) {
            
             [weakSelf setSelectedTicketDate:[selectedValue firstObject]];
            
        } cancelBlock:nil origin:self.view];
    }
    
}

-(NSString *)arabicNumeralsToChinese:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"日";
            break;
        case 2:
            return @"一";
            break;
        case 3:
            return @"二";
            break;
        case 4:
            return @"三";
            break;
        case 5:
            return @"四";
            break;
        case 6:
            return @"五";
            break;
        default:
            return @"六";
            break;
    }
}


#pragma mark - 网络请求
- (void)networkGetTicketsInfo{
    
    [HYLoadHubView show];
    
    TravelSightRequest * _travelRequest = [[TravelSightRequest alloc] init];

    _travelRequest.interfaceURL       = [NSString stringWithFormat:@"%@/v2/travel/GetTickets",TRAVEL_API_URL];
    _travelRequest.interfaceType        = DotNET2;
    _travelRequest.postType             = JSON;
    _travelRequest.httpMethod           = @"POST";
    _travelRequest.sId                  = _strScenicId ? : @"";//  景点id
    _travelRequest.type                 = _strTicketType ? : @"";
    
    TicketingViewController * __weak weakSelf = self;
    [_travelRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败

                 TravelTicketsListModel *tModel = [TravelTicketsListModel objectWithKeyValues:objDic[@"data"]];
                 
                 [weakSelf setSelfDataSource:tModel];
                 [HYLoadHubView dismiss];
                 
             }else{
                 
                 [HYLoadHubView dismiss];
                 NSString *msg = objDic[@"msg"];
                 [weakSelf addNoDataViewWithMsg:msg];
             }
         }else{
             [HYLoadHubView dismiss];
             [weakSelf addNoDataViewWithMsg:@"无法连接服务器"];
         }
     }];
}
#pragma mark - 内部方法
// 添加获取信息失败时展示页面
- (void) addNoDataViewWithMsg:(NSString *)msg {
    
    // 背景视图
    UIView *nodata         = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    nodata.backgroundColor = [UIColor whiteColor];
    
    // 图片
    UIImageView *imgNodata = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noscenicspot"]];
    imgNodata.center       = CGPointMake(nodata.center.x, nodata.center.y - 100.0f);
    [nodata addSubview:imgNodata];
    
    // 提示语
    CGRect rct        = CGRectMake(0, CGRectGetMaxY(imgNodata.frame), CGRectGetWidth(nodata.frame), 50.0f);
    UILabel *lbl      = [[UILabel alloc]initWithFrame:rct];
    lbl.textColor     = CSS_ColorFromRGB(0xA5A5A5);
    lbl.font          = [UIFont systemFontOfSize:14.0f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text          = msg.length !=0  ? msg : @"获取景点信息失败";
    [nodata addSubview:lbl];
    [self.view addSubview:nodata];
}

// 设置这个页面的数据显示
- (void) setSelfDataSource:(TravelTicketsListModel *)tModel {
    
    _ticketsModel         = tModel;
    _lblImageTitle.text   = tModel.touristName;
    _lblImageTitle.hidden = NO;
    
    [self setLogoImageViewImage:tModel.merchantLogo];
    
    self.tbTicket.tableFooterView = [UIView new];
    [self.tbTicket reloadData];
    
}

//　设置顶部图片
- (void) setLogoImageViewImage:(NSString *)url {
    WS(weakSelf);
    if (url) {
        [self.imageviewLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         [weakSelf setLogoImageViewBlurWithImage:image];
                                     }];
    }
}
//　设置顶部图片背部的模糊效果
- (void) setLogoImageViewBlurWithImage:(UIImage *)image {
    //　为了兼容iOS7使用了下面的方法进行模糊，iOS8之后有专门的方法模糊
    self.imgviewBlur.image = [self blurImage:image];
}

- (UIImage*) blurImage :(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
                                               objCType:@encode(CGAffineTransform)]
                         forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    // setting up Gaussian Blur (could use one of many filters offered by Core Image)
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
    [blurFilter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
}

// cell　增减器 callback
- (void) setTicketCountDictionaryWithAdultCount:(float)adult ChildCount:(float)child indexPath:(NSIndexPath *)indexPath {
    
    // 增减票的时候设置边框红色
    [self.tbTicket selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    // 将最新的门票数据保存到字典中，绑定cell用
    TYTicketCountModel *tModel = [[TYTicketCountModel alloc]init];
    tModel.countAdilt          = adult;
    tModel.countChild          = child;
    NSString *key              = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    [_dicCount setObject:tModel forKey:key];
    
    //　计算总价及现金券
    CGFloat __block fPrice  = .0f;
    CGFloat __block fCoupon = .0f;
    [_dicCount enumerateKeysAndObjectsUsingBlock:^(id key, TYTicketCountModel *tModel, BOOL *stop) {
        TravelSightInfo *tInfo = _ticketsModel.tickets[[key integerValue]];
        CGFloat price  = ([tInfo.tshAdultPrice floatValue] * tModel.countAdilt) + ([tInfo.tshChildPrice floatValue] * tModel.countChild);
        CGFloat coupon = ([tInfo.tshAdultCoupon floatValue] * tModel.countAdilt) + ([tInfo.tshChildCoupon floatValue] * tModel.countChild);
        fPrice  += price;
        fCoupon += coupon;
    }];
    
    _fTicketsAllPrice      = fPrice;
    self.lblAllPrice.text  = [NSString stringWithFormat:@"￥%.2f",fPrice];
    self.lblAllCoupon.text = [NSString stringWithFormat:@"%@",@(fCoupon)];
}

// 选中日期后设置票选择日期
- (void) setSelectedTicketDate:(NSString *)date {
    
    if (date.length > 10) {
        date = [date substringWithRange:NSMakeRange(0, 10)];
        _strSelectedDate      = date;
        _lblSelectedDate.text = [NSString stringWithFormat:@"票使用日期：%@", _strSelectedDate];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ticketsModel.tickets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _ticketsModel.tickets.count)
        return 170.0f;
    return 160.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell;
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:STATIC_CELLNIBNAME owner:self options:nil];
        cell = [nib objectAtIndex:1];
        //　添加点击事件
        UIButton *btn = [cell viewWithTag:105];
        [btn addTarget:self action:@selector(btnSectionSelectDateClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [cell viewWithTag:106];
        line.hidden = NO;
    }
    _lblSelectedDate = [cell viewWithTag:103];
    return cell.contentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TicketingTableViewCell *cell = (TicketingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:STATIC_TICKETCELL_IDENTIFIER];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:STATIC_CELLNIBNAME owner:self options:nil];
        cell         = [nib objectAtIndex:0];
    }
    //　绑定数据
    TravelSightInfo *tInfo = _ticketsModel.tickets[indexPath.row];
    [cell configureCell:tInfo TicketCount:_dicCount atIndexPath:indexPath];
    //　call back
    TicketingViewController * __weak weakSelf = self;
    cell.stepperChanged = ^(float countAdult , float countChild , NSIndexPath *indexPath){
        [weakSelf setTicketCountDictionaryWithAdultCount:countAdult ChildCount:countChild indexPath:indexPath];
    };
    return cell;
    
}

#pragma mark - scrollviewdelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGRect rctNew = _rctViewHead;
        
        if (scrollView.contentOffset.y <= 0) {
            
            rctNew.origin.y -= scrollView.contentOffset.y;
            
        }else{
            
            rctNew.origin.y -= fabs( scrollView.contentOffset.y ) * .5f;
            
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [weakSelf.viewHeader setFrame:rctNew];
        });
    });
}

@end
