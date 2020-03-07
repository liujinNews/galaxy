//
//  ForStandardNewViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/7/5.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ForStandardNewViewController.h"
#import "InstructionsViewController.h"
#import "LookForStandardViewController.h"

@interface ForStandardNewViewController ()<GPClientDelegate>

@property (nonatomic, strong) UIView *view_AllOwance;
@property (nonatomic, strong) UIScrollView *scr_RootView;
@property (nonatomic, strong) NSDictionary *dic_AllOwance;

@end

@implementation ForStandardNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dic_AllOwance = [NSDictionary dictionary];
    [self updateNavbar];
    [self requestGetStdAllowanceV2];
}

#pragma mark function
-(void)updateNavbar
{
    [self setTitle:@"" backButton:NO];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:(CGRectMake(0,0, 40, 40))];
    [backButton setImage:[UIImage imageNamed:@"NavBarImg_GoBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(ReturnLayerOf:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    [titleView addSubview:backButton];
    
    CGSize size = [NSString sizeWithText:Custing(@"报销标准", nil) font:Font_Important_18_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(45, 0, Main_Screen_Width - 102, HEIGHT(titleView)) text:Custing(@"报销标准", nil) font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    titleLa.backgroundColor = [UIColor clearColor];
    [titleView addSubview:titleLa];
    
    UIButton * rightSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(titleView)/2+size.width/2-8, HEIGHT(titleView)/2-16.5, 33, 33)];
    [rightSearchBtn addTarget:self action:@selector(aboutEditPosition:) forControlEvents:UIControlEventTouchUpInside];
    [rightSearchBtn setImage:GPImage(@"my_positionQ") forState:UIControlStateNormal];
    rightSearchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [titleView addSubview:rightSearchBtn];
}

-(void)createMainView{
    _scr_RootView = [[UIScrollView alloc]init];
    [self.view addSubview:_scr_RootView];
    [_scr_RootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    _view_AllOwance = [[UIView alloc]init];
    _view_AllOwance.backgroundColor = Color_WhiteWeak_Same_20;
    [_scr_RootView addSubview:_view_AllOwance];
    [_view_AllOwance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scr_RootView.top).offset(@10);
        make.left.equalTo(self.scr_RootView.left);
        make.right.equalTo(self.scr_RootView.right);
        make.width.equalTo(self.scr_RootView.width);
    }];
    [self createAllowance];
}

-(void)createAllowance{
    NSArray *arr = _dic_AllOwance[@"result"][@"items"];
    NSInteger height =  arr.count * 50;
    [_view_AllOwance mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [_scr_RootView setContentSize:CGSizeMake(Main_Screen_Width, height)];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, (i)*50, Main_Screen_Width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [_view_AllOwance addSubview:view];
        UILabel *lab = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-30, 50) text:dic[@"expenseType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:lab];
        UIButton *btn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 50) action:@selector(Allowance_click:) delegate:self];
        btn.tag = i;
        [view addSubview:btn];
        [view addSubview:[self createLineViewOfHeight:49.5]];
    }
}

-(void)Allowance_click:(UIButton *)btn{
    LookForStandardViewController *look = [[LookForStandardViewController alloc]init];
    look.dic = _dic_AllOwance[@"result"][@"items"][btn.tag];
    [self.navigationController pushViewController:look animated:YES];
}

//获取员工补贴标准列表
-(void)requestGetStdAllowanceV2 {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",StdGetAllowanceV2] Parameters:@{@"PageIndex":@1,@"PageSize":@999} Delegate:self SerialNum:2 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}


#pragma mark action
-(void)ReturnLayerOf:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)aboutEditPosition:(UIButton *)btn{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"ForStand"];
    [self.navigationController pushViewController:INFO animated:YES];
}

#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 2) {
        _dic_AllOwance = responceDic;
        [self createMainView];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
