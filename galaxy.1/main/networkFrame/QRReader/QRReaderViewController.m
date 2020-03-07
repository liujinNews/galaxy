//
//  QRReaderViewController.m
//  YunWan
//
//  Created by 张威 on 15/1/26.
//  Copyright (c) 2015年 ZhangWei. All rights reserved.
//

#import "QRReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "ViewController.h"
#import "AppDelegate.h"

@interface QRReaderViewController() <AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, strong) NSTimer *scanLineTimer;

@end

@implementation QRReaderViewController

- (void)initViewAndSubViews {
    
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = mainBounds;
    
    CGRect readerFrame = self.view.frame;
    //扫描框
    CGSize viewFinderSize = CGSizeMake(readerFrame.size.width - 140, readerFrame.size.width - 140);
    /**********************************摄像头开始**********************************/
    // 1 实例化摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // An AVCaptureDevice object abstracts a physical capture device that provides input data (such as audio or video) to an AVCaptureSession object.
    
    // 2 设置输入,把摄像头作为输入设备
    // 因为模拟器是没有摄像头的，因此在此最好做个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头%@", error.localizedDescription);
        return;
    }
    
    // 3 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    CGRect scanCrop =
    CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
               (readerFrame.size.height - viewFinderSize.height)/2-50,
               viewFinderSize.width,
               viewFinderSize.height);
    
    outPut.rectOfInterest =
    CGRectMake(scanCrop.origin.y/readerFrame.size.height,
               scanCrop.origin.x/readerFrame.size.width,
               scanCrop.size.height/readerFrame.size.height,
               scanCrop.size.width/readerFrame.size.width
               );
    
    // 3.1 设置输出的代理
    // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验。
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    // 4.1 设置输出的格式
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                     AVMetadataObjectTypeCode39Code,
                                     AVMetadataObjectTypeCode128Code,
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code]];
    
    // 5 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // AVCaptureVideoPreviewLayer -- to show the user what a camera is recording
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2设置preview图层的大小
    
    [preview setFrame:self.view.bounds];
    //5.3将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    self.session = session;
    /**********************************摄像头结束**********************************/
    
    /* 画一个取景框开始 */
    // 正方形取景框的边长
    CGFloat edgeLength = 20.0;
    
    UIImageView *topLeft =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2-50,
                                                  edgeLength, edgeLength)];
    topLeft.image = [UIImage imageNamed:@"qr_top_left.png"];
    [self.view addSubview:topLeft];
    
    UIImageView *topRight =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2 - edgeLength,
                                                  (readerFrame.size.height - viewFinderSize.height)/2-50,
                                                  edgeLength, edgeLength)];
    topRight.image = [UIImage imageNamed:@"qr_top_right.png"];
    [self.view addSubview:topRight];
    
    UIImageView *bottomLeft =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height + viewFinderSize.height)/2 - edgeLength-50,
                                                  edgeLength, edgeLength)];
    bottomLeft.image = [UIImage imageNamed:@"qr_bottom_left"];
    [self.view addSubview:bottomLeft];
    
    UIImageView *bottomRight =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2 - edgeLength,
                                                  (readerFrame.size.height + viewFinderSize.height)/2 - edgeLength-50,
                                                  edgeLength, edgeLength)];
    bottomRight.image = [UIImage imageNamed:@"qr_bottom_right"];
    [self.view addSubview:bottomRight];
    
    UIView *topLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height - viewFinderSize.height)/2-51,
                                             viewFinderSize.width+2, 1)];
    topLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topLine];
    
    UIView *bottomLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height + viewFinderSize.height)/2-50,
                                             viewFinderSize.width+2, 1)];
    bottomLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomLine];
    
    UIView *leftLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2-1,
                                             (readerFrame.size.height - viewFinderSize.height)/2-51,
                                             1, viewFinderSize.height+2)];
    leftLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:leftLine];
    
    UIView *rightLine =
    [[UIView alloc] initWithFrame:CGRectMake((readerFrame.size.width + viewFinderSize.width)/2,
                                             (readerFrame.size.height - viewFinderSize.height)/2-51,
                                             1, viewFinderSize.height+2)];
    rightLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:rightLine];
    
    self.scanLineImageView =
    [[UIImageView alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                                  (readerFrame.size.height - viewFinderSize.height)/2-51,
                                                  viewFinderSize.width, 0.064*viewFinderSize.width)];
    self.scanLineImageView.image = [UIImage imageNamed:@"qr_scan_line"];
    
    [self.view addSubview:self.scanLineImageView];
    
    
    /* 画一个取景框结束 */
    
    /* 配置取景框之外颜色开始 */
    // scanCrop
    UIView *viewTopScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainBounds.size.width, scanCrop.origin.y)];
    
    UIView *viewBottomScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, scanCrop.origin.y+scanCrop.size.height,
                                             mainBounds.size.width,
                                             mainBounds.size.height - scanCrop.size.height - scanCrop.origin.y)];
    
    UIView *viewLeftScan =
    [[UIView alloc] initWithFrame:CGRectMake(0, scanCrop.origin.y, scanCrop.origin.x, scanCrop.size.height)];
    
    UIView *viewRightScan =
    [[UIView alloc] initWithFrame:CGRectMake(scanCrop.origin.x + scanCrop.size.width,
                                             scanCrop.origin.y,
                                             mainBounds.size.width - scanCrop.origin.x - scanCrop.size.width,
                                             scanCrop.size.height)];
    viewTopScan.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    viewBottomScan.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    viewLeftScan.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    viewRightScan.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:viewTopScan];
    [self.view addSubview:viewBottomScan];
    [self.view addSubview:viewLeftScan];
    [self.view addSubview:viewRightScan];
    
    /* 配置取景框之外颜色结束 */
    
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
        [[UIButton alloc] initWithFrame:CGRectMake(mainBounds.size.width-44-20, 30, 36, 36)];
        [button setImage:[UIImage imageNamed:@"qr_vc_right"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 18.0;
        button.layer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
        [button addTarget:self action:@selector(torchSwitch:) forControlEvents:UIControlEventTouchDown];
        button;
    });
    [self.view addSubview:torchSwitch];

    
    self.infoLabel =
    [[UILabel alloc] initWithFrame:CGRectMake((readerFrame.size.width - viewFinderSize.width)/2,
                                              (readerFrame.size.height + viewFinderSize.height)/2 - 50 + 10,
                                              viewFinderSize.width, 30)];
    self.infoLabel.text = Custing(@"QRhear", nil);
    if (self.judgeStr==1) {
        self.infoLabel.text = Custing(@"扫描发票", nil);
    }else if (self.judgeStr==2){
        self.infoLabel.text = Custing(@"扫描发票二维码", nil);
    }
    self.infoLabel.font = [UIFont systemFontOfSize:13.0];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.layer.cornerRadius = 3.0;
