//
//  companyPeopleVController.m
//  galaxy
//
//  Created by 贺一鸣 on 15/12/14.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "companyPeopleVController.h"
#import "UIImageView+WebCache.h"

@interface companyPeopleVController ()<GPClientDelegate>

@property(nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UIView * DataView;
@property(nonatomic,assign)NSInteger height;

@property(nonatomic,strong)NSString * departmentStr;
@property(nonatomic,strong)NSString * positionStr;
@property(nonatomic,strong)NSString * phoneStr;
@property(nonatomic,strong)NSString * emailStr;
@property(nonatomic,strong)NSString * nameStr;
@property(nonatomic,strong)NSString * genderStr;
@property(nonatomic,strong)NSString * photoGraphStr;

@end

#define getemployeeinfo @"statistics/getemployeeinfo"


@implementation companyPeopleVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"个人资料", nil) backButton:YES ];
    [self getCityData];
//    [self createPersonlDataView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - 获取数据
-(void)getCityData
{
    NSString *url=[NSString stringWithFormat:@"%@",getemployeeinfo];
    NSDictionary *parameters = @{@"UserId":self.userid};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//请求后响应请求
-(void)requestSuccess:(NSDictionary*)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
//    NSLog(@"resDic:%@",responceDic);
    //    resultDict=[NSMutableDictionary dictionaryWithDictionary:responceDic];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    NSDictionary *dic = [responceDic objectForKey:@"result"];
    self.departmentStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"requestorDept"]];
    self.positionStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"jobTitle"]];
    self.phoneStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"contact"]];
    self.emailStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"email"]];
    self.nameStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"requestor"]];
    self.genderStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"gender"]];
    self.photoGraphStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photoGraph"]];
    [self createPersonlDataView];
}


