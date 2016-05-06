//
//  PostCommentViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "PostCommentViewController.h"
#import "DLStarRatingControl.h"
#import "GetCommentViewController.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "PostCommentCell.h"
#import "PostSendImageTableCell.h"
#import "QBImagePickerController.h"
#import "UIImage+Common.h"
#import "PlaceHolderTextView.h"
#import "METoast.h"
#import "PostCommentRequest.h"
#import "HYUserInfo.h"
#import "QiniuSDK.h"
#import "CommentInfo.h"
#import "QiNiuTokenRequest.h"
#import "HYShareInfoReq.h"
#import "NSString+Common.h"
#import "ShareButtonView.h"
typedef NS_ENUM(NSInteger, ShareType)
{
    WeiXin   = 1,
    QQ  = 2,
    WeiBo = 3,
    WXMomnet
    
};

@interface PostCommentViewController ()
<
UITextViewDelegate,
DLStarRatingDelegate,
UIScrollViewDelegate,
UIActionSheetDelegate,
UIGestureRecognizerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
QBImagePickerControllerDelegate
>
{
    CGFloat _starValue;
    ShareButtonView *_sbView;
}
@property (nonatomic,strong) PostCommentRequest     *postCommentRequest;
@property (nonatomic,strong) QiNiuTokenRequest      *qiNiuTokenRequest;
@property (nonatomic,strong) NSMutableArray         *imageKeyArray;
@property (nonatomic,strong) NSMutableArray         *photosArray;
@property (nonatomic,strong) NSString               *JsonImageString;
@property (nonatomic,strong) NSString               *qiNiuToken;
@property (nonatomic,assign) NSInteger              count;

@property (nonatomic,strong) NSMutableArray               *selectImageArrays;


@end

@implementation PostCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexColor:@"ffffff" alpha:1];
    self.title = @"评价&分享";
    
    _count = 0;
    _starValue = 5.0f;  // 默认为5颗星
    _imageKeyArray = [[NSMutableArray alloc] init];
    _photosArray = [[NSMutableArray alloc] init];
    _selectImageArrays = [[NSMutableArray alloc] init];

    _curPost = [[CommentInfo alloc] init];
    _curPost.tweetImages = [[NSMutableArray alloc] init];
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
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [commitBtn setTitleColor:[UIColor colorWithHexColor:@"ffffff" alpha:1] forState:UIControlStateNormal];
    [commitBtn setTitle:[NSString stringWithFormat:@"提交评价"] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexColor:@"b80000" alpha:1]] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(commitBtn.superview.mas_centerX);
        make.bottom.mas_equalTo(commitBtn.superview.mas_bottom);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(@49);
    }];
    
    
    [self loadHeadView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [self.baseTableView addGestureRecognizer:tap];

    [self getTokenForQiNiu];
}

- (void)tap{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.view endEditing:YES];
}

- (void)dealloc{
    
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [HYLoadHubView dismiss];
    
    [_qiNiuTokenRequest cancel];
    _qiNiuTokenRequest = nil;
    
    _baseTableView.delegate = nil;
    _baseTableView.dataSource = nil;
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
    [titleLabel setText:[NSString stringWithFormat:@"您已在%@成功支付",self.MerName]];
    [titleLabel setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setNumberOfLines:2];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [aView addSubview:titleLabel];

    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setText:@"0"];
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
        make.top.mas_equalTo(titleLabel.superview.mas_top).offset(g_fitFloat(@[@15,@25,@30]));
        make.centerX.mas_equalTo(titleLabel.superview.mas_centerX);
        make.width.mas_equalTo(kScreen_Width);
    }];

    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(g_fitFloat(@[@10,@15,@20]));
        make.centerX.mas_equalTo(titleLabel.superview.mas_centerX);
    }];

    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(g_fitFloat(@[@10,@15,@20]));
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 110;
    }else{
        return [PostSendImageTableCell cellHeightWithObj:_curPost]+15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] init];
    customNumberOfStars.delegate = self;
    customNumberOfStars.backgroundColor = [UIColor clearColor];
    customNumberOfStars.rating = _starValue; //默认5颗星
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
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 评论按钮的view
    _sbView = [[ShareButtonView alloc]initWithViewController:self
                                                       MerId:self.MerId
                                                AndSavePrice:self.coupon
                                          AndBackgroundColor:[UIColor whiteColor]];
    return _sbView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CommentCell";
    static NSString *cellID2 = @"PostSendImageTableCell";
    if (indexPath.row == 1) {
        
        PostSendImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil) {
            cell = [[PostSendImageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        [cell loadMediaView:_curPost];
        
        WS(weakSelf)
        addPicturesBlock callback = ^(){
            [weakSelf.view endEditing:YES];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", @"拍照", nil];
            [actionSheet showInView:weakSelf.view];

        };
        cell.callBack = callback;

        return cell;
        
    }else{
        
        PostCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[PostCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor =  [UIColor colorWithHexColor:@"ffffff" alpha:1];
        }
        cell.textView.tag = 100;
        cell.textView.delegate = self;
        
        return cell;
    }
}

#pragma mark 获取上传到七牛的token
- (void)getTokenForQiNiu{

    self.qiNiuTokenRequest = [[QiNiuTokenRequest alloc] init];
    self.qiNiuTokenRequest.interfaceURL = [NSString stringWithFormat:@"%@/Merchants/Get7NiuUpToken",BASEURL];
    self.qiNiuTokenRequest.httpMethod   = @"GET";

    WS(weakSelf);
    [self.qiNiuTokenRequest sendReuqest:^(id result, NSError *error)
     {
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"Result"] intValue];
             if (code == 1) { //状态值为1 代表请求成功  其他喂失败
                 weakSelf.qiNiuToken = objDic[@"Data"];
             }
         }
     }];
}


