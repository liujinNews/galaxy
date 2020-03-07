//
//  createNewCoListViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/11/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "createNewCompanyViewController.h"
#import "createNewCoListViewController.h"

@interface createNewCoListViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSMutableArray * comArray;
@property (nonatomic,strong)NSDictionary * comDic;

@end

@implementation createNewCoListViewController

-(id)initWithType:(NSString *)type can:(NSDictionary *)canDic{
    self = [super init];
    if (self) {
        self.status = type;
        self.comDic = canDic;
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.status isEqualToString:@"jiaruXIANtwo"]) {
        [self setTitle:Custing(@"加入现有公司", nil) backButton:YES];
        [self createJoinHaveCoView];
    }else {
        [self setTitle:Custing(@"创建新企业", nil) backButton:YES];
        self.comArray = [NSMutableArray arrayWithArray:@[]];
        self.comArray = [self.comDic objectForKey:@"Corps"];
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStyleGrouped];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self.view addSubview:self.tableView];
    }
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    
    // Do any additional setup after loading the view.
}

//表单加载
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 39)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel * haveLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(headView)-30, 39) text:Custing(@"此手机号已绑定以下企业", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [headView  addSubview:haveLa];
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 80)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIButton * submitBtn = [GPUtils createButton:CGRectMake(15,20, WIDTH(headView)-30,45) action:@selector(pushCreateNewCompany:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"创建新企业", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [submitBtn setBackgroundColor:Color_Blue_Important_20];
    submitBtn.layer.cornerRadius = 11.0f;
    [headView addSubview: submitBtn];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
        
        //
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 48)];
        headerView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [cell.contentView addSubview:headerView];
        
        UIView * headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        headerLine.backgroundColor = Color_GrayLight_Same_20;
        [headerView addSubview:headerLine];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width-50, 46) text:[self.comArray[indexPath.row] objectForKey:@"companyName"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [headerView addSubview:geneLbl];
        
        
        UIView * footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, Main_Screen_Width, 0.5)];
        footLine.backgroundColor = Color_GrayLight_Same_20;
        [headerView addSubview:footLine];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)pushCreateNewCompany:(UIButton *)btn {
    createNewCompanyViewController * create = [[createNewCompanyViewController alloc]initWithType:self.status can:self.comDic];
    [self.navigationController pushViewController:create animated:YES];
}


//加入现有公司
-(void)nextJoinCompany:(UIButton *)btn {
    NSString * CorpCode = [NSString stringWithFormat:@"%@",[self.comDic objectForKey:@"CorpCode"]];
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"company/JoinCorp"] Parameters:@{@"CorpCode":CorpCode} Delegate:self SerialNum:0 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

-(void)createJoinHaveCoView {
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH(self.view), 50)];
    whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:whiteView];
    
    UILabel * comNaLa = [GPUtils createLable:CGRectMake(15, 0, 80, 50) text:Custing(@"公司名称", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    comNaLa.numberOfLines = 0;
    comNaLa.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:comNaLa];
    
    
    NSString * CompanyName = [NSString stringWithFormat:@"%@",[self.comDic  objectForKey:@"CompanyName"]];
    
    UILabel * joinCoLa = [GPUtils createLable:CGRectMake(95, 0, Main_Screen_Width - 110, 50) text:CompanyName font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
    joinCoLa.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:joinCoLa];
    
    
    UIButton * registerBtn = [GPUtils createButton:CGRectMake(15, 70, Main_Screen_Width-30, 45) action:@selector(nextJoinCompany:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"加入", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [registerBtn setBackgroundColor:Color_Blue_Important_20];
    registerBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:registerBtn];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    if (serialNum ==0) {
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]] isEqualToString:@"0"]) {
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
        
    }
    
    if (serialNum==0) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
        });
        
        
        
    }
    
    switch (serialNum) {
        case 0://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"加入成功，等待管理员同意加入公司", nil) duration:2.0];
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
