//
//  GetCommentViewController.m
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#define getImageCCell_Width floorf((kScreen_Width -15*2 - 10*3)/4)

#import "HYNavigationController.h"

#import "GetCommentViewController.h"
#import "DLStarRatingControl.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "GetCommentCell.h"
#import "GetImageTableCell.h"

#import "UIImage+Common.h"
#import "UIImageView+WebCache.h"
#import "PlaceHolderTextView.h"
#import "METoast.h"
//#import "UMSocial.h"
//#import <TencentOpenAPI/QQApi.h>
//#import "WXApi.h"
#import "DefineConfig.h"
#import "MWPhotoBrowser.h"
#import "HYShareInfoReq.h"
#import "HYUserInfo.h"
//#import "O2OShareInfoRequest.h"
#import "CommentInfo.h"

#import "BusinessOrderViewController.h"
#import "TravelOrdelViewController.h"
#import "BilliardOrderViewController.h"

#import "ShareButtonView.h"

@interface GetCommentViewController ()
<
UITextViewDelegate,
//DLStarRatingDelegate,
UIScrollViewDelegate,
UIActionSheetDelegate,
UIGestureRecognizerDelegate,
UINavigationControllerDelegate,
MWPhotoBrowserDelegate
>
{

    NSMutableArray      *_photos;
    NSMutableArray      *_imagesData; // 评论图片数据的数组
    ShareButtonView     *_sbView;       // 分享按钮的view
}
//@property (nonatomic,strong) O2OShareInfoRequest *shareInfoRequest;
@property (nonatomic,assign) CGFloat             starValue;
@property (nonatomic,assign) CGFloat             commentLabelHeight;

@end

@implementation GetCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexColor:@"ffffff" alpha:1];
    self.title = @"评价&分享";
    _commentLabelHeight = 0;
    
//    NSArray *arr1 = @[@"http://ent.chinanews.com/2015/1014/2015101493443.jpg",@"http://image.game.uc.cn/2015/2/12/10271654.jpg",@"http://bbs.58game.com/data/attachment/forum/201405/06/111214cf8ffhv0xz8ls718.jpg",@"http://img.kuai8.com/attaches/album/0423/201304231647247067.jpg",@"http://i-7.vcimg.com/trim/18cb37c9b0bea81fef9e0fc7e136f7c23342922/trim.jpg"];   // 
//    _imagesData = [NSMutableArray arrayWithArray:arr1];
    
    _baseTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = UIColorFromRGB(255, 255, 255);
        [self.view addSubview:tableView];
        tableView;
    });
    
    
    WS(weakSelf);
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self loadHeadView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //取消侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc{
    
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];

    [_sbView.shareInfoRequest cancel];
    _sbView.shareInfoRequest = nil;
    
    _baseTableView.delegate = nil;
    _baseTableView.dataSource = nil;
}

#pragma mark - 返回按钮
- (void)backToRootViewController:(id)sender{
    //恢复侧滑退出
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    if (nav && [nav isKindOfClass:[HYNavigationController class]])
    {
        [nav setEnableSwip:YES];
    }
        //1是发现订单 2旅游订单
//    if (self.orderType.integerValue == BusinessComment)
//    {
//        NSArray * ctrlArray = self.navigationController.viewControllers;
//        
//        for (UIViewController *ctrl in ctrlArray) {
//            
//            if ([ctrl isKindOfClass:[BusinessOrderViewController class]])
//            {
//                [self.navigationController popToViewController:ctrl animated:YES];
//                return;
//            }
//        }
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else if(self.orderType.integerValue == TravelComment)
//    {
//        NSArray * ctrlArray = self.navigationController.viewControllers;
//        for (UIViewController *ctrl in ctrlArray) {
//            
//            if ([ctrl isKindOfClass:[TravelOrdelViewController class]])
//            {
//                [self.navigationController popToViewController:ctrl animated:YES];
//                return;
//            }
//        }
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//    }else{
//    
//        NSArray * ctrlArray = self.navigationController.viewControllers;
//        
//        for (UIViewController *ctrl in ctrlArray) {
//            
//            if ([ctrl isKindOfClass:[BilliardOrderViewController class]])
//            {
//                [self.navigationController popToViewController:ctrl animated:YES];
//                return;
//            }
//        }
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }

    
//    NSArray *controllers = self.navigationController.viewControllers;
//    UIViewController *vc = controllers[controllers.count-3];
//    [self.navigationController popToViewController: vc animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark-点击代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return YES;
    }
    [self.view endEditing:YES];
    return NO;
}


#pragma mark-- 加载视图

