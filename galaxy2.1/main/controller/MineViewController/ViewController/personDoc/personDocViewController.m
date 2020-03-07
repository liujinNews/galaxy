//
//  personDocViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "modifyCardNumberViewController.h"
#import "departAndPositionViewController.h"
#import "JKAlertDialog.h"

#import "ModifyNameViewController.h"
#import "HClActionSheet.h"

#import "personDocModel.h"
#import "personDocTVCell.h"

#import "personDocViewController.h"

//签名图片裁剪页面
#import "CropImageViewController.h"

@interface personDocViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,GPClientDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSString * qunxian;
@property (nonatomic,strong)NSMutableArray * personArray;

@property(nonatomic,strong)UIImagePickerController* imagePiker;
@property(nonatomic,strong)NSData * fileData;//要上传的图片数据
@property(nonatomic,strong)UIImage* compressedImage;//压缩后的图片
@property(nonatomic,strong)NSDictionary * docDic;

@property(nonatomic,strong)UISwitch * numberHImage;
@property(nonatomic,strong)NSString * isMobileHide;

@property(nonatomic,strong)UISwitch * LookRImage;
@property(nonatomic,strong)NSString * viewRptPer;

@property (nonatomic, strong)JKAlertDialog *alert;
@property (nonatomic,strong)UIImageView * manImage;
@property (nonatomic,strong)UIImageView * womanImage;

@property (nonatomic,strong)NSString * isAvatar;//是否头像
@property(nonatomic,strong)UIImage* qImage;//压缩后的图片

@end

@implementation personDocViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self.qunxian isEqualToString:@"YES"]) {
         [self requestPersonDocumentList];
    }
   
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"个人资料", nil) backButton:YES];
    self.qunxian = @"YES";
    self.personArray = [NSMutableArray array];
    self.personArray = [personDocModel personDocDatasWithUser:self.docDic];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.personArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.personArray[section];
    return [itemArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    footView.backgroundColor=[UIColor clearColor];
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    personDocModel *cellInfo = self.personArray[indexPath.section][indexPath.row];
    return [cellInfo.height floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    personDocTVCell *cell=[tableView dequeueReusableCellWithIdentifier:@"personDocTVCell"];
    if (cell==nil) {
        cell=[[personDocTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personDocTVCell"];
    }
    //cell.viewController = self;
    personDocModel *cellInfo = self.personArray[indexPath.section][indexPath.row];
    [cell configViewWithPersonDocCellInfo:cellInfo];
    switch (cellInfo.type) {
        case personDocCellTypeAvater:
            if ([self.compressedImage isEqual:nil]) {
                cell.HeadPortrait.image = self.compressedImage;
            }
            break;
        case personDocCellTypePhoneHidden:{
            self.numberHImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(cell.mainView)-75, 5, 40, 25)];
            self.numberHImage.backgroundColor = [UIColor clearColor];
            if ([self.isMobileHide isEqualToString:@"0"]) {
                [self.numberHImage setOn:[self.isMobileHide boolValue] animated:NO];
            }else{
                [self.numberHImage setOn:[self.isMobileHide boolValue] animated:NO];
            }
            [self.numberHImage addTarget:self action:@selector(isHiddenNumber:) forControlEvents:UIControlEventValueChanged];
            self.numberHImage.onTintColor = Color_Blue_Important_20;
            [cell.mainView addSubview:self.numberHImage];
        }
            break;
        case personDocCellTypeLookReportRoot:{
            self.LookRImage = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(cell.mainView)-75, 5, 40, 25)];
            self.LookRImage.backgroundColor = [UIColor clearColor];
            if ([self.viewRptPer isEqualToString:@"0"]) {
                [self.LookRImage setOn:[self.viewRptPer boolValue] animated:NO];
            }else{
                [self.LookRImage setOn:[self.viewRptPer boolValue] animated:NO];
            }
            self.LookRImage.userInteractionEnabled = NO;
            self.LookRImage.onTintColor = Color_Blue_Important_20;
            [cell.mainView addSubview:self.LookRImage];
        }
            break;
        case personDocCellTypeSignature:
            if ([self.qImage isEqual:nil]) {
                cell.HeadPortrait.image = self.qImage;
            }
            break;
        default:
            break;
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.qunxian = @"YES";
    personDocModel *cellInfo = self.personArray[indexPath.section][indexPath.row];
    if ([self respondsToSelector:cellInfo.action]) {
        [self performSelector:cellInfo.action withObject:nil afterDelay:0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//MARK:签名
-(void)pushLookReportRootSignature {
    self.isAvatar = @"Signature";
    [self personAvatarOrSignature];
}

//MARK:头像
-(void)SwitchHeadPortrait{
    self.isAvatar = @"Avatar";
    [self personAvatarOrSignature];
}

-(void)personAvatarOrSignature {
    if ([self.userdatas.experience isEqualToString:@"yes"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    
    NSArray *arr;
    if ([NSString isEqualToNull:_docDic[@"signature"]]) {
        arr = @[Custing(@"拍照", nil),Custing(@"从手机相册选择", nil),Custing(@"删除签名", nil)];
    }else{
        arr = @[Custing(@"拍照", nil),Custing(@"从手机相册选择", nil)];
    }
    
    HClActionSheet * actionSheet = [[HClActionSheet alloc] initWithTitle:nil style:HClSheetStyleWeiChat itemTitles:arr];
    actionSheet.delegate = self;
    actionSheet.tag = 100;
    actionSheet.itemTextColor =Color_cellContent;
    actionSheet.itemTextFont=Font_selectTitle_15;
    actionSheet.cancleTextColor =Color_cellContent;
    actionSheet.cancleTextFont=Font_selectTitle_15;
    actionSheet.cancleTitle = Custing(@"取消", nil);
    //    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        if (index==0) {
           self.imagePiker = [[UIImagePickerController alloc]init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.imagePiker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.imagePiker.delegate = self;
                self.imagePiker.allowsEditing =YES;
                
                self.imagePiker.navigationController.navigationBar.translucent = NO;
                [self presentViewController:self.imagePiker animated:YES completion:nil];
            }else{
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"此设备不支持相机", nil) duration:1.5];
            }
        }else if (index==1){
            self.imagePiker = [[UIImagePickerController alloc]init];
            self.imagePiker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePiker.delegate = self;
            self.imagePiker.allowsEditing = YES;
            //            //修改导航栏背景颜色
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [self.imagePiker.navigationBar setBarTintColor:Color_form_TextFieldBackgroundColor];
            }
            [self presentViewController:self.imagePiker animated:YES completion:nil];
        }else if (index == 2){
            [self requestDeleteSign];
        }
    }];
    
}