-(void)createPersonlDataView{
    
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/320.0f;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.mainView .backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainView];
    
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.mainView), Main_Screen_Height*0.2338)];
    headerView.backgroundColor = [GPUtils colorHString:ColorGrayGround];
    UIImageView * AvatarIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"acquiesceAvatar"]];
    AvatarIV.frame=CGRectMake(WIDTH(headerView)/2-Main_Screen_Height*0.12/2, Main_Screen_Height*0.037, Main_Screen_Height*0.12, Main_Screen_Height*0.12);
    AvatarIV.backgroundColor = [UIColor clearColor];
    AvatarIV.layer.masksToBounds = YES;
    CGFloat Scale = [UIScreen mainScreen].bounds.size.height/480.0f;
    AvatarIV.layer.cornerRadius = 28.0f*Scale;
    [headerView addSubview:AvatarIV];
    [self.mainView addSubview:headerView];
    
    if (![self.photoGraphStr isEqualToString:@"(null)"]&&![self.photoGraphStr isEqualToString:@"<null>"]&&![self.photoGraphStr isEqualToString:@""]) {
        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:self.photoGraphStr];
        NSString * nicai = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        [AvatarIV sd_setImageWithURL:[NSURL URLWithString:nicai]];
    }
    
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(0, Y(AvatarIV)+HEIGHT(AvatarIV)+HEIGHT(headerView)*0.1, Main_Screen_Width*0.46, 20) text:self.nameStr font:Font_cellContent_16 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentRight];
    [headerView  addSubview:nameLa];
    if ([self.nameStr isEqualToString:@"<null>"]){
        nameLa.text = @"";
    }
    NSString * str;
    if ([self.genderStr isEqualToString:@"0"]) {
        str = Custing(@"男", nil);
    }else{
        str = Custing(@"女", nil);
    }
    
    UILabel * sexLa = [GPUtils createLable:CGRectMake(Main_Screen_Width*0.55, Y(AvatarIV)+HEIGHT(AvatarIV)+HEIGHT(headerView)*0.1, Main_Screen_Width-Main_Screen_Width*0.6, 20) text:str font:Font_cellContent_16 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentLeft];
    [headerView  addSubview:sexLa];
    if ([self.genderStr isEqualToString:@"<null>"]) {
        sexLa.text = @"";
    }
    
    
    self.height = Main_Screen_Height*0.3718;
    self.DataView = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width*0.085, Y(headerView)+HEIGHT(headerView)+Main_Screen_Height*0.02, WIDTH(self.mainView)-Main_Screen_Width*0.17, self.height*0.8)];
    [self.mainView addSubview:self.DataView];
    NSArray * viewArr = @[
                          @{@"name":Custing(@"部门", nil)},
                          @{@"name":Custing(@"职位", nil)},
                          @{@"name":Custing(@"手机号", nil)},
                          @{@"name":Custing(@"邮箱", nil)}];
    
    for (int j = 0 ; j < [viewArr count] ; j ++ ) {
        UILabel * number = [GPUtils createLable:CGRectMake(0, j*HEIGHT(self.DataView)/4+HEIGHT(self.DataView)/12, WIDTH(self.DataView)/4, 20) text:[[viewArr objectAtIndex:j] objectForKey:@"name"] font:Font_cellContent_16 textColor:[GPUtils colorHString:ColorGray] textAlignment:NSTextAlignmentLeft];
        [self.DataView  addSubview:number];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, j*HEIGHT(self.DataView)/4+HEIGHT(self.DataView)/12*3, WIDTH(self.DataView ), 1)];
        line.backgroundColor = [GPUtils colorHString:LineColor];
        [self.DataView  addSubview:line];
        
        
    }
    //部门
    UILabel * departmentLa = [GPUtils createLable:CGRectMake(WIDTH(self.DataView)/4, HEIGHT(self.DataView)/12, WIDTH(self.DataView)/4*3, 20) text:self.departmentStr font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentRight];
    departmentLa.backgroundColor = [UIColor clearColor];
    [self.DataView addSubview:departmentLa];
    if ([self.departmentStr isEqualToString:@"<null>"]){
        departmentLa.text = @"";
    }
    
    //职位
    UILabel * positionLa = [GPUtils createLable:CGRectMake(WIDTH(self.DataView)/4, HEIGHT(self.DataView)/12*4, WIDTH(self.DataView)/4*3, 20) text:self.positionStr font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentRight];
    positionLa.backgroundColor = [UIColor clearColor];
    [self.DataView addSubview:positionLa];
    if ([self.positionStr isEqualToString:@"<null>"]){
        positionLa.text = @"";
    }
    
    
    //手机号
    
    UIButton * phoneBtn = [GPUtils createButton:CGRectMake(WIDTH(self.DataView)-22*scale, HEIGHT(self.DataView)/12*6.5, 22*scale, 22*scale) action:@selector(callPhone:) delegate:self];
    phoneBtn.backgroundColor = [UIColor clearColor];
    
    UIImageView * listImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(phoneBtn), HEIGHT(phoneBtn))];
    listImage.image = GPImage(@"call");
    listImage.backgroundColor = [UIColor clearColor];
    [phoneBtn addSubview:listImage];
    [self.DataView addSubview:phoneBtn];
    
    
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(WIDTH(self.DataView)/4, HEIGHT(self.DataView)/12*7, WIDTH(self.DataView)/4*3-32*scale, 20) text:self.phoneStr font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentRight];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.DataView addSubview:phoneLa];
    if ([self.phoneStr isEqualToString:@"<null>"]){
        phoneLa.text = @"";
        phoneBtn.hidden = YES;
    }
    
    
    //邮箱
    UILabel * emailLa = [GPUtils createLable:CGRectMake(WIDTH(self.DataView)/5, HEIGHT(self.DataView)/12*10, WIDTH(self.DataView)/5*4, 20) text:self.emailStr font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentRight];
    emailLa.backgroundColor = [UIColor clearColor];
    [self.DataView addSubview:emailLa];
    if ([self.emailStr isEqualToString:@"<null>"]){
        emailLa.text = @"";
    }
    
}


//alertView的delegate方法（用于打电话）
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //可以调用系统的打电话功能
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phoneStr]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)callPhone:(UIButton *)btn{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                    message:Custing(@"该设备不支持电话功能", nil)
                                                   delegate:nil
                                          cancelButtonTitle:Custing(@"确定", nil)
                                          otherButtonTitles:nil,nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@",self.phoneStr];
        
        UIAlertView * lertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"呼叫", nil), nil];
        [lertView show];
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
