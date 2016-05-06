//
//  HYCallTaxiViewController.m
//  Teshehui
//
//  Created by Kris on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYCallTaxiViewController.h"
#import "HYTaxiDestinationCell.h"
#import "HYLocationManager.h"
#import "HYCheckDidiOrderRequest.h"
#import "HYCheckDidiOrderResponse.h"
#import "HYTaxiGetCityRuleRequest.h"
#import "HYTaxiGetCityRuleResponse.h"
#import "HYTaxiSuggestAddressRequest.h"
#import "HYTaxiSuggestAddressResponse.h"
#import "HYTaxiSuggestAddress.h"
#import "HYTaxiRule.h"
#import "HYTaxiEstimatedFeeRequest.h"
#import "HYTaxiEstimatedFeeResponse.h"
#import "HYTaxiAlertView.h"
#import "HYTaxiAddOrderParam.h"
#import "HYTaxiEstimatedFeeViewController.h"
#import "HYTaxiOrderListViewController.h"
#import "HYTaxiProcessViewController.h"
#import "HYTabbarViewController.h"
#import "METoast.h"

//获取联想信息的完成回调
typedef void(^GetSuggestedInfoCompletionHandler)(void);

@interface HYCallTaxiViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate>
{
    NSString *_addressInfo;
    
    //起点和终点
    NSString *_startPoint;
    NSString *_endDestination;
    
    //选择的起点和终点
    NSString *_startPointFromInputView;
    NSString *_endDestinationFromInputView;

    HYCheckDidiOrderRequest *_checkDidiOrderRequest;
    HYTaxiGetCityRuleRequest *_getCityRuleRequest;
    HYTaxiSuggestAddressRequest *_getSuggestAddressRequest;
    HYTaxiEstimatedFeeRequest *_getEstimatedFeeRequest;
    
    NSString *_cityName;
    
    BOOL _showProCarSecView;
    
    CGRect _originFrameOfSecView;
    
    //校验输入框的完整性
    BOOL _startOk;
    BOOL _endOk;
    
    //选择车型
    UIButton *_tmpBtn;
    BOOL _secondBtnIsSeleted;
    NSInteger _taxiType;
    
    //预估价格
    HYLocateResultInfo *_addressDetailFromGPS;
    HYTaxiSuggestAddress *_suggestInfoFromStart;
    HYTaxiSuggestAddress *_suggestInfoFromEnd;
    NSString *_cityCode;
    NSString *_carTypeCode;
    NSString *_ruleCode;
    NSString *_ruleName;
    NSString *_estimatedFee;
    HYTaxiFeeModel *_estimatedTaxiFeeModel;
    BOOL _canCallTaxi;
    
    //定位
    BOOL _didReceiveLocationInfo;
    
    //记录tableview的偏移量
    CGPoint _center;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (copy, nonatomic) NSArray *proCars;
@property (copy, nonatomic) GetSuggestedInfoCompletionHandler completion;
@property (strong, nonatomic) UITableView *inputHistoryTableViewOfStart;
@property (strong, nonatomic) UITableView *inputHistoryTableViewOfEnd;
@property (strong, nonatomic) UITableView *inputIllusionTableViewOfStart;
@property (strong, nonatomic) UITableView *inputIllusionTableViewOfEnd;
@property (strong, nonatomic) UIView *inputIllusionNullViewOfStart;
@property (strong, nonatomic) UIView *inputIllusionNullViewOfEnd;
@property (strong, nonatomic) NSMutableArray *inputHistoryForStart;
@property (strong, nonatomic) NSMutableArray *inputHistoryForEnd;
@property (strong, nonatomic) NSMutableArray *inputIllusionForStart;
@property (strong, nonatomic) NSMutableArray *inputIllusionForEnd;
@property (strong, nonatomic) NSMutableArray *carTypeDataList;
@property (strong, nonatomic) NSMutableArray *carFeeDataList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *fastCar;
@property (weak, nonatomic) IBOutlet UIButton *proCar;
@property (strong, nonatomic) UIButton *callTaxiBtn;
@property (weak, nonatomic) IBOutlet UILabel *fastCarLab;
@property (weak, nonatomic) IBOutlet UILabel *proCarLab;
@property (weak, nonatomic) IBOutlet UIView *proCarSecView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *chenwtSBView;

- (void)goToCallTaxi:(id)sender;
- (IBAction)clickFastCarBtn:(id)sender;
- (IBAction)clickProCarBtn:(id)sender;


@end

@implementation HYCallTaxiViewController

-(void)dealloc
{
    [_checkDidiOrderRequest cancel];
    [_getCityRuleRequest cancel];
    [_getSuggestAddressRequest cancel];
    [_getEstimatedFeeRequest cancel];
    
    //移除观察者
    [_fastCar removeObserver:self forKeyPath:@"selected"];
    [_proCar removeObserver:self forKeyPath:@"selected"];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"打车";

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0
                                                green:242.0/255.0
                                                 blue:243.0/255.0
                                                alpha:1.0];
    
//    _chenwtSBView.frame = CGRectMake(0, 20, TFScalePoint(320), 455);
//    _proCarSecView.frame = CGRectMake(0, 0, TFScalePoint(320), 40);
//    _baseView.frame = CGRectMake(22, 80, 277, 370);
//    _chenwtSBView.frame = CGRectMake(0, 20, TFScalePoint(320), 455);
    