-(void)popViewControllerLast:(UIButton *)btn{
    [self dismiss:self.imagePiker];
    
}
// 裁减图片
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)addPhoteViewController:(UIButton *)btn{
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismiss:self.imagePiker];
}

- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info{
    
    //获得原始的图片
    
    if ([self.isAvatar isEqualToString:@"Signature"]) {
        //签名图片处理
        
        UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        CropImageViewController *crop = [[CropImageViewController alloc]init];
        crop.image = image;
        [self.navigationController pushViewController:crop animated:YES];
        
//        CGFloat tileWidth = [[UIScreen mainScreen] bounds].size.width/320;
//        CGRect rect =  CGRectMake(0, 100*tileWidth, image.size.width, image.size.width/3.8);
//        CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
//        image = [UIImage imageWithCGImage:cgimg];
        
//        UIImage *editimage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 80)];
//        
//        UIImage* newImage = [GPUtils scaleImage:editimage scaleFactor:1.0];
//        self.qImage = newImage;
//        self.fileData = UIImageJPEGRepresentation(newImage, 0.5);
//        

        
    }else {
        UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        UIImage *editimage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
        
        UIImage* newImage = [GPUtils scaleImage:editimage scaleFactor:1.0];
        self.compressedImage = newImage;
        self.fileData = UIImageJPEGRepresentation(newImage, 0.5);
        
        //图片上传处理
        NSDate *pickerDate = [NSDate dateWithTimeIntervalSinceNow:8 * 3600];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *name= [pickerFormatter stringFromDate:pickerDate];
         [[GPClient shareGPClient]RequestByPostOnImageWithPath:XB_UptUserPhoto Parameters:nil NSData:self.fileData name:name type:@"image/png" Delegate:self SerialNum:2 IfUserCache:NO];
        
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
//    self.AvatarIV.image = newImage;
//    self.AvatarIV.layer.cornerRadius = 39.5f;
    [self.tableView reloadData];
    [self dismiss:picker];
    
}

- (void)dismiss:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//个人资料
-(void)requestPersonDocumentList{
    
    [[GPClient shareGPClient]REquestByPostWithPath:XB_PersonalInfo Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

//删除签名
-(void)requestDeleteSign
{
    [[GPClient shareGPClient]REquestByPostWithPath:XB_DeleteSign Parameters:nil Delegate:self SerialNum:9 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}


//是否隐藏号码
-(void)IsNotHiddenNumber{
    
    NSDictionary * parametersDic = @{@"IsMobileHide":[NSString stringWithFormat:@"%@",self.isMobileHide]};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_MobileHide Parameters:parametersDic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

#pragma mark  - 返回信息
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@" number %d resDic:%@   ",serialNum, responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum ==0) {
        self.docDic = [responceDic objectForKey:@"result"];
        self.isMobileHide = [NSString stringWithFormat:@"%@",[self.docDic objectForKey:@"isMobileHide"]];
        self.viewRptPer = [NSString stringWithFormat:@"%@",[self.docDic objectForKey:@"viewRptPer"]];
        
        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",[_docDic objectForKey:@"photoGraph"]]];
        if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
            self.userdatas.photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        }else{
            self.userdatas.photoGraph = nil;
        }
//        //绑定信息到腾讯服务器
//        [[TIMFriendshipManager sharedInstance] SetNickname:self.userdatas.userDspName succ:^() {
//            NSLog(@"SetNickname Succ");
//        } fail:^(int code, NSString * err) {
//            NSLog(@"SetNickname fail: code=%d err=%@", code, err);
//        }];
//        if ([NSString isEqualToNull:self.userdatas.photoGraph]) {
//            NSString * nicai = self.userdatas.photoGraph;
//            if ([NSString isEqualToNull:nicai]) {
//                [[TIMFriendshipManager sharedInstance] SetFaceURL:nicai succ:^() {
//                    NSLog(@"SetFaceURL Succ");
//                } fail:^(int code, NSString * err) {
//                    NSLog(@"SetFaceURL fail: code=%d err=%@", code, err);
//                }];
//            }
//        }

    }
    
    switch (serialNum) {
        case 0://
            self.personArray = [personDocModel personDocDatasWithUser:self.docDic];
            [self.tableView reloadData];
            break;
        case 1://
            
            break;
        case 2://
            [self requestPersonDocumentList];
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改头像成功", nil) duration:2.0];
            break;
        case 3://
//            [self requestPersonDocumentList];
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改签名成功", nil) duration:2.0];
            break;
        case 6:
            [self requestPersonDocumentList];
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改性别成功", nil) duration:2.0];
            
            break;
        case 9:
            [self requestPersonDocumentList];
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除签名成功", nil) duration:2.0];
            break;
        default:
            break;
    }
    
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
    
}


//MARK:姓名
-(void)modifyName{
    [self panduanIntenet];
    if ([self.userdatas.experience isEqualToString:@"yes"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    ModifyNameViewController * name = [[ModifyNameViewController alloc]initWithType:@"name"];
    name.personDic = self.docDic;
    [self.navigationController pushViewController:name animated:YES];
    
}

-(void)modifyGener{
    [self panduanIntenet];
    if ([self.userdatas.experience isEqualToString:@"yes"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    self.alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"选择性别", nil) message:@"" canDismis:YES];
    
    UIView * showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 120)];
    showView.backgroundColor = [UIColor clearColor];
    self.alert.contentView = showView;
   NSArray * generArr = @[
      @{@"name":Custing(@"男", nil),@"tag":@"0"},
      @{@"name":Custing(@"女", nil),@"tag":@"1"}];
    for (int j = 0 ; j < [generArr count] ; j ++ ) {
        
        UIButton *chooseBtn = [GPUtils createButton:CGRectMake(0, j*40, WIDTH(self.alert), 40) action:nil delegate:self title:nil font:nil titleColor:nil];
        [chooseBtn addTarget:self action:@selector(chooseGenerBtn:) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn.tag = [[[generArr objectAtIndex:j] objectForKey:@"tag"] integerValue];
        [chooseBtn setBackgroundColor:[UIColor clearColor]];
        [showView addSubview:chooseBtn];
        
        UILabel * chooseLbl = [GPUtils createLable:CGRectMake(60, j*40, WIDTH(self.alert)-60, 40) text:[[generArr objectAtIndex:j]  objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [showView  addSubview:chooseLbl];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, j*40+40, WIDTH(self.alert), 0.5)];
        line.backgroundColor = Color_GrayLight_Same_20;
        [showView  addSubview:line];
        
    }
    NSString * generStr = [NSString stringWithFormat:@"%@",[self.docDic objectForKey:@"gender"]];

    self.manImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    if ([generStr isEqualToString:@"0"]) {
        self.manImage.image=[UIImage imageNamed:@"MyApprove_Select"];
    }else{
        self.manImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];

    }
    self.manImage.backgroundColor = [UIColor clearColor];
    [showView addSubview:self.manImage];
    
    self.womanImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 20, 20)];
    if ([generStr isEqualToString:@"1"]) {
        self.womanImage.image=[UIImage imageNamed:@"MyApprove_Select"];
    }else{
        self.womanImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        
    }
    self.womanImage.backgroundColor = [UIColor clearColor];
    [showView addSubview:self.womanImage];
    
    [self.alert show];
    
}