- (void)loadHeadView{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, ScaleHEIGHT(165))];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:[NSString stringWithFormat:@"您在%@成功支付",self.MerName]];
    [titleLabel setText:[NSString stringWithFormat:@"您已在%@成功支付",self.MerName]];
    //[titleLabel setBackgroundColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [titleLabel setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [aView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setText:@"没有金额哦"];
    //   [priceLabel setBackgroundColor:[UIColor colorWithHexColor:@"b80000" alpha:1]];
    [priceLabel setTextColor:[UIColor colorWithHexColor:@"b80000" alpha:1]];
    [priceLabel setFont:[UIFont systemFontOfSize:20]];
    [aView addSubview:priceLabel];
    
    CGFloat coupon = [self.coupon floatValue];
    CGFloat money = [self.money floatValue];
    
    if(coupon == 0 && money != 0){
        
        priceLabel.text  = [NSString stringWithFormat:@"￥%@",self.money];
        
    }else if (coupon != 0 && money == 0){
        
        priceLabel.text  = [NSString stringWithFormat:@"%@现金券",self.coupon];
        
    }else if (coupon != 0 && money != 0){
        priceLabel.text  = [NSString stringWithFormat:@"￥%@ + %@现金券",self.money,self.coupon];
    }
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setText:self.orderDate];
    //  [timeLabel setBackgroundColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [timeLabel setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [timeLabel setFont:[UIFont systemFontOfSize:15]];
    [aView addSubview:timeLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexColor:@"e5e5e5" alpha:1];
    [aView addSubview:lineView];
    
    UILabel *desLabel = [[UILabel alloc] init];
    [desLabel setText:@"    您的评价    "];
    [desLabel setBackgroundColor:[UIColor whiteColor]];
    [desLabel setTextColor:[UIColor colorWithHexColor:@"606060" alpha:1]];
    [desLabel setFont:[UIFont systemFontOfSize:11]];
    [aView addSubview:desLabel];
    
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.superview.mas_top).offset(ScaleHEIGHT(25));
//        make.centerX.mas_equalTo(titleLabel.superview.mas_centerX);
        make.left.mas_equalTo(titleLabel.superview.mas_left).offset(10);
        make.right.mas_equalTo(titleLabel.superview.mas_right).offset(-10);
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(ScaleHEIGHT(20));
        make.centerX.mas_equalTo(titleLabel.superview.mas_centerX);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(ScaleHEIGHT(20));
        make.centerX.mas_equalTo(titleLabel.superview.mas_centerX);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.superview.mas_top).offset(ScaleHEIGHT(155));
        make.left.mas_equalTo(titleLabel.superview.mas_left).offset(kPaddingLeftWidth);
        make.width.mas_equalTo(kScreen_Width - 30);
        make.height.mas_equalTo(0.5);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView.mas_centerY);
        make.centerX.mas_equalTo(titleLabel.superview.mas_centerX);
    }];
    
    self.baseTableView.tableHeaderView = aView;
    
}


#pragma mark tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_commentLabelHeight == 0)
        {
//            return 100;
            //根据文字计算cell的高度 参数：评论内容String
            return 30+[GetCommentCell cellHeightWithString:self.commentText];
        }
        return 30+_commentLabelHeight;
    }else{
        return 10+[GetImageTableCell cellHeightWithArr: self.images];  //传图片的数组进去
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"评价"];
    [titleLabel setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    titleLabel.userInteractionEnabled = YES;
    [aView addSubview:titleLabel];
    
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(80, 0, 100,45) andStars:5 isFractional:YES];
    customNumberOfStars.backgroundColor = [UIColor clearColor];
    customNumberOfStars.userInteractionEnabled = NO;    // 不能点击星星
    customNumberOfStars.rating = self.starNum;          // 显示多少颗星星
    [aView addSubview:customNumberOfStars];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.superview.mas_left).offset(kPaddingLeftWidth);
        make.centerY.mas_equalTo(titleLabel.superview.mas_centerY);
    }];
    
    [customNumberOfStars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(0);
        make.centerY.mas_equalTo(customNumberOfStars.superview.mas_centerY);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(20);
    }];
    
    
    return aView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    // 评论按钮的view
    _sbView = [[ShareButtonView alloc] initWithViewController:self
                                                        MerId:self.MerId
                                                 AndSavePrice:self.coupon
                                           AndBackgroundColor:[UIColor whiteColor]];
    
    return _sbView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CommentCell";
    static NSString *cellID2 = @"ImageCell";
    WS(weakSelf);
    
    if (indexPath.row == 0)
    {   // 评论
        GetCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil)
        {
            cell = [[GetCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.buttonBlock = ^(CGFloat labelHight)
        {
            weakSelf.commentLabelHeight = labelHight;
            [weakSelf.baseTableView reloadData];
        };
        // 评论内容String 用这个方法传进去
        [cell loadCommentLabelText: self.commentText];
        
        return cell;
    }
    // 图片
    GetImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (cell == nil)
    {
        cell = [[GetImageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.images = self.images;
//    cell.images = _imagesData;    //测试图片用
    [cell loadMediaView:self.images];   //传图片的数组，设置相对应的高度
    cell.imageBlock = ^(NSArray *images, NSInteger indexRow)
    {
        [weakSelf commentImageClick:images index:indexRow];
    };
    return  cell;
}

#pragma mark--CommentCellDeleagate
- (void)commentImageClick:(NSArray *)images index:(NSInteger)index{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    for (TweetImage *ctImage in images) {
        TweetImage *curTweetImg = ctImage;
        UIImage *pImage = curTweetImg.image;
        [photos addObject:[MWPhoto photoWithImage: pImage]];
    }
    
    _photos = photos;
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

#pragma mark - MWPhotoBrowserDelegate

#pragma mark 照片浏览器代理
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
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