    _tableView.layer.cornerRadius = 10;
    _tableView.layer.borderColor = [UIColor colorWithWhite:.93 alpha:1.0].CGColor;
    _tableView.layer.borderWidth = 2;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //foooter
    _callTaxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_callTaxiBtn addTarget:self action:@selector(goToCallTaxi:) forControlEvents:UIControlEventTouchUpInside];
    _callTaxiBtn.frame = CGRectMake(TFScalePoint(10), 20, TFScalePoint(255), 40);
    [_callTaxiBtn setBackgroundImage:[[UIImage imageNamed:@"btn_car_active"]stretchableImageWithLeftCapWidth:5 topCapHeight:10]forState:UIControlStateNormal];
    [_callTaxiBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    [_callTaxiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFScalePoint(277), 50)];
    [container addSubview:_callTaxiBtn];
    _tableView.tableFooterView = container;
    
    [_tableView registerClass:[HYTaxiDestinationCell class]
       forCellReuseIdentifier:@"StartPoint"];
    [_tableView registerClass:[HYTaxiDestinationCell class]
       forCellReuseIdentifier:@"EndPoint"];

    //用于展示输入历史的tableview
    //起点历史
    CGRect frame = _tableView.frame;
    frame.origin.y += 48;
    frame.size.width = TFScalePoint(277);

    _center = CGPointMake(TFScalePoint(160), 250);
    _inputHistoryTableViewOfStart = [[UITableView alloc]initWithFrame:frame
                                                         style:UITableViewStylePlain];
    _inputHistoryTableViewOfStart.delegate = self;
    _inputHistoryTableViewOfStart.dataSource = self;
    _inputHistoryTableViewOfStart.hidden = YES;
    [_inputHistoryTableViewOfStart registerClass:[HYTaxiDestinationCell class]
       forCellReuseIdentifier:@"InputHistoryForStartCell"];
    [_baseView addSubview:_inputHistoryTableViewOfStart];
    
    //起点联想
    _inputIllusionTableViewOfStart = [[UITableView alloc]initWithFrame:frame
                                                                style:UITableViewStylePlain];
    _inputIllusionTableViewOfStart.delegate = self;
    _inputIllusionTableViewOfStart.dataSource = self;
    _inputIllusionTableViewOfStart.hidden = YES;
    [_inputIllusionTableViewOfStart registerClass:[HYTaxiDestinationCell class]
                          forCellReuseIdentifier:@"InputIllusionForStartCell"];
    [_baseView addSubview:_inputIllusionTableViewOfStart];
    
    _inputIllusionNullViewOfStart = [[UIView alloc]initWithFrame:frame];
    _inputIllusionNullViewOfStart.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
    label1.text = @"暂无搜索记录";
    [_inputIllusionNullViewOfStart addSubview:label1];
    _inputIllusionNullViewOfStart.hidden = YES;
    [_baseView addSubview:_inputIllusionNullViewOfStart];
    
    //终点历史
    frame.origin.y += 48;
    _inputHistoryTableViewOfEnd = [[UITableView alloc]initWithFrame:frame
                                                                style:UITableViewStylePlain];
    _inputHistoryTableViewOfEnd.delegate = self;
    _inputHistoryTableViewOfEnd.dataSource = self;
    _inputHistoryTableViewOfEnd.hidden = YES;
    [_inputHistoryTableViewOfEnd registerClass:[HYTaxiDestinationCell class]
                          forCellReuseIdentifier:@"InputHistoryForEndCell"];
    [_baseView addSubview:_inputHistoryTableViewOfEnd];
    
    //终点联想
    _inputIllusionTableViewOfEnd = [[UITableView alloc]initWithFrame:frame
                                                              style:UITableViewStylePlain];
    _inputIllusionTableViewOfEnd.delegate = self;
    _inputIllusionTableViewOfEnd.dataSource = self;
    _inputIllusionTableViewOfEnd.hidden = YES;
    [_inputIllusionTableViewOfEnd registerClass:[HYTaxiDestinationCell class]
                        forCellReuseIdentifier:@"InputIllusionForEndCell"];
    [_baseView addSubview:_inputIllusionTableViewOfEnd];
    
    _inputIllusionNullViewOfEnd = [[UIView alloc]initWithFrame:frame];
    _inputIllusionNullViewOfEnd.backgroundColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
    label2.text = @"暂无搜索记录";
    [_inputIllusionNullViewOfEnd addSubview:label2];
    _inputIllusionNullViewOfEnd.hidden = YES;
    [_baseView addSubview:_inputIllusionNullViewOfEnd];
    
    [_fastCar setImage:[UIImage imageNamed:@"car_kuaiche"] forState:UIControlStateNormal];
    [_fastCar addObserver:self forKeyPath:@"selected"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [_proCar setImage:[UIImage imageNamed:@"car_zhuanche"] forState:UIControlStateNormal];
    [_proCar addObserver:self forKeyPath:@"selected"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    _proCar.tag = 1;
    
    UIImage *img = [[UIImage imageNamed:@"btn_car_active"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    [_callTaxiBtn setBackgroundImage:img forState:UIControlStateNormal];
    _callTaxiBtn.enabled = NO;
   
//    //检查订单
    [self checkDidiOrder];

//    //默认选择快车
    _fastCar.selected = YES;
    _ruleCode = [NSString stringWithFormat:@"%lu",(unsigned long)FastCar];
    _ruleName = @"快车";
    
    _carTypeCode = [NSString stringWithFormat:@"%lu",(unsigned long)NormalFastCar];
    _taxiType = 1;
    
    //app设置完定位时候重新定位
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
   
    }
    return self;
}

#pragma mark observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_fastCar == object)
    {
        _fastCarLab.textColor = (_fastCar.selected) ? [UIColor redColor] : [UIColor blackColor];
    }
    else if(_proCar == object)
    {
        _proCarLab.textColor = (_proCar.selected) ? [UIColor redColor] : [UIColor blackColor];
    }
    else if (_tableView == object)
    {

    }
}

#pragma mark private methods
- (void)changeBaseFrame
{
    [self restoreBaseFrame];
    CGPoint center = _baseView.center;
    center.y -= 10;
    _baseView.center = center;
}

- (void)restoreBaseFrame
{
    _baseView.center = _center;
}

- (void)refreshAllSeletedStatus
{
    _canCallTaxi = (_fastCar.isSelected || (_proCar.isSelected && _secondBtnIsSeleted)) && _startOk && _endOk;
    
    _callTaxiBtn.enabled = _canCallTaxi;
    
    if (_canCallTaxi)
    {
        [self calculateEstimatedPrice];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (void)checkDidiOrder
{
    //检查订单
    if (!_checkDidiOrderRequest)
    {
        _checkDidiOrderRequest = [[HYCheckDidiOrderRequest alloc]init];
    }
    [_checkDidiOrderRequest cancel];
    __weak typeof(self) weakSelf = self;
    [_checkDidiOrderRequest sendReuqest:^(HYCheckDidiOrderResponse *result, NSError *error) {
        /*返回当status为200表示有权限，不为200时有值，code表示具体错误的编码，29922001表示用户是违规操作的用户无权限访问滴滴打车，29922002表示用户有未完成的订单，用户点击进入需要调用滴滴订单列表接口。
         */
        if (!(200 == result.status))
        {
            switch (result.code)
            {
                    //无权限
                case 29922001:
                {
                    HYTaxiAlertView *alert = [HYTaxiAlertView instanceView];
                    alert.mainTitleLabel.text = @"您有多次违规取消订单操作，打车业务已被暂停使用";
                    alert.mainImgView.image = [UIImage imageNamed:@"taxi_blackList"];
                    //联系客服
                    [alert.firstBtn setTitle:@"联系客服" forState:UIControlStateNormal];
                    [alert.secondBtn setTitle:@"知道了" forState:UIControlStateNormal];
                    alert.firstBlock = ^{
                        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"特奢汇客服竭诚为您服务"
                                                                            delegate:weakSelf
                                                                   cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                              destructiveButtonTitle:@"拨打电话 400-806-6528"
                                                                   otherButtonTitles:nil];
                        [action showInView:weakSelf.view];
                    };
                    //知道了
                    alert.secondBlock = ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    };
                    [alert show];
                }
                    break;
                    //有未完成的订单
                case 29922002:
                {
                    HYTaxiAlertView *alert = [HYTaxiAlertView instanceView];
                    alert.firstBlock = ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    };
                    alert.secondBlock = ^
                    {
                        HYTabbarViewController *tabbar = (HYTabbarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                        UINavigationController *mineNav = [tabbar.viewControllers objectAtIndex:3];
                        NSMutableArray *vcs = [mineNav.viewControllers mutableCopy];
                        [vcs removeObjectsInRange:NSMakeRange(1, vcs.count-1)];
                        mineNav.viewControllers = vcs;
                        HYTaxiOrderListViewController *vc = [[HYTaxiOrderListViewController alloc]init];
                        [mineNav pushViewController:vc animated:YES];
                        [tabbar setCurrentSelectIndex:3];
                        [tabbar setTabbarShow:NO];
                        
                        NSMutableArray *earnvcs = [weakSelf.navigationController.viewControllers mutableCopy];
                        [earnvcs removeObject:weakSelf];
                        weakSelf.navigationController.viewControllers = earnvcs;
                    };
                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }
        //非异地登陆时才定位
        if (!(-1==result.status))
        {
            //    //开始定位
            [weakSelf getCityInfoFromGPS];
        }
    }];
}

- (void)getSuggestedInfoWithString:(NSString *)keyWord
                       inTextField:(UITextField *)textField
                   CompletionBlock:(GetSuggestedInfoCompletionHandler )completion
{
    __weak typeof(self) weakSelf = self;
    if (!_getSuggestAddressRequest)
    {
        _getSuggestAddressRequest = [[HYTaxiSuggestAddressRequest alloc]init];
    }
    [_getSuggestAddressRequest cancel];
    _getSuggestAddressRequest.cityName = _cityName;
    _getSuggestAddressRequest.address = keyWord;
    _getSuggestAddressRequest.latitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lat];
    _getSuggestAddressRequest.longitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lon];
    [_getSuggestAddressRequest sendReuqest:^(HYTaxiSuggestAddressResponse *result, NSError *error) {
        if (200 == result.status)
        {
            weakSelf.inputHistoryTableViewOfEnd.hidden = YES;
            weakSelf.inputHistoryTableViewOfStart.hidden = YES;
            if (result.suggAddressList.count > 0)
            {
                switch (textField.tag)
                {
                    case 888:
                    {
                        weakSelf.inputIllusionForStart = [result.suggAddressList mutableCopy];
                        weakSelf.inputIllusionNullViewOfStart.hidden = YES;
                        [weakSelf.inputIllusionTableViewOfStart reloadData];
                        weakSelf.inputIllusionTableViewOfStart.hidden = NO;
                        if (completion)
                        {
                            completion();
                        }
                    }
                        break;
                    case 889:
                    {
                        weakSelf.inputIllusionForEnd = [result.suggAddressList mutableCopy];
                        weakSelf.inputIllusionNullViewOfEnd.hidden = YES;
                        [weakSelf.inputIllusionTableViewOfEnd reloadData];
                        weakSelf.inputIllusionTableViewOfEnd.hidden = NO;
                    }
                        break;
                    default:
                        break;
                }
            }
            else
            {
                switch (textField.tag)
                {
                    case 888:
                    {
                        weakSelf.inputIllusionNullViewOfStart.hidden = NO;
                        weakSelf.inputIllusionNullViewOfEnd.hidden = !weakSelf.inputIllusionNullViewOfStart.hidden;
                        if (completion)
                        {
                            completion();
                        }
                    }
                        break;
                    case 889:
                    {
                        weakSelf.inputIllusionNullViewOfEnd.hidden = NO;
                        weakSelf.inputIllusionNullViewOfStart.hidden = !weakSelf.inputIllusionNullViewOfEnd.hidden;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        else
        {
            switch (textField.tag)
            {
                case 888:
                {
                    weakSelf.inputIllusionNullViewOfStart.hidden = NO;
                    weakSelf.inputIllusionNullViewOfEnd.hidden = !weakSelf.inputIllusionNullViewOfStart.hidden;
                    if (completion)
                    {
                        completion();
                    }
                }
                    break;
                case 889:
                {
                    weakSelf.inputIllusionNullViewOfEnd.hidden = NO;
                    weakSelf.inputIllusionNullViewOfStart.hidden = !weakSelf.inputIllusionNullViewOfEnd.hidden;
                }
                    break;
                default:
                    break;
            }
        }
    }];
  
}

- (void)saveHistory
{
    //存储起始点和终点的历史数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (_suggestInfoFromStart)
    {
        BOOL repeated = NO;
        int mark = 0;
        NSDictionary *dict = [_suggestInfoFromStart toDictionary];
        if (dict.count > 0)
        {
            for (int i = 0; i < self.inputHistoryForStart.count; ++i)
            {
                NSDictionary *obj = self.inputHistoryForStart[i];
                //去重
                if ([dict isEqual:obj])
                {
                    repeated = YES;
                    mark = i;
                }
            }
            //遍历完之后决定是否添加
            if (!repeated)
            {
                [self.inputHistoryForStart addObject:dict];
            }
            else
            {
                NSMutableArray *temp = [_inputHistoryForStart mutableCopy];
                id data = temp[mark];
                [temp removeObjectAtIndex:mark];
                [temp addObject:data];
                _inputHistoryForStart = temp;
            }
        }
    }
    else if (_addressDetailFromGPS)
    {
        BOOL repeated = NO;
        int mark = 0;
        NSDictionary *dict = [_addressDetailFromGPS toDictionary];
        if (dict.count > 0)
        {
            for (int i = 0; i < self.inputHistoryForStart.count; ++i)
            {
                NSDictionary *obj = self.inputHistoryForStart[i];
                //去重
                if ([dict isEqual:obj])
                {
                    repeated = YES;
                    mark = i;
                }
            }
            //遍历完之后决定是否添加
            if (!repeated)
            {
                [self.inputHistoryForStart addObject:dict];
            }
            else
            {
                NSMutableArray *temp = [_inputHistoryForStart mutableCopy];
                id data = temp[mark];
                [temp removeObjectAtIndex:mark];
                [temp addObject:data];
                _inputHistoryForStart = temp;
            }
        }
    }
    if (_suggestInfoFromEnd)
    {
        BOOL repeated = NO;
        int mark = 0;
        NSDictionary *dict = [_suggestInfoFromEnd toDictionary];
        if (dict.count > 0 )
        {
            for (int i = 0; i < self.inputHistoryForEnd.count; ++i)
            {
                NSDictionary *obj = self.inputHistoryForEnd[i];
                //去重
                if ([dict isEqual:obj])
                {
                    repeated = YES;
                    mark = i;
                }
            }
            //遍历完之后决定是否添加
            if (!repeated)
            {
                [self.inputHistoryForEnd addObject:dict];
            }
            else
            {
                NSMutableArray *temp = [_inputHistoryForEnd mutableCopy];
                id data = temp[mark];
                [temp removeObjectAtIndex:mark];
                [temp addObject:data];
                _inputHistoryForEnd = temp;
            }
        }
    }
    
    [userDefault setObject:self.inputHistoryForStart forKey:InputHistoryForStart];
    [userDefault setObject:self.inputHistoryForEnd  forKey:InputHistoryForEnd];
    [userDefault synchronize];
    [_inputHistoryTableViewOfEnd reloadData];
    [_inputHistoryTableViewOfStart reloadData];
}

- (void)chooseCarType:(UIButton *)sender
{
    _secondBtnIsSeleted = YES;
    
    if (_tmpBtn == nil)
    {
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender)
    {
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil)
    {
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    
    if (self.proCars)
    {
       NSInteger index = sender.tag % self.proCars.count;
        HYTaxiCarType *obj = self.proCars[index];
        _carTypeCode = obj.carTypeCode;
    }
    
    [self refreshAllSeletedStatus];
}

- (void)calculateEstimatedPrice
{
    if (!_getEstimatedFeeRequest)
    {
        _getEstimatedFeeRequest = [[HYTaxiEstimatedFeeRequest alloc]init];
    }
    [_getEstimatedFeeRequest cancel];
    
    /*
     *优选使用用户选择的地址
     */
    if (_suggestInfoFromStart)
    {
        _getEstimatedFeeRequest.startLatitude = _suggestInfoFromStart.latitude;
        _getEstimatedFeeRequest.startLongitude = _suggestInfoFromStart.longitude;
    }
    else if (_addressDetailFromGPS)
    {
        _getEstimatedFeeRequest.startLatitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lat];
        _getEstimatedFeeRequest.startLongitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lon];
    }
    
    if (_suggestInfoFromEnd)
    {
        _getEstimatedFeeRequest.endLatitude = _suggestInfoFromEnd.latitude;
        _getEstimatedFeeRequest.endLongitude = _suggestInfoFromEnd.longitude;
    }
    _getEstimatedFeeRequest.cityCode = _cityCode;
    _getEstimatedFeeRequest.ruleCode = _ruleCode;
    _getEstimatedFeeRequest.carTypeCode = _carTypeCode;
    __weak typeof(self) weakSelf = self;
    [_getEstimatedFeeRequest sendReuqest:^(HYTaxiEstimatedFeeResponse *result, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (result.dataList.count > 0)
        {
            weakSelf.carFeeDataList = [result.dataList mutableCopy];
            strongSelf->_estimatedTaxiFeeModel = strongSelf->_carFeeDataList[0];
            strongSelf->_estimatedFee = strongSelf->_estimatedTaxiFeeModel.carTypeFee;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)getCityInfoFromGPS
{
    __weak typeof(self) weakSelf = self;
    [[HYLocationManager sharedManager]getAddressInfo:^(HYLocateState state, HYLocateResultInfo *addrInfo)
     {
         if (weakSelf)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             strongSelf->_didReceiveLocationInfo = YES;
             
             switch (state)
             {
                 case HYReverseGeoSearchSuccess:
                 {
                     strongSelf->_addressDetailFromGPS = addrInfo;
                     strongSelf->_addressInfo = addrInfo.address;
                     strongSelf->_cityName = addrInfo.city;
                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                     NSArray *array = @[indexPath];
                     [weakSelf.tableView reloadRowsAtIndexPaths:array
                                               withRowAnimation:UITableViewRowAnimationNone];
                     
                     //定位成功后联想一次，并默认选择第一条
                     HYTaxiDestinationCell *cell = [strongSelf->_tableView cellForRowAtIndexPath:indexPath];
                     if (cell)
                     {
                         NSString *keyword = addrInfo.streetName;
                         if (!keyword)
                         {
                             keyword = addrInfo.address;
                         }
                         [weakSelf getSuggestedInfoWithString:keyword
                                                  inTextField:cell.inputTextField
                                              CompletionBlock:^{
                             
                             [weakSelf tableView:weakSelf.inputIllusionTableViewOfStart
                         didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                             weakSelf.inputIllusionNullViewOfStart.hidden = YES;
                         }];
                     }
                     
                    //定位成功后获取城市支持的车型类型
                     [weakSelf getCarTypeInfoFromServer];
                 }
                     break;
                 case HYLocateDeny:
                 {
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位服务已关闭" message:@"请到设置->隐私->定位服务中开启【特奢汇】定位服务，以便司机能够准确获取您的位置信息" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
                     alert.tag = HYLocateDeny;
                     [alert show];
                 }
                     break;
                 case HYReverseGeoSearchFailed:
                 case HYLocateFailed:
                 {
                     [weakSelf showAlert];
                 }
                     break;
                 default:
                     break;
             }
         }
         }
     ];
    
    
    //没有任何相应的时候，1分钟后弹出定位失败
//    __strong typeof(weakSelf) strongSelf = weakSelf;
    //这里会内存泄漏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if (weakSelf)
        {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf->_didReceiveLocationInfo)
            {
                [weakSelf showAlert];
            }
        }
    });
}

-(void)showAlert
{
    //定义一个定位失败的alert
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新定位",nil];
    [alert show];
}

- (void)getCarTypeInfoFromServer
{
    if (!_getCityRuleRequest)
    {
        _getCityRuleRequest = [[HYTaxiGetCityRuleRequest alloc]init];
    }
    [_getCityRuleRequest cancel];
    _getCityRuleRequest.latitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lat];
    _getCityRuleRequest.longitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lon];
    __weak typeof(self) weakSelf = self;
    [_getCityRuleRequest sendReuqest:^(HYTaxiGetCityRuleResponse *result, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf->_cityCode = result.cityCode;
        strongSelf->_carTypeDataList = [result.carDataList mutableCopy];
        [weakSelf updateCarTypeWithData:result.carDataList];
        
        //动态显示支持的车型
        if (strongSelf->_carTypeDataList.count > 0)
        {
            for (HYTaxiRule *obj in strongSelf->_carTypeDataList)
            {
                if ([obj.ruleCode integerValue] == ProCar)
                {
                    strongSelf->_proCars = obj.carTypeArray;
                    [weakSelf.proCars enumerateObjectsUsingBlock:^(HYTaxiCarType *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        CGFloat margin = (ScreenRect.size.width - weakSelf.proCars.count * TFScalePoint(60)) / (weakSelf.proCars.count + 1);
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn setTitle:obj.carTypeName forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[[UIImage imageNamed:@"taxi_car_select"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateSelected];
                        btn.layer.cornerRadius = 50;
                        btn.frame = CGRectMake(margin + (TFScalePoint(60)+margin)*idx, 10, TFScalePoint(60), 30);
                        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                        btn.tag = idx + weakSelf.proCars.count;
                        [btn addTarget:weakSelf action:@selector(chooseCarType:) forControlEvents:UIControlEventTouchUpInside];
                        [weakSelf.proCarSecView addSubview:btn];
                    }];
                }
            }
        }
    }];
}

- (void)updateCarTypeWithData:(NSArray *)data
{
    //只支持一种车型
    if (1 == data.count)
    {
        CGRect frame1 = CGRectMake(TFScalePoint(100), 8, TFScalePoint(120), 35);
        CGRect frame2 = CGRectMake(TFScalePoint(142), 35, TFScalePoint(40), 21);
        
        for (HYTaxiRule *obj in data)
        {
            if ([obj.ruleName isEqualToString:@"专车"])
            {
                _fastCar.hidden = YES;
                _fastCarLab.hidden = YES;
                
                _proCar.frame = frame1;
                _proCarLab.frame = frame2;
            }
            else
            {
                _proCar.hidden = YES;
                _proCarLab.hidden = YES;
                
                _fastCar.frame = frame1;
                _fastCarLab.frame = frame2;
            }
        }
    }
}

-(void)goToCallTaxi:(id)sender
{
    [self.view endEditing:YES];
    
    [self saveHistory];
    
    HYTaxiAddOrderParam *obj = [[HYTaxiAddOrderParam alloc]init];
    obj.cityCode = _cityCode;
    obj.ruleCode = _ruleCode;
    obj.ruleName = _ruleName;
    /*"callCarType": "叫车类型,0实时，1预约，不能为空"*/
    obj.callCarType = @"0";
    obj.carTypeCode = _carTypeCode;
    if (_suggestInfoFromStart)
    {
        obj.startLatitude = _suggestInfoFromStart.latitude;
        obj.startLongitude = _suggestInfoFromStart.longitude;
        obj.startAddressName = _suggestInfoFromStart.address;
    }
    else
    {
        obj.startLongitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lon];
        obj.startLatitude = [NSString stringWithFormat:@"%f",_addressDetailFromGPS.lat];
        obj.startAddressName = _addressDetailFromGPS.address;
    }
    if (_suggestInfoFromEnd)
    {
        obj.endLatitude = _suggestInfoFromEnd.latitude;
        obj.endLongitude = _suggestInfoFromEnd.longitude;
        obj.endAddressName = _suggestInfoFromEnd.address;
    }
    HYTaxiProcessViewController *vc = [[HYTaxiProcessViewController alloc] init];
    vc.orderParam = obj;
    vc.taxiType = _taxiType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickFastCarBtn:(id)sender
{
    _fastCar.selected = !_fastCar.isSelected;

    if (_fastCar.selected)
    {
        _proCar.selected = NO;
        
        _proCarSecView.hidden = YES;
        _chenwtSBView.frame = CGRectMake(0, 20, TFScalePoint(320), 455);
        _showProCarSecView = NO;
        
        _ruleCode = [NSString stringWithFormat:@"%lu",(unsigned long)FastCar];
        _ruleName = @"快车";
        
        _carTypeCode = [NSString stringWithFormat:@"%lu",(unsigned long)NormalFastCar];
        _taxiType = 1;
    }
    
    [self refreshAllSeletedStatus];
}

- (IBAction)clickProCarBtn:(id)sender
{
    _proCar.selected = !_proCar.isSelected;

    if (_proCar.selected)
    {
        _fastCar.selected = NO;
        
        
        _ruleCode = [NSString stringWithFormat:@"%lu",(unsigned long)ProCar];
        _ruleName = @"专车";
        
        _taxiType = 2;
    }
    
    _showProCarSecView = !_showProCarSecView;
    
    [self showProCarSecView];
    
    [self refreshAllSeletedStatus];
}

- (void)showProCarSecView
{
    CGRect __block frame = _chenwtSBView.frame;
    _proCarSecView.hidden = NO;
    
    [UIView animateWithDuration:.5f animations:^{
        if (_showProCarSecView)
        {
            frame.origin.y += 40;
//            frame.size.width = TFScalePoint(frame.size.width);
            _chenwtSBView.frame = frame;
        }
        else
        {
            frame.origin.y -= 40;
//            frame.size.width = TFScalePoint(frame.size.width);
            _chenwtSBView.frame = frame;
        }
    }];
}

#pragma mark tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        if (indexPath.row == 0)
        {
            static NSString *ID = @"StartPoint";
            HYTaxiDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID
                                                                          forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"car_icon_location.png"];
            cell.hiddenLine = YES;
            cell.inputTextField.placeholder = @"定位中...";
            cell.inputTextField.delegate = self;
            cell.inputTextField.tag = 888;
            cell.inputTextField.returnKeyType = UIReturnKeyDone;
            cell.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.inputTextField addTarget:self action:@selector(keyWordDidChangeInTextField:) forControlEvents:UIControlEventEditingChanged];
            if (_startPointFromInputView)
            {
                cell.inputTextField.text = _startPointFromInputView;
                _startOk = YES;
            }
            else if (_addressInfo.length > 0)
            {
                cell.inputTextField.text = _addressInfo;
                _startOk = YES;
            }
            else
            {
                _startOk = NO;
            }
            return cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *ID = @"EndPoint";
            HYTaxiDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID
                                                                          forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"car_icon_location2.png"];
            cell.hiddenLine = NO;
            cell.inputTextField.placeholder = @"现在要去";
            cell.inputTextField.delegate = self;
            cell.inputTextField.tag = 889;
            cell.inputTextField.returnKeyType = UIReturnKeyDone;
            cell.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.inputTextField addTarget:self action:@selector(keyWordDidChangeInTextField:) forControlEvents:UIControlEventEditingChanged];
            if (_endDestinationFromInputView)
            {
                cell.inputTextField.text = _endDestinationFromInputView;
                _endOk = YES;
            }
            return cell;
        }
        else
        {
            //section的cell局部变量可能会覆盖此处的局部变量
            HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseLine"];
            if (!cell)
            {
                cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"BaseLine"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            NSString *str = nil;
            if (_estimatedFee)
            {
                str = [NSString stringWithFormat:@"约%@元",_estimatedFee];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                [attrStr addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(1, _estimatedFee.length)];
                cell.textLabel.attributedText = attrStr;
            }
            else
            {
                str = [NSString stringWithFormat:@"约 元"];
                cell.textLabel.text = str;
            }
            return cell;
        }
    }
    else if (tableView == _inputHistoryTableViewOfStart)
    {
        HYTaxiDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputHistoryForStartCell"
                                                                      forIndexPath:indexPath];
        if (indexPath.row < self.inputHistoryForStart.count)
        {
            NSDictionary *data = self.inputHistoryForStart[self.inputHistoryForStart.count - 1 - indexPath.row];
            HYTaxiSuggestAddress *tempObj = [[HYTaxiSuggestAddress alloc]initWithDictionary:data error:nil];
            if (tempObj)
            {
               cell.inputTextField.text = tempObj.address;
            }
            cell.inputTextField.userInteractionEnabled = NO;
        }
        return cell;
    }
    //历史终点
    else if (tableView == _inputHistoryTableViewOfEnd)
    {
        HYTaxiDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputHistoryForEndCell"
                                                                      forIndexPath:indexPath];
        if (indexPath.row < self.inputHistoryForEnd.count)
        {
            NSDictionary *data = self.inputHistoryForEnd[self.inputHistoryForEnd.count - 1 - indexPath.row];
            HYTaxiSuggestAddress *tempObj = [[HYTaxiSuggestAddress alloc]initWithDictionary:data error:nil];
            if (tempObj)
            {
                cell.inputTextField.text = tempObj.address;
            }
  
            cell.inputTextField.userInteractionEnabled = NO;
        }
        return cell;
    }
    //起点联想
    else if (tableView == _inputIllusionTableViewOfStart)
    {
        HYTaxiDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputIllusionForStartCell"
                                                                      forIndexPath:indexPath];
        if (indexPath.row < self.inputIllusionForStart.count)
        {
            HYTaxiSuggestAddress *obj = self.inputIllusionForStart[indexPath.row];
            if (obj.address)
            {
                cell.inputTextField.text = obj.address;
            }
            cell.inputTextField.userInteractionEnabled = NO;
        }
        return cell;
    }
    //终点联想
    else
    {
        HYTaxiDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputIllusionForEndCell"
                                                                      forIndexPath:indexPath];
        if (indexPath.row < self.inputIllusionForEnd.count)
        {
            HYTaxiSuggestAddress *obj = self.inputIllusionForEnd [indexPath.row];
            if (obj.address)
            {
                cell.inputTextField.text = obj.address;
            }
            cell.inputTextField.userInteractionEnabled = NO;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        //计价规则
        if (indexPath.row == 2)
        {
            [self.view endEditing:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            HYTaxiEstimatedFeeViewController *vc = [[HYTaxiEstimatedFeeViewController alloc]
                                               initWithNibName:@"HYTaxiEstimatedFeeViewController" bundle:nil];
            vc.taxiFeeModel = _estimatedTaxiFeeModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (tableView == _inputHistoryTableViewOfStart)
    {
        _inputHistoryTableViewOfStart.hidden = YES;
        
        NSDictionary *data = self.inputHistoryForStart[self.inputHistoryForStart.count-1-indexPath.row];
        HYTaxiSuggestAddress *tempObj = [[HYTaxiSuggestAddress alloc]initWithDictionary:data error:nil];
        if (tempObj)
        {
            _suggestInfoFromStart = tempObj;
           _startPointFromInputView = tempObj.address;
        }

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        HYTaxiDestinationCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell)
        {
            cell.inputTextField.text = _startPointFromInputView;
            _startOk = YES;
            [self refreshAllSeletedStatus];
        }
    }
    else if (tableView == _inputHistoryTableViewOfEnd)
    {
        _inputHistoryTableViewOfEnd.hidden = YES;
        
        NSDictionary *data = self.inputHistoryForEnd[self.inputHistoryForEnd.count-1-indexPath.row];
        HYTaxiSuggestAddress *tempObj = [[HYTaxiSuggestAddress alloc]initWithDictionary:data error:nil];
        if (tempObj)
        {
            _endDestinationFromInputView = tempObj.address;
            _suggestInfoFromEnd = tempObj;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            HYTaxiDestinationCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            if (cell)
            {
                cell.inputTextField.text = _endDestinationFromInputView;
                _endOk = YES;
                [self refreshAllSeletedStatus];
            }
        }
    }
    else if (tableView == _inputIllusionTableViewOfStart)
    {
        _inputIllusionTableViewOfStart.hidden = YES;
        HYTaxiSuggestAddress *obj = self.inputIllusionForStart[indexPath.row];
        if (obj.address)
        {
            _suggestInfoFromStart = obj;
            _startPointFromInputView = obj.address;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *array = @[indexPath];
                //刷新之后会把第一响应者刷没了
            [_tableView reloadRowsAtIndexPaths:array
                              withRowAnimation:UITableViewRowAnimationNone];
            [self refreshAllSeletedStatus];
        }
    }
    else if (tableView == _inputIllusionTableViewOfEnd)
    {
        _inputIllusionTableViewOfEnd.hidden = YES;
        HYTaxiSuggestAddress *obj = self.inputIllusionForEnd[indexPath.row];
        if (obj.address)
        {
            _suggestInfoFromEnd = obj;
            _endDestinationFromInputView = obj.address;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            NSArray *array = @[indexPath];
            [_tableView reloadRowsAtIndexPaths:array
                              withRowAnimation:UITableViewRowAnimationNone];
            [self refreshAllSeletedStatus];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView == tableView)
    {
        return _canCallTaxi ? 3 : 2;
    }
    else if (_inputHistoryTableViewOfStart == tableView)
    {
        return self.inputHistoryForStart.count > 10 ? 10 : self.inputHistoryForStart.count;
    }
    else if (_inputHistoryTableViewOfEnd == tableView)
    {
        return self.inputHistoryForEnd.count > 10 ? 10 : self.inputHistoryForEnd.count;
    }
    else if (_inputIllusionTableViewOfStart == tableView)
    {
        return self.inputIllusionForStart.count;
    }
    else
    {
        return self.inputIllusionForEnd.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSString *phone = [NSString stringWithFormat:@"telprompt://4008066528"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (HYLocateDeny == alertView.tag)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //重新定位
    else
    {
        if (buttonIndex == 1)
        {
            [self getCityInfoFromGPS];
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            HYTaxiDestinationCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            if (cell)
            {
                cell.inputTextField.placeholder = @"请输入起点";
            }
        }
    }
}

#pragma mark textfield
-(void)keyWordDidChangeInTextField:(UITextField *)textField
{
    if (textField.tag == 888)
    {
        //有数据,输入框为空才弹出搜索历史
        if (self.inputHistoryForStart.count > 0 && textField.text.length <= 0)
        {
            [_getSuggestAddressRequest cancel];
            _inputHistoryTableViewOfStart.hidden = NO;
            _inputHistoryTableViewOfEnd.hidden = !_inputHistoryTableViewOfStart.hidden;
            _inputIllusionTableViewOfStart.hidden = !_inputHistoryTableViewOfStart.hidden;
        }
        if (textField.text.length <= 0)
        {
            [_getSuggestAddressRequest cancel];
            _inputIllusionNullViewOfStart.hidden = YES;
        }
    }
    else if (textField.tag == 889)
    {
        //有数据,输入框为空才弹出搜索历史
        if (self.inputHistoryForEnd.count > 0 && textField.text.length <= 0)
        {
            [_getSuggestAddressRequest cancel];
            _inputHistoryTableViewOfEnd.hidden = NO;
            _inputHistoryTableViewOfStart.hidden = !_inputHistoryTableViewOfEnd.hidden;
            _inputIllusionTableViewOfEnd.hidden = !_inputHistoryTableViewOfEnd.hidden;
        }
        if (textField.text.length <= 0)
        {
            [_getSuggestAddressRequest cancel];
            _inputIllusionNullViewOfEnd.hidden = YES;
        }
    }
    //没有联想结果的时候
    if (textField.text.length > 0)
    {
        UITextRange *selectedRange = [textField markedTextRange];
        NSString * newText = [textField textInRange:selectedRange];
        //获取高亮部分
        if(newText.length>0)
            return;
        [self getSuggestedInfoWithString:textField.text
                             inTextField:textField CompletionBlock:nil];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self changeBaseFrame];
    
    if (textField.tag == 888)
    {
        _inputHistoryTableViewOfEnd.hidden = YES;
        _inputIllusionTableViewOfEnd.hidden = YES;
        
        textField.placeholder = @"请输入起点";
        //有数据,输入框为空才弹出搜索历史
        if (self.inputHistoryForStart.count > 0 && textField.text.length <= 0)
        {
            _inputHistoryTableViewOfStart.hidden = NO;
            _inputHistoryTableViewOfEnd.hidden = !_inputHistoryTableViewOfStart.hidden;
        }
        //输入框有值时，并且获得焦点时，联想一次
        if (textField.text.length > 0)
        {
            [self getSuggestedInfoWithString:textField.text
                                 inTextField:textField CompletionBlock:nil];
            _inputHistoryTableViewOfStart.hidden = YES;
        }
    }
    else if (textField.tag == 889)
    {
        _inputHistoryTableViewOfStart.hidden = YES;
        _inputIllusionTableViewOfStart.hidden = YES;
        //有数据,输入框为空才弹出搜索历史
        if (self.inputHistoryForEnd.count > 0 && textField.text.length <= 0)
        {
            _inputHistoryTableViewOfEnd.hidden = NO;
            _inputHistoryTableViewOfStart.hidden = !_inputHistoryTableViewOfEnd.hidden;
        }
        //输入框有值时，并且获得焦点时，联想一次
        if (textField.text.length > 0)
        {
            [self getSuggestedInfoWithString:textField.text
                                 inTextField:textField CompletionBlock:nil];
            _inputHistoryTableViewOfEnd.hidden = YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _inputIllusionNullViewOfEnd.hidden = YES;
    _inputIllusionNullViewOfStart.hidden = YES;
    [self restoreBaseFrame];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 888:
            _startPoint = textField.text;
            break;
        case 889:
            _endDestination = textField.text;
            break;
        default:
            break;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //第一，判断输入框是否是从联想中选出来的 第二，开始联想
    switch (textField.tag)
    {
        case 888:
            _startOk = (textField.text == _startPointFromInputView);
            break;
        case 889:
            _endOk = (textField.text == _endDestinationFromInputView);
            break;
        default:
            break;
    }
    
//    [self getSuggestedInfoWithString:[textField.text stringByAppendingString:string]
//                         inTextField:textField CompletionBlock:nil];
    

    return YES;
}

#pragma mark getter and setter
-(NSMutableArray *)inputHistoryForEnd
{
    if (!_inputHistoryForEnd)
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:InputHistoryForEnd])
        {
            _inputHistoryForEnd = (NSMutableArray *)[[[NSUserDefaults standardUserDefaults]objectForKey:InputHistoryForEnd]mutableCopy];
        }
        else
        {
            _inputHistoryForEnd = [NSMutableArray array];
        }
    }
    return _inputHistoryForEnd;
}

-(NSMutableArray *)inputHistoryForStart
{
    if (!_inputHistoryForStart)
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:InputHistoryForStart])
        {
            //这里需要强转一下
            _inputHistoryForStart = (NSMutableArray *)[[[NSUserDefaults standardUserDefaults]objectForKey:InputHistoryForStart] mutableCopy];
        }
        else
        {
            _inputHistoryForStart = [NSMutableArray array];
        }
    }
    return _inputHistoryForStart;
}
@end
