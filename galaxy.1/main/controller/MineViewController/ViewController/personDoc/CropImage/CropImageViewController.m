//
//  CropImageViewController.m
//  ImageTailor
//
//  Created by yinyu on 15/10/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import "CropImageViewController.h"
#import "TKImageView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CROP_PROPORTION_IMAGE_WIDTH 30.0f
#define CROP_PROPORTION_IMAGE_SPACE 48.0f
#define CROP_PROPORTION_IMAGE_PADDING 20.0f

@interface CropImageViewController () <GPClientDelegate>
{
    
    NSArray *proportionImageNameArr;
    NSArray *proportionImageNameHLArr;
    NSArray *proportionArr;
    NSMutableArray *proportionBtnArr;
    CGFloat currentProportion;

}
@property (strong, nonatomic) UIScrollView *cropProportionScrollView;
@property (strong, nonatomic) TKImageView *tkImageView;

@end

@implementation CropImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTitle:Custing(@"签名", nil) backButton:YES];
    _tkImageView = [[TKImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    [self.view addSubview:_tkImageView];
    [self setUpTKImageView];
    currentProportion = 0;
    _tkImageView.scaleFactor = 0.6;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(clickOkBtn:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
- (void)setUpTKImageView {
    
    _tkImageView.toCropImage = _image;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = YES;
    _tkImageView.cropAreaCornerWidth = 25;
    _tkImageView.cropAreaCornerHeight = 25;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor lightGrayColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor grayColor];
    _tkImageView.cropAreaCornerLineWidth = 2;
    _tkImageView.cropAreaBorderLineWidth = 2;
    _tkImageView.cropAreaMidLineWidth = 0;
    _tkImageView.cropAreaMidLineHeight = 0;
    _tkImageView.cropAreaMidLineColor = [UIColor clearColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor clearColor];
    _tkImageView.cropAreaCrossLineWidth = 0;
    _tkImageView.cropAspectRatio = 3.75;
}


- (void)clickOkBtn:(id)sender {
    UIImage *image = [[_tkImageView currentCroppedImage] rescaleImageToSize:CGSizeMake(300, 80)];
    
    NSData *fileData = UIImageJPEGRepresentation(image, 1);
    
    //图片上传处理
    NSDate *pickerDate = [NSDate dateWithTimeIntervalSinceNow:8 * 3600];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *name= [pickerFormatter stringFromDate:pickerDate];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]RequestByPostOnImageWithPath:[NSString stringWithFormat:@"user/UpdateSign"] Parameters:nil NSData:fileData name:name type:@"image/png" Delegate:self SerialNum:3 IfUserCache:NO];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    self.userdatas.RefreshStr = @"YES";
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改签名成功", nil) duration:2.0];
    [self performBlock:^{
        [self.navigationController popViewControllerAnimated:NO];
    } afterDelay:1.5];
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


@end