#pragma mark 按钮点击事件（发表评论）
- (void)commitBtnClick{
    PlaceHolderTextView *textView = (PlaceHolderTextView *)[self.view viewWithTag:100];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString * textString = [[textView text] stringByTrimmingCharactersInSet:whitespace]; //去掉多余空格
    if(textString.length > 255){
        [METoast toastWithMessage:@"字数超过限制,请重新输入"];
        return;
    }
    
    if (textString.length == 0) {
        [METoast toastWithMessage:@"请输入内容"];
        return;
    }
    
     self.view.userInteractionEnabled = NO;
    [HYLoadHubView show];
 //   [self bindImageData];
    
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    NSString *nameString = userInfo.number.length == 0 ? userInfo.mobilePhone : userInfo.number;
    NSString *headPic = [NSString stringWithFormat:@"%@%@",userInfo.userLogo.imageUrl,userInfo.userLogo.imageFileType];
    
    self.postCommentRequest = [[PostCommentRequest alloc] init];
    self.postCommentRequest.interfaceURL = [NSString stringWithFormat:@"%@/v3/Merchants/AddComment",BASEURL];
    self.postCommentRequest.interfaceType      = DotNET2;
    self.postCommentRequest.postType           = JSON;
    self.postCommentRequest.httpMethod         = @"POST";
    
    self.postCommentRequest.userName     = nameString ? : @"";                               //  用户名
    self.postCommentRequest.uId       = userInfo.userId ? : @"";                                 //  用户Id
    self.postCommentRequest.headPic      = headPic ? : @"";                               //  用户头像url
    self.postCommentRequest.stars        = [NSString stringWithFormat:@"%.0f",_starValue];    //  多少星
    self.postCommentRequest.content      = textString ? : @"";                                      //  评论内容
    self.postCommentRequest.merId        = self.MerId ? : @"";                         //  商家Id
    
    self.postCommentRequest.orderId      = self.orderId ? : @"";                                      //  评论内容
    self.postCommentRequest.orderType    = self.orderType;
    
    [self bindImageData];
    
    if (self.photosArray.count != 0) {
        
        self.postCommentRequest.photos       = self.photosArray;
    }else{
        self.postCommentRequest.photos = @[];
    }
    
  //  self.view.userInteractionEnabled = NO;
    WS(weakSelf);
    [self.postCommentRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功
                 //空格是为了文字居中
                [METoast toastWithMessage:@"                      评论成功 \n  马上分享优惠，赚取更多现金券！"];
                 
                 GetCommentViewController *getVC = [[GetCommentViewController alloc] init];
                 getVC.MerId     = weakSelf.MerId;
                 getVC.MerName   = weakSelf.MerName;
                 getVC.money     = weakSelf.money;
                 getVC.coupon    = weakSelf.coupon;
                 getVC.orderDate = weakSelf.orderDate;
                 
                 getVC.starNum      = _starValue;   // 星星数
                 getVC.commentText  = textString;   // 评论内容
                 getVC.images       = weakSelf.curPost.tweetImages;
                 getVC.orderType    = [NSString stringWithFormat:@"%@",@(weakSelf.orderType)];

                 [weakSelf.navigationController pushViewController:getVC animated:NO];

             }else{
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? msg : @"评论失败"];
             }
         }else{
             [METoast toastWithMessage:@"评论失败"];
         }
         self.view.userInteractionEnabled = YES;
     }];
}


