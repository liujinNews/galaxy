//
//  CommonproblemController.m
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CommonproblemController.h"
#import "CommonproblemCell.h"
#import "DetailProbleViewController.h"
@interface CommonproblemController ()<UITableViewDataSource,UITableViewDelegate,GPClientDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *resultArray;//下载数据
@property(nonatomic,strong)CommonproblemCell *cell;
@property(nonatomic,strong)NSString *requestType;//区别是否重新刷新tableView
@end

@implementation CommonproblemController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if ([_requestType isEqualToString:@"0"]) {
        [_tableView reloadData];
    }
    _requestType=@"0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"常见问题", nil) backButton:YES ];
    [self createTableView];
    [self requsetCommonProblem];
    _requestType=@"1";
}

//MARK:创建tableView
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStylePlain];
    _tableView .delegate = self;
    _tableView .dataSource = self;
    _tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

//MARK:常见问题数据
-(void)requsetCommonProblem{
    NSString *url=[NSString stringWithFormat:@"%@",commandProblem];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0:
            _resultArray=responceDic[@"result"];
            [_tableView reloadData];
            break;
        case 1:
            break;
        default:
            break;
    }
    
    
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = _resultArray[indexPath.row];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"question"]]]) {
        CGSize size = [dict[@"question"] sizeCalculateWithFont:Font_cellContent_16 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        return 30+size.height;
    }else{
        return 30;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"CommonproblemCell"];
    if (_cell==nil) {
        _cell=[[CommonproblemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonproblemCell"];
    }
    [_cell configCellWithDict:_resultArray[indexPath.row]];
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailProbleViewController *detaiVC=[[DetailProbleViewController alloc]init];
    detaiVC.detailDict=_resultArray[indexPath.row];
    [self.navigationController pushViewController:detaiVC animated:YES];
    
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