//    self.infoLabel.layer.backgroundColor = [[UIColor redColor]CGColor];
    self.infoLabel.textColor = Color_form_TextFieldBackgroundColor;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.infoLabel];

    
    self.view.backgroundColor = Color_Unsel_TitleColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewAndSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    //
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:YES];
    
      
    //6.启动会话
    [self.session startRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头%@", error.localizedDescription);
        input = nil;
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    if (self.scanLineTimer == nil) {
        [self moveUpAndDownLine];
        [self createTimer];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO];
    
    [super viewWillDisappear:animated];
     
}

// 返回
- (void)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
//    [self performSegueWithIdentifier:@"returnlog" sender:nil];
}

// 控制散光灯
- (void)torchSwitch:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if (device.hasTorch) {  // 判断设备是否有散光灯
        BOOL b = [device lockForConfiguration:&error];
        if (!b) {
            if (error) {
                NSLog(@"lock torch configuration error:%@", error.localizedDescription);
            }
            return;
        }
        device.torchMode =
        (device.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff);
        [device unlockForConfiguration];
    }
}

#define LINE_SCAN_TIME  3.0     // 扫描线从上到下扫描所历时间（s）

- (void)createTimer {
    self.scanLineTimer =
    [NSTimer scheduledTimerWithTimeInterval:LINE_SCAN_TIME
                                     target:self
                                   selector:@selector(moveUpAndDownLine)
                                   userInfo:nil
                                    repeats:YES];
}

// 扫描条上下滚动
- (void)moveUpAndDownLine {
    CGRect readerFrame = self.view.frame;
    CGSize viewFinderSize = CGSizeMake(self.view.frame.size.width - 140, self.view.frame.size.width - 140);
    
    CGRect scanLineframe = self.scanLineImageView.frame;
    scanLineframe.origin.y =
    (readerFrame.size.height - viewFinderSize.height)/2-50;
    self.scanLineImageView.frame = scanLineframe;
    self.scanLineImageView.hidden = NO;
    
    __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:LINE_SCAN_TIME - 0.05
                     animations:^{
                         CGRect scanLineframe = weakSelf.scanLineImageView.frame;
                         scanLineframe.origin.y =
                         (readerFrame.size.height + viewFinderSize.height)/2 - 50-
                         weakSelf.scanLineImageView.frame.size.height;
                         
                         weakSelf.scanLineImageView.frame = scanLineframe;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.scanLineImageView.hidden = YES;
                     }];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

//此方法是在识别到QRCode并且完成转换，如果QRCode的内容越大，转换需要的时间就越长。
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 会频繁的扫描，调用代理方法
    // 1如果扫描完成，停止会话
    [self.session stopRunning];
    //2删除预览图层
    [self.previewLayer removeFromSuperlayer];
    //设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        __weak typeof(self) weakSelf = self;
        [self performBlock:^{
            [weakSelf.delegate didFinishedReadingQR:obj.stringValue withType: self.judgeStr];
        } afterDelay:0.01];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)clickOperation:(id)obj{
    [self.session stopRunning];
    //2删除预览图层
    [self.previewLayer removeFromSuperlayer];
//    __weak typeof(self) weakSelf = self;
    [self performBlock:^{
//        [weakSelf.delegate didOperation];
    } afterDelay:0.5];
    [self.navigationController popViewControllerAnimated:NO];

//    [self.session stopRunning];
//    ManInputElecController *vc=[[ManInputElecController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];

}


@end
