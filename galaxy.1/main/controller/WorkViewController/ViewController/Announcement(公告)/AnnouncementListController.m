//
//  AnnouncementListController.m
//  galaxy
//
//  Created by hfk on 2018/2/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AnnouncementListController.h"
#import "AnnouncementListModel.h"
#import "AnnouncementListCell.h"
#import "AnnouncementFormController.h"
#import "AnnouncementLookController.h"

@interface AnnouncementListController ()<GPClientDelegate>
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)AnnouncementListCell *cell;
@property(nonatomic,assign)BOOL requestType;
@property(nonatomic,assign)BOOL isManager;//是否管理员
@property(nonatomic,strong)NSString *str_url;//是否管理员
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView * dockView;


@end

@implementation AnnouncementListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"公告", nil) backButton:YES ];
    self.isManager = [self.userdatas.userRole containsObject:@"2"];
    [self updateView];
}
-(void)updateView{
    if (self.isManager) {
        _str_url=[NSString stringWithFormat:@"%@",GetAllNoticesList];
        [self.tableView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top);
            make.left.equalTo(self.view.left);
            make.width.equalTo(self.view.width);
            make.bottom.equalTo(self.view.bottom).offset(@-50);
        }];
        self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
        self.dockView.userInteractionEnabled=YES;
        [self.view addSubview:self.dockView];
        [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@50);
        }];
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"发公告", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                AnnouncementFormController *vc=[[AnnouncementFormController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }else{
        _str_url=[NSString stringWithFormat:@"%@",GetNoticesList];
        [self.tableView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        [self requestAnnounceList];
    }
    _requestType=YES;
}

#pragma mark 添加网络数据
-(void)requestAnnounceList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@"20"};
    [[GPClient shareGPClient]REquestByPostWithPath:_str_url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if (self.currPage == 1) {
                [self.resultArray removeAllObjects];
            }
            [self dealWithData];
            [self createNOdataView];
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            if ([_resultDict[@"result"]floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
                self.currPage=1;
                [self requestAnnounceList];
            }
        }
            break;
       default:
            break;
    }
}
//MARK:数据处理
-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            AnnouncementListModel *model=[[AnnouncementListModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            AnnouncementListModel *model=[[AnnouncementListModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}
//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AnnouncementListCell cellHeightWithObj:self.resultArray[indexPath.section]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"AnnouncementListCell"];
    if (_cell==nil) {
        _cell=[[ AnnouncementListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnnouncementListCell"];
    }
    [_cell configCellWithModel:self.resultArray[indexPath.section]];
    return _cell;
}
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return _isManager;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementListModel *model=self.resultArray[indexPath.section];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSString *url=[NSString stringWithFormat:@"%@", DELETENOTICES];
        NSDictionary *parameters = @{@"Id":model.Id};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncementListModel *model=self.resultArray[indexPath.section];
    if (_isManager&&[model.status floatValue]==0) {
        AnnouncementFormController *vc=[[AnnouncementFormController alloc]init];
        vc.EditFormData=model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AnnouncementLookController *vc=[[AnnouncementLookController alloc]init];
        vc.str_LookId=[NSString isEqualToNull:model.Id]?[NSString stringWithFormat:@"%@",model.Id]:@"";
        [self.navigationController pushViewController:vc animated:YES];
    }
 
}
-(void)loadData{
    [self requestAnnounceList];
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有公告哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