- (void)bindImageData{
    
    
//    
    WS(weakSelf);
    [self.selectImageArrays removeAllObjects];
    self.selectImageArrays = self.curPost.tweetImages; //2016-1-25修改
    [self.selectImageArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TweetImage *imageObj = self.selectImageArrays[idx];
        [weakSelf runLoopUploadImageToQiNiu:imageObj.image index:idx];
    }];

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [_imageKeyArray enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        NSDictionary *tmpDic = @{@"Url":imageName};
        [arr addObject:tmpDic];
    }];
    
    _photosArray = arr;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
    NSString *strData = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];  //再次转换成json字符串保存
    _JsonImageString = strData;
}

//上传图片到七牛
- (void)runLoopUploadImageToQiNiu:(UIImage *)image index:(NSInteger)index{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *opt = [[QNUploadOption alloc] initWithProgessHandler: ^(NSString *key, float percent) {
       // NSString *Progress = [NSString stringWithFormat:@"正在上传第%ld张图片进度%.0f%%",index,percent * 100];
    }];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ((float)imageData.length/1024 > 1000) {
        imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@_image%@_%@",@"userComment",@(index),str];
    
    [_imageKeyArray addObject:fileName];

  //  WS(weakSelf);
    [upManager putData:imageData key:fileName token:self.qiNiuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        DebugNSLog(@"info ==; %@", info);
        DebugNSLog(@"key  ==; %@", key);
        DebugNSLog(@"resp ==; %@", resp);
        if (resp[@"key"]) {

        }else{
            [METoast toastWithMessage:[NSString stringWithFormat:@"第%@张图片上传失败",@(index)]];
        }
        
    } option:opt];
    
}


#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {

        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 6-_curPost.tweetImages.count;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        
        
    }else if (buttonIndex == 1){

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    NSLog(@"%@", info);
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    TweetImage *tweetImg = [TweetImage tweetImageWithImage:[originalImage scaledToSize:[UIScreen mainScreen].bounds.size highQuality:YES]];
    [self.curPost.tweetImages addObject:tweetImg];
    
    // 保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_baseTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    
    for (ALAsset *assetItem in assets) {
        UIImage *highQualityImage = [self fullResolutionImageFromALAsset:assetItem];
        TweetImage *tweetImg = [TweetImage tweetImageWithImage:[highQualityImage scaledToSize:[UIScreen mainScreen].bounds.size highQuality:YES]];
        [self.curPost.tweetImages addObject:tweetImg];
    }
    
    [_baseTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];

    return img;
}


- (UIImage *)getScaleImageWithSize:(long)byteSize withImage:(UIImage *)image{
    
    return [self getScaleImageWithSize:byteSize withImage:image receiveImageDatas:nil];
}


- (UIImage *)getScaleImageWithSize:(long)byteSize withImage:(UIImage *)image receiveImageDatas:(NSData *)imgData{
    
    if (!image) {
        return image;
    }
    
    //    //如果超过，则降低分辨率
    UIImage *tmpImage = nil;
    NSData *data = UIImageJPEGRepresentation(image, 0.00001);
    //    if (data.length > byteSize) {
    //        float i = (float)byteSize / (float)data.length;
    //        i = sqrt(i);//根号
    //        tmpImage = [UIImage imageWithData:data];
    //        tmpImage = [self imageCompressForSize:tmpImage targetSize:CGSizeMake(tmpImage.size.width * i, tmpImage.size.height * i)];
    //        data = UIImageJPEGRepresentation(tmpImage, 1);
    //    }else{
    //        return [UIImage imageWithData:data];
    //    }
    
    //减小画质
    while (data.length >= byteSize) {
        float i = (float)byteSize / (float)data.length;
        data = UIImageJPEGRepresentation(tmpImage, i);
        i = i * 0.8;
        if (i < 0.1) {
            break;
        }
    }
    
    if (imgData) {
        imgData = data;
    }
    
    return [UIImage imageWithData:data];
    
}

//等比压缩
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)backToRootViewController:(id)sender{
    NSArray *arr = [self.navigationController viewControllers];
    
    if (_backType == BusinessDetail && [arr count] > 1) {
        
        [self.navigationController popToViewController:arr[1] animated:YES];
        
    }else{
        
        if (_payPush) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark--评分控件代理
-(void)newRating:(DLStarRatingControl *)control :(CGFloat)rating{
    _starValue = rating;
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
