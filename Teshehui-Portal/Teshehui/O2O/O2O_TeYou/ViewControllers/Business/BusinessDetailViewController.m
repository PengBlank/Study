//
//  BusinessDetailViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "ConfirmPayViewController.h"
#import "HYHotelMapViewController.h"
#import "BusinessOrderViewController.h"
#import "CommentViewController.h"
#import "PostCommentViewController.h"
#import "HYLoginViewController.h"

#import "PrepayViewController.h"
#import "CommonPayController.h"
#import "BusinessDetailCell.h"
#import "CommentCell.h"
#import "DetailCell0.h"
#import "DetailCell2.h"
#import "DetailCell1.h"
#import "ImageTextCell.h"
#import "TextCell.h"

#import "DLStarRatingControl.h"
#import "TopAdvertisingView.h"
#import "MWPhotoBrowser.h"
#import "FXPageControl.h"

#import "HYAppDelegate.h"
#import "DefineConfig.h"
#import "HYUserInfo.h"

#import "MJExtension.h"
#import "Masonry.h"
#import "METoast.h"
#import "UIUtils.h"

#import "CheckUserCommentRequest.h"
#import "BusinessDetailRequest.h"
#import "UserBalanceRequest.h"
#import "BusinessdetailInfo.h"

#import "UITableView+Common.h"
#import "UIColor+hexColor.h"
#import "UIView+Frame.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"
#import "NSString+Addition.h"



@interface BusinessDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TopAdvertisingViewDelegate,UIActionSheetDelegate,MWPhotoBrowserDelegate,DLStarRatingDelegate,CommentCellDeleagate,DetailCell0Delegate>
{

    BusinessDetailRequest   *_detailRequest;
    CheckUserCommentRequest *_checkRequest;
    UserBalanceRequest      *_uRequest;
    NSMutableArray          *_photos;
    
}
@property (nonatomic,strong) BusinessdetailInfo         *bdInfo;
@property (nonatomic,strong) UITableView                *baseTableView;
@property (nonatomic,strong) FXPageControl              *pageControl;
@property (nonatomic,strong) NSMutableArray             *imageUrls;
@property (nonatomic,strong) TopAdvertisingView         *topAvertisingView;
@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,assign) BOOL                       isLogin;

@end

@implementation BusinessDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (!self.view.window)
    {
        [_detailRequest cancel];
        [_checkRequest cancel];
        _checkRequest = nil;
        _detailRequest = nil;
        _baseTableView.delegate = nil;
        _baseTableView.dataSource = nil;
       
    }
}

- (void)dealloc{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
    [_detailRequest cancel];
    [_checkRequest cancel];
    _checkRequest = nil;
    _detailRequest = nil;
    _baseTableView = nil;
    _baseTableView.delegate = nil;
    _baseTableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    
    self.title = self.businessInfo.MerchantsName;
    self.view.backgroundColor = [UIColor colorWithHexColor:@"f0f0f0" alpha:1];
    self.baseTableView= [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.baseTableView.backgroundColor = [UIColor clearColor];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.baseTableView];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setFrame:CGRectMake(0, 0, ScreenRect.size.width, g_fitFloat(@[@180,@211,@233]))];
    self.baseTableView.tableHeaderView = bgView;
    
    _topAvertisingView = [[TopAdvertisingView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, g_fitFloat(@[@180,@211,@233]))];
    [_topAvertisingView setDelegate:self];
    [_topAvertisingView setImagesArray:nil];
    [bgView addSubview:_topAvertisingView];
    

    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFrame:CGRectMake(15,_topAvertisingView.frame.size.height - TFScalePoint(26), kScreen_Width - 30 , TFScalePoint(26))];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentRight];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [bgView addSubview:_titleLabel];

    _imageUrls = [NSMutableArray  array];
    [self loadData];
}

