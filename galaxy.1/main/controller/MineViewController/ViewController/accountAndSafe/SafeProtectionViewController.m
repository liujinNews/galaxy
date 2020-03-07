//
//  SafeProtectionViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/10/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "SafeProtectionViewController.h"
#import "CLLockVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WJTouchID.h"

@interface SafeProtectionViewController ()<WJTouchIDDelegate>

@property (nonatomic, assign) NSInteger SafePType;
@property (nonatomic, strong) WJTouchID *touchID;//指纹识别
@property (weak, nonatomic) IBOutlet UILabel *lab_Gesture;
@property (weak, nonatomic) IBOutlet UILabel *lab_TouchId;

@end

@implementation SafeProtectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"安全保护", nil)  backButton:YES];
    
    self.view.backgroundColor = Color_White_Same_20;
    
    _lab_Gesture.text = Custing(@"手势", nil);
    _lab_TouchId.text = Custing(@"开启TouchID指纹解锁", nil);
    
    _SafePType = 0;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:SafeProtectionType]) {
        _SafePType = [[[NSUserDefaults standardUserDefaults]objectForKey:SafeProtectionType] integerValue];
    }
    
    if (_SafePType == 1) {
        [_swi_Gesture setOn:YES];
    }else if (_SafePType == 2){
        [_swi_Fingerprint setOn:YES];
    }
    
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前设备不支持指纹识别", nil) duration:1.0];
        _swi_Fingerprint.userInteractionEnabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - action
//设置手势图案
- (IBAction)Swi_Gesture_btn_click:(UISwitch *)sender {
    
    if (sender.isOn==NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:SafeProtectionType];
    }else{
        __weak typeof(self) weakSelf = self;

        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            if ([NSString isEqualToNull:pwd]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:SafeProtectionType];
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"手势密码设置成功", nil) duration:1.0];
                [lockVC dismiss:1.0f];
                [weakSelf.swi_Fingerprint setOn:NO];
            }else{
                [weakSelf.swi_Gesture setOn:NO];
            }
        }];
    }
}

//设置指纹识别
- (IBAction)Swi_Fingerprint_btn_click:(UISwitch *)sender {
    if (sender.isOn==NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:SafeProtectionType];
    }else{
        
        _touchID = [[WJTouchID alloc]init];
        [_touchID startWJTouchIDWithMessage:Custing(@"按压指纹以识别身份", nil) fallbackTitle:nil delegate:self];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:SafeProtectionType];
        [_swi_Gesture setOn:NO];
//        [sender setOn:NO];
    }
}

- (void) WJTouchIDAuthorizeSuccess {
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启成功", nil) duration:1.0];
    [_swi_Fingerprint setOn:YES];
}

- (void) WJTouchIDAuthorizeFailure {
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorAppCancel
{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorSystemCancel{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorUserCancel{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorUserFallback{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorInvalidContext{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorPasscodeNotSet{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorTouchIDLockout{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
}

- (void) WJTouchIDAuthorizeErrorTouchIDNotAvailable{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开启失败", nil) duration:1.0];
    [_swi_Fingerprint setOn:NO];
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