-(void)chooseGenerBtn:(UIButton *)btn{
    NSString * generStr=@"";
    switch (btn.tag) {
        case 0://宣南
            self.manImage.image=[UIImage imageNamed:@"MyApprove_Select"];
            self.womanImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
            generStr = @"0";
            break;
        case 1://玄女
            self.womanImage.image=[UIImage imageNamed:@"MyApprove_Select"];
            self.manImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
            generStr = @"1";
            break;
        default:
            break;
    }

    NSDictionary *dic = @{@"UserDspName":[NSString stringWithFormat:@"%@",[self.docDic objectForKey:@"userDspName"]],@"Gender":generStr};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",XB_UptUserName] Parameters:dic Delegate:self SerialNum:6 IfUserCache:NO];
    [self.alert dismiss];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//MARK:更换邮箱
-(void)modifyEmailAdress{
    [self panduanIntenet];
    if ([self.userdatas.experience isEqualToString:@"yes"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    ModifyNameViewController * name = [[ModifyNameViewController alloc]initWithType:@"email"];
    name.personDic = self.docDic;
    [self.navigationController pushViewController:name animated:YES];
    
}

//MARK:查看部门
-(void)pushDepartmentLook {
//    self.qunxian = @"NO";
//    departAndPositionViewController * depart = [[departAndPositionViewController alloc]initWithType:@"depart" result:[self.docDic objectForKey:@"userGroup"]];
//    [self.navigationController pushViewController:depart animated:YES];
}

//MARK:查看职位
-(void)pushPositionLook {
    self.qunxian = @"NO";
    departAndPositionViewController * depart = [[departAndPositionViewController alloc]initWithType:@"position" result:[self.docDic objectForKey:@"userGroup"]];
    [self.navigationController pushViewController:depart animated:YES];
}



-(void)pushModifyCardNumber{
    self.qunxian = @"YES";
    modifyCardNumberViewController * bankCard = [[modifyCardNumberViewController alloc]initWithType:@"bankCard"];
    bankCard.personDic = self.docDic;
    [self.navigationController pushViewController:bankCard animated:YES];
    
}

-(void)pushModifyIdentityCard{
    modifyCardNumberViewController * identityCard = [[modifyCardNumberViewController alloc]initWithType:@"identity"];
    identityCard.personDic = self.docDic;
    [self.navigationController pushViewController:identityCard animated:YES];
}


//MARK:号码隐藏
-(void)isHiddenNumber:(UISwitch *)btn{
    [self panduanIntenet];
    if ([self.userdatas.experience isEqualToString:@"yes"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    if ([self.isMobileHide isEqualToString:@"0"]) {
        self.isMobileHide = @"1";
        [self IsNotHiddenNumber];
        [self.numberHImage setOn:[self.isMobileHide boolValue] animated:YES];
    }
    else
    {
        self.isMobileHide = @"0";
        [self IsNotHiddenNumber];
        [self.numberHImage setOn:[self.isMobileHide boolValue] animated:NO];
    }
}



-(void)panduanIntenet{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
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