#pragma mark private methods
- (void)loadData{
    

    
     [HYLoadHubView show];
    _detailRequest  = [[BusinessDetailRequest alloc] init];
    _detailRequest.interfaceURL = [NSString stringWithFormat:@"%@/v4/Merchants/GetMerchants",BASEURL];
    _detailRequest.httpMethod = @"POST";
    _detailRequest.postType = JSON;
    _detailRequest.MerId = _businessInfo.MerId;
    _detailRequest.interfaceType = DotNET2;
    
    WS(weakSelf);
    [_detailRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             
             NSDictionary *objDic = [result jsonDic];
          
             int code = [objDic[@"code"] intValue];
             NSString *msg = objDic[@"msg"];
             if (code == 0) {  //这种接口将成功定义为 0
                 NSDictionary *dic = objDic[@"data"];
        
                 [BusinessdetailInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"Photos" : @"photoInfo"};
                     
                 }];
                 
                 [CommentInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"pics" : @"CommentPhotoInfo"};
                 }];

                 weakSelf.bdInfo  = [BusinessdetailInfo objectWithKeyValues:dic];
             }else{
                 [METoast toastWithMessage:msg ? msg : @"获取商家信息失败"];
                 [HYLoadHubView dismiss];
                 return ;
             }
             
             [weakSelf.imageUrls removeAllObjects];
             for (photoInfo *p in weakSelf.bdInfo.Photos) {
                 if (p.Url != nil) {
                     [weakSelf.imageUrls addObject:p.Url];
                 }
             }
             if (weakSelf.imageUrls.count == 0) {
                 weakSelf.titleLabel.hidden= YES;
             }else{
                    [weakSelf.titleLabel setText:[NSString stringWithFormat:@"1/%lu",(unsigned long)weakSelf.imageUrls.count]];
                   [weakSelf.topAvertisingView setImagesArray:weakSelf.imageUrls];
             }
             
             [weakSelf setBottomButtonWithInfo:weakSelf.bdInfo];
             
             [weakSelf.baseTableView reloadData];
              [HYLoadHubView dismiss];
            
         }else{

             [METoast toastWithMessage:@"获取服务器数据失败"];
              [HYLoadHubView dismiss];
         }
     }];

}

#pragma mark banner视图代理
- (void)topAdvertisingViewCallBack:(TopAdvertisingView *)TopAdvertisingView didScrollImageView:(NSUInteger)paramIndex{
    
    if (_imageUrls.count == 0) {
        return;
    }
    [_titleLabel setText:[NSString stringWithFormat:@"%lu/%lu",(unsigned long)paramIndex,(unsigned long)_imageUrls.count]];
}

- (void)topAdvertisingViewCallBack:(TopAdvertisingView *)TopAdvertisingView didSelectImageView:(NSUInteger)paramIndex{
    
    if (_imageUrls.count == 0) {
         [METoast toastWithMessage:@"该商家还没有添加展示图片"];
        return;
    }
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    [_photos removeAllObjects];
    for (NSString *p in _imageUrls)
    {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p]]];
    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:paramIndex - 1];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark--CommentCellDeleagate
- (void)commentImageClick:(CommentInfo *)commentInfo index:(NSInteger)index{
    
    if (commentInfo.pics.count == 0) {
        return;
    }
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    [_photos removeAllObjects];
    for (CommentPhotoInfo *cpInfo in commentInfo.pics)
    {
        NSString *p = cpInfo.Url;
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p]]];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
    
    
}

#pragma mark 照片浏览器代理
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    DebugNSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

