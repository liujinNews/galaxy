//
//  QRCodeBaseController.m
//  galaxy
//
//  Created by hfk on 2017/9/29.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "QRCodeBaseController.h"
#import "JQScanResult.h"
#import "JQScanWrapper.h"
#import "EXInvoicedViewController.h"
#import "ManInputInvoiceController.h"
@interface QRCodeBaseController ()

@end

@implementation QRCodeBaseController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    JQScanViewStyle *style = [[JQScanViewStyle alloc]init];
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.animationImage = [UIImage imageNamed:@"qr_scan_line"];
    style.photoframeAngleStyle=LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW=4;
    self.style = style;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = Color_Unsel_TitleColor;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
    self.navigationController.navigationBar.hidden = YES;
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
    self.navigationController.navigationBar.hidden = NO;
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self drawNavItems];
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];
}
-(void)drawNavItems{
    // 返回键
    UIButton *goBackButton = ({
        UIButton *button =
        [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 36, 36)];
        [button setImage:[UIImage imageNamed:@"qr_vc_left"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 18.0;
        button.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
        [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:goBackButton];
    
    // 控制散光灯
    UIButton *torchSwitch = ({
        UIButton *button =
        [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width-36-20, 30, 36, 36)];
        [button setImage:[UIImage imageNamed:@"qr_vc_right"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 18.0;
        button.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
        [button addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:torchSwitch];
    
}
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, Main_Screen_Width, 30);
        _topTitle.center = CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+(Main_Screen_Width - 60*2)/2+10);
        _topTitle.font = [UIFont systemFontOfSize:13.0];
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.layer.cornerRadius = 3.0;
        _topTitle.textColor = Color_form_TextFieldBackgroundColor;
        [self.view addSubview:_topTitle];
        
        if (_type==1) {
            _topTitle.text = Custing(@"QRhear", nil);
        }else if (_type==2){
            _topTitle.text = Custing(@"请将发票二维码置于框内", nil);//Man_Input
            
            _topTitle.center = CGPointMake(Main_Screen_Width/2, (Main_Screen_Height-44)/2+(Main_Screen_Width - 60*2)/2);
            
    
            UILabel *titleLab=[GPUtils createLable:CGRectMake(56, 30, Main_Screen_Width-56-56, 36) text:Custing(@"扫码验证", nil) font:Font_Important_18_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
            [self.view addSubview:titleLab];
            
            
            UIImageView *imageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, Main_Screen_Width, 50) imageName:@"Man_Input"];
            imageView.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+(Main_Screen_Width - 60*2)/2+15+25);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled=YES;
            [self.view addSubview:imageView];
        
            [imageView bk_whenTapped:^{
                ManInputInvoiceController *vc=[[ManInputInvoiceController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            UILabel *lab=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width, 20) text:Custing(@"手工查验", nil) font:[UIFont systemFontOfSize:13.0] textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
            lab.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+(Main_Screen_Width - 60*2)/2+15+50+15);
            [self.view addSubview:lab];
            
            
            UILabel *labSub=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width, 20) text:Custing(@"发票信息会延迟一天", nil) font:[UIFont systemFontOfSize:13.0] textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentCenter];
            labSub.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height-40);
            [self.view addSubview:labSub];
            
        } 
    }
}


- (void)scanResultWithArray:(NSArray<JQScanResult*>*)array
{
    
    if (array.count < 1){
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (JQScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    JQScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    //震动提醒
//        [JQScanWrapper systemVibrate];
    //声音提醒
//        [JQScanWrapper systemSound];
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Custing(@"提示", nil) message:Custing(@"识别失败", nil) preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:Custing(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf reStartDevice];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ------ 识别结果 ------
- (void)showNextVCWithScanResult:(JQScanResult*)strResult
{
    if (_type==1) {
        if (self.QRCodeScanBackBlock) {
            self.QRCodeScanBackBlock(strResult.strScanned, _type);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else if (_type==2){
        EXInvoicedViewController *ex = [[EXInvoicedViewController alloc]init];
        ex.str_result = strResult.strScanned;
        ex.int_Type = 1;
        ex.backIndex=@"0";
        [self.navigationController pushViewController:ex animated:YES];
    }
}



#pragma mark -功能项
- (void)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//打开相册
- (void)openPhoto
{
    if ([JQScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Custing(@"提示", nil) message:Custing(@"请到设置->隐私中开启本程序相册权限", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:Custing(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    //    if (self.isOpenFlash){
    //        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    //    }else{
    //        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    //    }
    
}
//显示提示信息
- (void)showError:(NSString*)str
{
    if (![JQScanWrapper isGetCameraPermission]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Custing(@"提示", nil) message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:Custing(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
