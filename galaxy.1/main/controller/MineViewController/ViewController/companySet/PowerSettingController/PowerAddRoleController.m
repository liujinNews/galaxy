//
//  PowerAddRoleController.m
//  galaxy
//
//  Created by hfk on 2018/4/13.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PowerAddRoleController.h"

@interface PowerAddRoleController ()<GPClientDelegate,UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
@property (nonatomic, strong) UITextField *txf_RoleName;
@property (nonatomic, strong) UITextField *txf_RoleNameEn;
@property (nonatomic, strong) UITextView *txv_Description;

@end

@implementation PowerAddRoleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self createMainView];
    if (self.model_Edit) {
        [self setTitle:Custing(@"修改角色", nil) backButton:YES];
    }else{
        [self setTitle:Custing(@"添加角色", nil) backButton:YES];
    }
}
#pragma mark - function
-(void)createMainView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
    UIView *NameView=[[UIView alloc]init];
    NameView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NameView];
    [NameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_RoleName=[[UITextField alloc]init];
    [NameView addSubview:[[SubmitFormView alloc]initBaseView:NameView WithContent:_txf_RoleName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"角色名称", nil) WithTips:Custing(@"请输入角色名称", nil)  WithInfodict:@{@"value1":self.model_Edit.roleName}]];
    
    UIView *NameEnView=[[UIView alloc]init];
    NameEnView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NameEnView];
    [NameEnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NameView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_RoleNameEn=[[UITextField alloc]init];
    [NameEnView addSubview:[[SubmitFormView alloc]initBaseView:NameEnView WithContent:_txf_RoleNameEn WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"角色英文名", nil) WithTips:Custing(@"请输入角色英文名", nil) WithInfodict:@{@"value1":self.model_Edit.roleNameEn}]];

    
    UIView *DescriptionView=[[UIView alloc]init];
    DescriptionView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:DescriptionView];
    [DescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NameEnView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txv_Description=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:DescriptionView WithContent:_txv_Description WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"描述", nil) WithTips:Custing(@"请输入描述", nil) WithInfodict:@{@"value1":self.model_Edit.Description}];
    [DescriptionView addSubview:view];
    
    UIView *LoadView=[[UIView alloc]init];
    LoadView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:LoadView];
    [LoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DescriptionView.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    
    UIButton * importBtn = [GPUtils createButton:CGRectMake(15, 15, Main_Screen_Width-30, 45) action:@selector(requestGetClient) delegate:self title:Custing(@"确认", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [importBtn setBackgroundColor:Color_Blue_Important_20];
    importBtn.layer.cornerRadius = 15.0f;
    [LoadView addSubview:importBtn];
    
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(LoadView.bottom);
    }];
    [self.contentView layoutIfNeeded];
}

-(void)requestGetClient{
    if (![NSString isEqualToNull:self.txf_RoleName.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入角色名称", nil) duration:1.0];
        return;
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url;
    NSDictionary *parameters;
    if (self.model_Edit) {
        url=[NSString stringWithFormat:@"%@",UPDATEROLE];
        parameters=@{
                     @"RoleId":[NSString isEqualToNull:self.model_Edit.roleId]?self.model_Edit.roleId:@"0",
                     @"RoleName":self.txf_RoleName.text,
                     @"RoleNameEn":self.txf_RoleNameEn.text,
                     @"Description":self.txv_Description.text
                     };
    }else{
        url=[NSString stringWithFormat:@"%@",INSERTROLE];
        parameters=@{
                     @"RoleName":self.txf_RoleName.text,
                     @"RoleNameEn":self.txf_RoleNameEn.text,
                     @"Description":self.txv_Description.text
                     };
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]] isEqualToString:@"-1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"角色已存在", nil) duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_model_Edit?Custing(@"修改成功", nil):Custing(@"添加成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        default:
            break;
    }
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