#pragma mark tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 4;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 80;
    }
    else if (indexPath.section == 1) {
        return 50;
    }
    else if (indexPath.section == 2){
        DetailCell2 *cell = (DetailCell2 *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell cellHeight];
    }
    else{
        
        if(_bdInfo.Comment == nil){
            return 0;
        }
        CommentCell *cell = (CommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell cellHeight] - 35;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 3 && _bdInfo.CommentCount != 0){
        return 50;
    }else if (section == 2){
        return 50;
    }else{
        return 0.000001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 3) {
        return  _bdInfo.CommentCount == 0 ? 0.000001 : 10.0f;
    } else {
        
//        if (section == 2 && _bdInfo.CommentCount == 0 ) {
//            
//            if (!_bdInfo.IsBankEnable) {
//                return 0.000001;
//            }
//            return 10;
//        }
        
//        if (section == 2 && _bdInfo.CommentCount == 0 && !_bdInfo.IsBankEnable) {
//            return 0.000001;
//        }
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UIView *aView = [[UIView alloc] init];
        aView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [imageV setFrame:CGRectMake(10, 15, 20, 20)];
        [imageV setImage:IMAGE(@"shops")];
        [aView addSubview:imageV];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, kScreen_Width - 40, 20)];
        [titleLabel setText:@"商家详情"];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        titleLabel.userInteractionEnabled = YES;
        [aView addSubview:titleLabel];
        [UIUtils addLineInView:aView top:NO leftMargin:0 rightMargin:0];
        
        return aView;
    }
    
    if(section == 0 || section == 1 || _bdInfo.CommentCount == 0){
        return nil;
    }
    else{
        UIView *aView = [[UIView alloc] init];
        
        aView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [imageV setFrame:CGRectMake(10, 15, 20, 20)];
        [imageV setImage:IMAGE(@"icon_criticism")];
        [aView addSubview:imageV];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, kScreen_Width - 40, 20)];
        [titleLabel setText:[NSString stringWithFormat:@"用户评价（%@）",@(_bdInfo.CommentCount)]];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        titleLabel.userInteractionEnabled = YES;
        [aView addSubview:titleLabel];
        [UIUtils addLineInView:aView top:NO leftMargin:0 rightMargin:0];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrowright"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 15, kScreen_Width, 20)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kScreen_Width - 30, 0, 0)];
        [btn addTarget:self action:@selector(checkCommentClick) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:btn];
        
        return aView;
    }
    

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId0 = @"DetailCell0";
    static NSString *cellId1 = @"DetailCell1";
    static NSString *cellId2 = @"DetailCell2";
    static NSString *cellId3 = @"CommentCell";
    
    if (indexPath.section == 0) {
        
        DetailCell0 *cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
        if (cell == nil) {
            cell = [[DetailCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell bindDataWithDetailSection0:_bdInfo];
        return cell;
    }
    else if (indexPath.section == 1) {
  
        DetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil) {
            cell = [[DetailCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell bindDataWithDetailSection1:_bdInfo];
        return cell;
        
    }
    else if (indexPath.section == 2){
        
        DetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[DetailCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        WS(weakSelf);
        [cell setBtnClickBlock:^(BusinessdetailInfo *info, UIButton *btn) {
    
            [weakSelf.baseTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:2]]
                                  withRowAnimation:UITableViewRowAnimationFade];

        }];
        [cell bindata:_bdInfo andIndex:indexPath.row];
        return cell;
        
    } else {
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if (_bdInfo.Comment == nil) {
            [cell bindDataWithNoCommnet];
            
        }else{
            [cell bindData:_bdInfo];
        }
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell1 forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_bdInfo == nil) {
        return;
    }
    
    if (indexPath.section == 0) {
        
        DetailCell0 *cell = (DetailCell0 *)cell1;
        [cell displayBottomLine:YES isLast:YES];
    }
    else if (indexPath.section == 1) {

            ImageTextCell *cell = (ImageTextCell *)cell1;
            [cell displayBottomLine:YES isLast:YES];
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {

            ImageTextCell *cell = (ImageTextCell *)cell1;
            [cell displayBottomLine:YES isLast:YES];
            
        }else{
            
            BusinessDetailCell *cell = (BusinessDetailCell *)cell1;
            [cell displayBottomLine:YES isLast:YES];
            
        }
    }
    else {
        
        if (_bdInfo.Comment != nil) {
            CommentCell *cell = (CommentCell *)cell1;
            [cell displayBottomLine:YES isLast:YES];
        }
     }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (_bdInfo.Latitude == 0 && _bdInfo.Longitude == 0)
        {
            [METoast toastWithMessage:@"该商户没有录入地理信息，无法定位"];
            return;
        }
        else
        {
            HYHotelMapViewController *map = [[HYHotelMapViewController alloc] init];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_bdInfo.Latitude, _bdInfo.Longitude);
            map.annotationTitle = _bdInfo.MerchantsName;
            map.showAroundShops = NO;
            map.location = location;
            map.coorType = HYCoorBaidu;
            [self.navigationController pushViewController:map animated:YES];
        }
    } else if (indexPath.section == 1) {
    
        if (_bdInfo.CommentCount != 0) {
            [self checkCommentClick];
        }
        
    }
}

#pragma mark -- Cell0Delegate
- (void)ClickPhoneCallback{
    NSString *phoneNum = self.bdInfo.Phone;
    if (phoneNum == nil) {
        [METoast toastWithMessage:@"该商户暂时无法联系"];
        return ;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:phoneNum otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}


#pragma mark -- actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 0){
        NSString *s = [actionSheet buttonTitleAtIndex:buttonIndex];;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",s];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)checkCommentClick{
    if (!_isLogin) {
         [self loginEvent];
    }else{
        CommentViewController *tmpCtrl = [[CommentViewController alloc] init];
        tmpCtrl.businessInfo = _bdInfo;
        [self.navigationController pushViewController:tmpCtrl animated:YES];
    }
}

