//
//  TravelOrderListView.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelOrderListView.h"
#import "TravelOrderListCell.h"
#import "TravelOrderRequest.h"
#import "SVPullToRefresh.h"
#import "DefineConfig.h"
#import "UITableView+Common.h"
#import "UIView+Common.h"
#import "HYUserInfo.h"
#import "MJExtension.h"
#import "DefineConfig.h"
#import "TravelQRView.h"
#import "NSString+Addition.h"
#import "ZXingObjC.h"
#import "METoast.h"

@interface TravelOrderListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,assign) BOOL                 isNextPage;
@property (nonatomic ,assign) NSInteger            type;
@property (nonatomic ,assign) NSInteger            currentPageIndex;
@property (nonatomic ,copy) ProjectListViewBlock   block;
@property (nonatomic ,strong) UITableView          *contentTableView;
@property (nonatomic ,strong) NSMutableArray       *dataSource;
@property (nonatomic ,strong) UIImage               *savaQRImage;

@property (nonatomic , strong) TravelOrderRequest       *travelOrderRequest;

@end

@implementation TravelOrderListView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type block:(ProjectListViewBlock)block
{
    if (self = [super initWithFrame:frame]) {
        
        _type = type;
        _block = block;
        _dataSource = @[].mutableCopy;
        _currentPageIndex = 1;
        _contentTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
            [self addSubview:tableView];
            
            tableView;
        });
        if(type == 1)
        {
            // 添加通知中心 评论成功时刷新
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithTravelOrderListCommentChanged object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCommentChanged) name:kNotificationWithTravelOrderListCommentChanged object:nil];
        }
        
        [self loadDataWithType:_type];
    }
    return self;
}

-(void) notifyCommentChanged
{
    [self loadDataWithType:_type];
}

- (void)loadDataWithType:(NSInteger)type{
    
    
    WS(weakSelf);
    if (kNetworkNotReachability) {
        
        DebugNSLog(@"网络异常");
        [self configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:[[NSError alloc] init] reloadButtonBlock:^(id sender) {
            [weakSelf loadDataWithType:_type];
        }];
        return;
    }
    
//    if (type == 0) {
//        type = 0;
//    }else{
//        type = 1;
//    }
//    
    [HYLoadHubView show];
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.travelOrderRequest = [[TravelOrderRequest alloc] init];
    self.travelOrderRequest.interfaceURL       = [NSString stringWithFormat:@"%@/v2/travel/GetTravelOrders",TRAVEL_API_URL];
    self.travelOrderRequest.interfaceType      = DotNET2;
    self.travelOrderRequest.postType           = JSON;
    self.travelOrderRequest.httpMethod         = @"POST";
    
    self.travelOrderRequest.UserId             = userInfo.userId;                    //  用户id
    self.travelOrderRequest.orderType          = type;                               //  类型（0可用订单 1订单列表）

    [self.travelOrderRequest sendReuqest:^(id result, NSError *error)
     {
         
         NSMutableArray *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 NSArray *tmpArray = objDic[@"data"];
                 
                 [TravelOrderInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"tickets":@"TravelTicketInfo"};
                 }];
                 objArray  = [TravelOrderInfo objectArrayWithKeyValuesArray:tmpArray];
                 
             }else{
                 NSString *msg = objDic[@"msg"];
                 [METoast toastWithMessage:msg ? : @"获取订单失败"];
             }
         }else{
             [METoast toastWithMessage:@"无法连接服务器"];
         }
         
         [weakSelf updateBusinessListData:objArray error:error];
     }];
    
    
}


//订单列表数据绑定
- (void)updateBusinessListData:(NSMutableArray *)objArray error:(NSError *)error{
    
    WS(weakSelf);
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:objArray];
    [self configBlankPage:EaseBlankPageNoOrder hasData:objArray.count > 0 hasError:error reloadButtonBlock:^(id sender) {
        [weakSelf loadDataWithType:weakSelf.type];
    }];
    [self.contentTableView reloadData];
    [HYLoadHubView dismiss];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return g_fitFloat(@[@6,@7,@8]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return g_fitFloat(@[@(164),@(164),@(HEIGHT(164))]);
    
    // self.type 0可用订单 1订单记录？
    if (self.type == 1) {
//        return g_fitFloat(@[@(205),@(208),@(212)]); //4s 205 6 208
        return 178+48;
    }
//    return g_fitFloat(@[@(155),@(164),@(171)]); //4s 155 6 164
    return 178;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"TravelOrderListCell";
    TravelOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TravelOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
      //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    WS(weakSelf);
    [cell setCodeImageClickBlock:^(TravelOrderInfo *orderInfo) {
        TravelQRView *QRView = [[TravelQRView alloc] initWithFrame:self.bounds];
        QRView.travelOrderInfo = orderInfo;
        [QRView setText];
        [QRView show];
    }];
    
//    [cell setSaveQRImageClickBlock:^(UIImage *image,TravelOrderInfo *oInfo) {
////        [weakSelf saveImageToPhotos:image info:orderInfo];
//        // 保存二维码回调
//    }];
    
    [cell bindData:_dataSource[indexPath.section] type:self.type];
    
    cell.commentButtonClickBlock = ^(TravelOrderInfo *orderInfo, NSInteger type, BOOL isButton)
    {
        WS(weakSelf);
        if (self.block)
        {
            // YES为button
            weakSelf.block(orderInfo,type,isButton);
        }
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 点击cell type0:可用订单 type1:历史订单
        WS(weakSelf);
        if (self.block)
        {
            // YES为button 
            weakSelf.block(_dataSource[indexPath.section], self.type, NO);
        }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
}


- (UIImage *)creatQRCodeImage:(TravelOrderInfo *)travelOrderInfo{
    
    NSString *dataStr = [NSString stringWithFormat:@"travel&tid=%@&sid=%@",travelOrderInfo.tId,travelOrderInfo.merId];
    
    //base64
    dataStr = [dataStr base64EncodedString];
    
    if (dataStr)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:dataStr
                                      format:kBarcodeFormatQRCode
                                       width:215
                                      height:215
                                       error:nil];
        
        if (result)
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            
            self.savaQRImage = [UIImage imageWithCGImage:image.cgimage];
        } else {
            self.savaQRImage = nil;
        }
    }
    
    return self.savaQRImage;
}



#pragma mark -----保存图片
//- (void)saveImageToPhotos:(UIImage *)image info:(TravelOrderInfo *)orderInfo
//{
//    UIImage *QRImage  = [self creatQRCodeImage:orderInfo];
//    if (QRImage == nil) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"保存二维码失败"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }else{
//        
//        UIImage *newImage = [self reSizeImage:QRImage toSize:CGSizeMake(600, 600)];
//    //    UIImage *newImage = [self addText:tmpImage text:[NSString stringWithFormat:@"%@%@%@",orderInfo.touristName,orderInfo.ticketName,orderInfo.orderDate]];
//        
//        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    }
//}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

//给图片加一段文字
- (UIImage *)addText:(UIImage *)img text:(NSString *)mark {
    
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [[UIColor grayColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    [mark drawInRect:CGRectMake(0 , h - 45, w, 80) withFont:[UIFont systemFontOfSize:18]
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存二维码失败" ;
    }else{
        msg = @"保存二维码成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
