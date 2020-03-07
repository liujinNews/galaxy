//
//  helpAndFeedbackViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "newbieGuideViewController.h"
#import "opinionFeedbackVController.h"
#import "CommonproblemController.h"
#import "helpAndFeedbackViewController.h"

@interface helpAndFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * helpArray;
@property (nonatomic,strong)NSString * contactQQ;


@end

@implementation helpAndFeedbackViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestSend];

    self.helpArray = @[@{@"helpImage":@"Newbie",@"helpType":Custing(@"新手入门", nil)},@{@"helpImage":@"managementManual",@"helpType":Custing(@"管理手册", nil)},@{@"helpImage":@"my_CommonProblems",@"helpType":Custing(@"常见问题", nil)},@{@"helpImage":@"my_OpinionsFeedback",@"helpType":Custing(@"意见反馈", nil)}];
    //@{@"helpImage":@"my_OnlineConsulting",@"helpType":Custing(@"在线客服", nil)}
    [self setTitle:Custing(@"帮助与反馈", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.helpArray count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView * helpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 24, 24)];
        helpImage.image = GPImage([self.helpArray[indexPath.row] objectForKey:@"helpImage"]);
        [cell.contentView addSubview:helpImage];
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(54, 45.5, Main_Screen_Width-69, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lineView];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-90, 46) text:[self.helpArray[indexPath.row] objectForKey:@"helpType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name=self.helpArray[indexPath.row][@"helpType"];
    if ([name isEqualToString:Custing(@"新手入门", nil)]) {
       //newbieGuideViewController.h
        newbieGuideViewController *commonVC=[[newbieGuideViewController alloc]initWithType:@"newbie"];
        [self.navigationController pushViewController:commonVC animated:YES];
    }else if ([name isEqualToString:Custing(@"管理手册", nil)]){
        newbieGuideViewController *commonVC=[[newbieGuideViewController alloc]initWithType:@"managementManual"];
        [self.navigationController pushViewController:commonVC animated:YES];
    }
    else if ([name isEqualToString:Custing(@"常见问题", nil)]){
        CommonproblemController *commonVC=[[CommonproblemController alloc]init];
        [self.navigationController pushViewController:commonVC animated:YES];
    }else if ([name isEqualToString:@"意见反馈"]){
        opinionFeedbackVController * opinion = [[opinionFeedbackVController alloc]init];
        [self.navigationController pushViewController:opinion animated:YES];
    }else if ([name isEqualToString:Custing(@"在线客服", nil)]){
        
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            if ([self.contactQQ isEqualToString:@""]) {
                self.contactQQ = @"4008635799";
            }
            
            NSString *urlStr =[NSString stringWithFormat:@"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=%@",self.contactQQ];
            NSURL *url = [NSURL URLWithString:urlStr];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            webView.delegate = self;
            [webView loadRequest:request];
            [self.view addSubview:webView];
            
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                        message:Custing(@"该设备不支持QQ功能", nil)
                                                       delegate:nil
                                              cancelButtonTitle:Custing(@"确定", nil)
                                              otherButtonTitles:nil,nil];
            [alert show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)requestSend{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",about] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    //FDE55D29E567D879//
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSDictionary * result = [responceDic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    if (![result isKindOfClass:[NSNull class]] && result != nil && result.count != 0){
        
        self.contactQQ = [NSString stringWithFormat:@"%@",[result objectForKey:@"contactQQ"]];
    }
    switch (serialNum) {
        case 0://
            [self.tableView reloadData];
            //[self createAboutView];
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