#pragma mark private methods
- (void)loginEvent
{

    HYLoginViewController *vc = [[HYLoginViewController alloc] init];
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark --  评分视图代理
-(void)newRating:(DLStarRatingControl *)control :(CGFloat)rating{

}

- (void)setBottomButtonWithInfo:(BusinessdetailInfo *)info{
    
    
    if (info.IsBankEnable == 1 && info.enableCharge == 1){
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn setTitle:@"付款" forState:UIControlStateNormal];
        [payBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
        [payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payBtn];
        
        UIButton *prepaidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [prepaidBtn setTitle:@"充值" forState:UIControlStateNormal];
        [prepaidBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [prepaidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [prepaidBtn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
        [prepaidBtn addTarget:self action:@selector(prepaidBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:prepaidBtn];
        
        [prepaidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.width.mas_equalTo(kScreen_Width/2);
            make.height.mas_equalTo(50);
        }];
        
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kScreen_Width/2);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.width.mas_equalTo(kScreen_Width/2);
            make.height.mas_equalTo(50);
        }];
        
        [self.baseTableView setHeight:self.view.height - 50];
        
    }else if (info.IsBankEnable == 1 && info.enableCharge == 0){
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn setTitle:@"付款" forState:UIControlStateNormal];
        [payBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
        [payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payBtn];
        
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.width.mas_equalTo(kScreen_Width);
            make.height.mas_equalTo(50);
        }];
        
        [self.baseTableView setHeight:self.view.height - 50];
    
    }else if ((!info.IsBankEnable && info.enableCharge == 1)){
        
        UIButton *prepaidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [prepaidBtn setTitle:@"充值" forState:UIControlStateNormal];
        [prepaidBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [prepaidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [prepaidBtn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
        [prepaidBtn addTarget:self action:@selector(prepaidBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:prepaidBtn];
        
        [prepaidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.width.mas_equalTo(kScreen_Width);
            make.height.mas_equalTo(50);
        }];
        
        [self.baseTableView setHeight:self.view.height - 50];
        
        
    } else {
    
    }
}

- (void)prepaidBtnAction{
    
    if (_isLogin) {
        
        PrepayViewController *vc = [[PrepayViewController alloc] init];
        vc.merId = _bdInfo.MerId; // 传入商家id
        vc.comeType = 1; // 进入路径
        vc.merchantType =_bdInfo.isBilliards;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [self loginEvent];
    }
}

- (void)payBtnAction{

   // enableCharge":0,"isDiscount":0,"discounts":null,"isBilliards":0},"code":"0","msg":"获取商家信息"}
    if (_isLogin) {
        
        if (_bdInfo.isBilliards == 1) { //是桌球商家
            //跳桌球
            ConfirmPayViewController *tmpCtrl = [[ConfirmPayViewController alloc] init];
            tmpCtrl.businessdetailInfo = _bdInfo;
            tmpCtrl.payType = ConfirmBilliardsPay;
            [self.navigationController pushViewController:tmpCtrl animated:YES];
            
        }else if (_bdInfo.enableCharge == 1){ //能充值
            //跳快餐
            ConfirmPayViewController *tmpCtrl = [[ConfirmPayViewController alloc] init];
            tmpCtrl.businessdetailInfo = _bdInfo;
            tmpCtrl.payType = ConfirmCateringPay;
            [self.navigationController pushViewController:tmpCtrl animated:YES];
            
        }else{
            //跳普通
            //如果普通的没有开通折扣isDiscount 跳到桌球类型
            if(_bdInfo.isDiscount == 1) // 开通折扣
            {
                UIStoryboard *tmpStorybord = [UIStoryboard storyboardWithName:@"CommonPay" bundle:nil];
                CommonPayController *tmpCtrl = [tmpStorybord instantiateViewControllerWithIdentifier:@"CommonPayController"];
                tmpCtrl.navbarTheme = HYNavigationBarThemeRed;
                tmpCtrl.bdInfo = _bdInfo;
                [self.navigationController pushViewController:tmpCtrl animated:YES];
            }else
            {// 消费额 字段修改成 实付现金
                ConfirmPayViewController *tmpCtrl = [[ConfirmPayViewController alloc] init];
                tmpCtrl.businessdetailInfo = _bdInfo;
                tmpCtrl.payType = ConfirmBilliardsPay;
                tmpCtrl.isChange = YES;
                [self.navigationController pushViewController:tmpCtrl animated:YES];
            }
        }

    }else{
        [self loginEvent];
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

@end
