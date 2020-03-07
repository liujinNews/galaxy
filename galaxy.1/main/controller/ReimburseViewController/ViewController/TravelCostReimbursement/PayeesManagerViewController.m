//
//  PayeesManagerViewController.m
//  galaxy
//
//  Created by hfk on 2018/8/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PayeesManagerViewController.h"
#import "PayeesEditViewController.h"

@interface PayeesManagerViewController ()<GPClientDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary *resultDict;//下载成功字典
@property (nonatomic, assign) NSInteger totalPage;//系统分页数
@property (nonatomic, assign) BOOL requestType;
@property (nonatomic, strong)DoneBtnView * dockView;
@property (nonatomic, strong) NSString *searchAim;
@property (nonatomic, strong) UISearchBar * searchbar;


@end

@implementation PayeesManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"管理收款人", nil) backButton:YES ];
    [self createViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        self.currPage=1;
        [self loadData];
    }
    _requestType=YES;
}

-(void)createViews{
    _searchAim=@"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
//    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    if (@available(iOS 13.0, *)) {
        UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
        backGroundView.alpha = 0;
        self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
        UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
        self.searchbar.searchTextField.placeholder = [NSString stringWithFormat:@"%@%@",Custing(@"搜索", nil),Custing(@"收款人", nil)];
        [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
//        self.searchbar.placeholder = Custing(@"搜索费用类别", nil);
        self.searchbar.placeholder=[NSString stringWithFormat:@"%@%@",Custing(@"搜索", nil),Custing(@"收款人", nil)];
    }
    self.searchbar.delegate = self;
//    self.searchbar.placeholder=[NSString stringWithFormat:@"%@%@",Custing(@"搜索", nil),Custing(@"收款人", nil)];
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:self.searchbar];
    
    [self.tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-50);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"新增收款人", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        PayeesEditViewController * vc = [[PayeesEditViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

-(void)requestData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETOUTSIDEPAYEE];
    NSDictionary * dic =@{@"Type":self.isUser > 0 ? @"1":@"0" ,@"Name":_searchAim,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@20};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    [YXSpritesLoadingView dismiss];
    _resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    //下拉刷新
    if (self.currPage == 1 && self.isLoading == YES) {
        [self.resultArray removeAllObjects];
    }
    
    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            break;
        case 1:
        {
            if ([NSString isEqualToNull:_resultDict[@"result"]]&&[_resultDict[@"result"] floatValue]>0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
                self.currPage = 1;
                [self loadData];
            }
        }
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue];
    if (self.totalPage >= self.currPage) {
        [ChooseCateFreModel GetAllPayeesListDictionary:_resultDict Array:self.resultArray];
    }
}

-(void)loadData{
    [self requestData];
}

//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        view.backgroundColor =Color_form_TextFieldBackgroundColor;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
        lineview.backgroundColor =Color_GrayLight_Same_20;
        [view addSubview:lineview];
        return view;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];

    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    UILabel *label = [GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-24, 19) text:model.payee font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:label];
    
    UILabel *sub1 = [GPUtils createLable:CGRectMake(12, 29+2, Main_Screen_Width-24, 15) text:model.depositBank font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:sub1];
    
    UILabel *sub2 = [GPUtils createLable:CGRectMake(12, 29+2+15+2, Main_Screen_Width-24, 15) text:model.bankAccount font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:sub2];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    PayeesEditViewController *edit = [[PayeesEditViewController alloc]init];
    edit.model_Edit=model;
    [self.navigationController pushViewController:edit animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSString *url=[NSString stringWithFormat:@"%@",DELETEOUTSIDEPAYEE];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:@{@"Id":model.Id} Delegate:self SerialNum:1 IfUserCache:NO];
    }];
    return @[deleteRowAction];
}

#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        self.currPage=1;
        [self loadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    self.currPage=1;
    [self loadData];
}

//创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if ([NSString isEqualToNull:_searchAim]) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else{
        tips=Custing(@"您还没有收款人哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
