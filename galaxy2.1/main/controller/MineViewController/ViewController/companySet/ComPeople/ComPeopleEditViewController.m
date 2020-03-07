//
//  ComPeopleEditViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ComPeopleEditViewController.h"
#import "ComPeopleModel.h"
#import "ComPeopleEditTableViewCell.h"
#import "ComGroupTableViewCell.h"
#import "companyPeopleVController.h"
#import "AddPeopleViewController.h"
#import "AddDeparViewController.h"
#import "EditPeopleNewViewController.h"

@interface ComPeopleEditViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong)NSDictionary *resultDict;

@property (nonatomic, copy)NSString *searchtext;

@property (nonatomic, strong)NSMutableArray *showArray;
@property(nonatomic,strong)NSString *requestType;

@property (nonatomic, strong)NSMutableArray *showGroupArray;//显示组数据

@property (nonatomic, strong)NSMutableArray *showUserArray;//显示用户数据

@property (nonatomic, assign) int groupcound;

@end

@implementation ComPeopleEditViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_groupcound<_arrGroup.count) {
        for (int i = (int)_arrGroup.count; i>=0; i--) {
            if (_groupcound<_arrGroup.count) {
                [_arrGroup removeLastObject];
            }
        }
    }
    
    //创建滚动视图
    if ([_requestType isEqualToString:@"1"])
    {
        [self getPeopleData];
    }
    else
    {
        [self parsingGroup];
    }
    _requestType=@"1";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self setTitle:Custing(@"员工管理", nil) backButton:YES ];
    
    [self.btn_rootBtn setTitle:Custing(@"通讯录", nil) forState:UIControlStateNormal];
    [self.btn_addPeople setTitle:Custing(@"添加新成员", nil) forState:UIControlStateNormal];
    [self.btn_addDepar setTitle:Custing(@"添加子部门", nil) forState:UIControlStateNormal];
    [self.btn_editDepar setTitle:Custing(@"管理部门", nil) forState:UIControlStateNormal];
    
    [self.btn_rootBtn setTitle:self.userdatas.company forState:UIControlStateNormal];
    _requestType=@"0";
    [self viewloading];
    
    if (self.arrGroup)
    {
        _groupcound = (int)self.arrGroup.count ;
    }
    else
    {
        _groupcound = 0;
    }
    
        //请求数据
    [self getPeopleData];
    
    
    _lc_btn_addPeople_width.constant = -Main_Screen_Width/2;
    if (_arrGroup.count>0)
    {
        _lc_btn_addPeople_width.constant = -Main_Screen_Width/3*2;
    }
    
    self.tab_PeopleTable.tableFooterView = [[UIView alloc]init];
    self.tab_PeopleTable.rowHeight = 60;
    self.tab_PeopleTable.delegate = self;
    self.tab_PeopleTable.dataSource = self;
    self.tab_PeopleTable.backgroundColor = Color_White_Same_20;
    self.sea_Search.delegate = self;
    self.sea_Search.placeholder = Custing(@"搜索姓名", nil);
    self.scr_deparScroll.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.view_scrLine.backgroundColor = [XBColorSupport supportLineColor];
}


-(void)viewloading
{
    if (![NSString isEqualToNull:_nowGroup]) {
        _nowGroup = self.userdatas.groupid;
    }
    if (!self.arrGroup) {
        _arrGroup = [[NSMutableArray alloc]init];
    }
}

-(void)parsingGroup
{
    if (_arrGroup.count>0) {
        _btn_rootBtn.userInteractionEnabled = YES;
        float width = Main_Screen_Width;
        UIButton *btns = _btn_rootBtn;
        for (int i = 0; i<_arrGroup.count; i++) {
            NSDictionary *dic = _arrGroup[i];
            CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"  >  %@",[dic objectForKey:@"name"] ] font:Font_cellTitle_14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UIButton *btn = [GPUtils createButton:CGRectMake(X(btns)+WIDTH(btns),Y(btns),size.width,HEIGHT(btns)) action:@selector(GroupClick:) delegate:self title:[NSString stringWithFormat:@"  >  %@",[dic objectForKey:@"name"]] font:Font_cellTitle_14 titleColor:Color_Blue_Important_20];
            [btn setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateHighlighted];
            btn.tag = i;
            if (i == _arrGroup.count-1) {
                btn.userInteractionEnabled = NO;
                [btn setTitleColor:Color_cellPlace forState:UIControlStateNormal];
            }
            [_scr_deparScroll addSubview:btn];
            width = X(btn)+WIDTH(btn);
            btns = btn;
        }
        
        
        _scr_deparScroll.contentSize = CGSizeMake(width<Main_Screen_Width-60?Main_Screen_Width-60:width , 44);
        
        CGPoint offset = _scr_deparScroll.contentOffset;
        offset.x =width<Main_Screen_Width?0:width-Main_Screen_Width;
        [_scr_deparScroll setContentOffset:offset animated:YES];
    }
    else
    {
        _scr_deparScroll.contentSize = CGSizeMake(Main_Screen_Width-60, 44);
        _btn_rootBtn.userInteractionEnabled = NO;
    }
}

-(void)back:(UIButton *)btn
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)GroupClick:(UIButton *)btn
{
    NSDictionary *dic;
    NSMutableArray *newarr = [[NSMutableArray alloc]init];
    int a ;
    for (int i = 0; i<_arrGroup.count; i++) {
        dic = _arrGroup[i];
        [newarr addObject:dic];
//        if (i==btn.tag) {
//            a = i+3;
//            break;
//        }
    }
    ComPeopleEditViewController *cpview = [[ComPeopleEditViewController alloc]init];
    cpview.arrGroup = newarr;
    cpview.nowGroup = dic[@"id"];
    
    [self.navigationController pushViewController:cpview animated:YES];
}

- (IBAction)root_Click:(UIButton *)sender
{
    ComPeopleEditViewController *cpview = [[ComPeopleEditViewController alloc]init];
    cpview.arrGroup = [[NSMutableArray alloc]init];
    cpview.nowGroup = self.userdatas.companyId;
    [self.navigationController pushViewController:cpview animated:YES];
}

#pragma mark - tableview 创建
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0&&_showGroupArray.count>0) {
        return _showGroupArray.count;
    }
    return _showUserArray.count;
}

//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_showUserArray.count>0&&_showGroupArray.count>0) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *check = @"cell";
    ComPeopleModel *model;
    if (indexPath.section == 0&&_showGroupArray.count>0) {
        model =_showGroupArray[indexPath.row];
    }
    else
    {
        model = _showUserArray[indexPath.row];
    }
    if ([NSString isEqualToNull:model.groupId]) {
        ComGroupTableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:check];
        if (!Cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ComGroupTableViewCell" owner:self options:nil];
            Cell = [nib lastObject];
        }
        Cell.model = model;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
        UIImageView *image;
        if (indexPath.section == 0&&_showGroupArray.count>0&&indexPath.row == _showGroupArray.count-1) {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, Main_Screen_Width, 0.5)];
        }
        else
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 59.5, Main_Screen_Width, 0.5)];
        }
        image.backgroundColor = Color_GrayLight_Same_20;
        [Cell addSubview:image];
//        Cell.lab_Number.hidden = YES;
        return Cell;
    }
    
    ComPeopleEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:check];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ComPeopleEditTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.model = model;
    //添加一个线
    UIImageView *image;
    if (indexPath.row == _showUserArray.count-1) {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, Main_Screen_Width, 0.5)];
    }
    else
    {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 59.5, Main_Screen_Width, 0.5)];
    }
    image.backgroundColor = Color_GrayLight_Same_20;
    [cell addSubview:image];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComPeopleModel *model;
    if (indexPath.section == 0&&_showGroupArray.count>0) {
        model =_showGroupArray[indexPath.row];
    }
    else
    {
        model = _showUserArray[indexPath.row];
    }
    if ([NSString isEqualToNull:model.groupId]) {
        ComPeopleEditViewController *cpview = [[ComPeopleEditViewController alloc]init];
        cpview.nowGroup = model.groupId;
        NSDictionary *dic = @{@"id":model.groupId,@"name":model.groupName?model.groupName:@"",@"code":model.groupCode?model.groupCode:[NSNull null],@"level":model.groupLevel?model.groupLevel:[NSNull null],@"isBranch":model.isBranch};
        [_arrGroup addObject:dic];
        cpview.arrGroup = _arrGroup;
        [self.navigationController pushViewController:cpview animated:YES];
    }
    else
    {
        EditPeopleNewViewController *editpeople = [[EditPeopleNewViewController alloc]init];
        
        if ([NSString isEqualToNull:model.userId ])
        {
            editpeople.userId = model.userId;
        }
        else
        {
            editpeople.userId = model.requestorUserId;
        }
        editpeople.isNowPeople = 0;
        [self.navigationController pushViewController:editpeople animated:YES];
        
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self keyClose];
    _searchtext = searchBar.text;
    if ([_searchtext isEqualToString:@""]) {
        [self getPeopleData];
    }
    else
    {
        [self getsearchdata];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchtext = searchText;
    if ([_searchtext isEqualToString:@""]) {
        [self getPeopleData];
    }
    else
    {
        [self getsearchdata];
    }
}


-(void)getsearchdata
{
    NSString *url=[NSString stringWithFormat:@"%@",getmbrs];
    NSDictionary *parameters = @{@"UserDspName":_searchtext};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

- (IBAction)addPeople_click:(UIButton *)sender {
    EditPeopleNewViewController *add = [[EditPeopleNewViewController alloc]init];
    if (_arrGroup.count>0) {
        NSDictionary *dic = [_arrGroup lastObject];
        add.DeparTitle = dic[@"name"];
        add.DeparId = dic[@"id"];
        add.DeparCode = dic[@"code"];
    }
    add.isNowPeople = 2;
    [self.navigationController pushViewController:add animated:YES];
}


- (IBAction)addDepr_click:(UIButton *)sender {
    AddDeparViewController *adddepar = [[AddDeparViewController alloc]init];
    if (_arrGroup.count>0) {
        NSDictionary *dic = [_arrGroup lastObject];
        adddepar.DeparTitle = dic[@"name"];
        adddepar.DeparId = dic[@"id"];
        adddepar.DeparCode = dic[@"code"];
        adddepar.DeparLevel = dic[@"level"];
        adddepar.isBranch = [dic[@"isBranch"]integerValue];
    }
    else
    {
        adddepar.DeparId = self.userdatas.companyId;
        adddepar.DeparTitle = self.userdatas.company;
        adddepar.isBranch = 0;
    }
    [self.navigationController pushViewController:adddepar animated:YES];
}

- (IBAction)btn_editDepar_Click:(UIButton *)sender {
    AddDeparViewController *adddepar = [[AddDeparViewController alloc]init];
    if (_arrGroup.count>0) {
        NSDictionary *dic = [_arrGroup lastObject];
        adddepar.NowDeparName = dic[@"name"];
        adddepar.NowDeparId = dic[@"id"];
        adddepar.isBranch = [dic[@"isBranch"]integerValue];
        if (_arrGroup.count==1) {
            adddepar.DeparId = self.userdatas.companyId;
            adddepar.DeparTitle = self.userdatas.company;
        }
        else
        {
            NSDictionary *dict = [_arrGroup objectAtIndex:_arrGroup.count-2];
            adddepar.DeparTitle = dict[@"name"];
            adddepar.DeparId = dict[@"id"];
            adddepar.DeparCode = dict[@"code"];
            adddepar.DeparLevel = dict[@"level"];
        }
    }
    else
    {
        adddepar.DeparId = self.userdatas.groupid;
        adddepar.DeparTitle = self.userdatas.groupname;
    }
    adddepar.type = @"1";
    [self.navigationController pushViewController:adddepar animated:YES];
}


#pragma mark - 获取数据
-(void)getPeopleData
{
    NSString *url=[NSString stringWithFormat:@"%@",getgroupmbr];
    NSDictionary *parameters = @{@"GroupId":_nowGroup};
    //    NSDictionary *parameters = @{@"GroupId":@"13"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//请求后响应请求  13 27 28 29
-(void)requestSuccess:(NSDictionary*)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    else
    {
        if (serialNum == 1) {
            [self searchData];
        }
        else
        {
            [self parsingData];
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//解析数据
-(void)parsingData
{
    NSMutableDictionary *oneDic = _resultDict[@"result"];
    NSArray *group = oneDic[@"groups"];
    NSArray *grouombr = oneDic[@"groupMbrs"];
    _showArray = [[NSMutableArray alloc]init];
    _showUserArray = [[NSMutableArray alloc]init];
    _showGroupArray = [[NSMutableArray alloc]init];
    
    ComPeopleModel *model ;
    for (int i = 0 ; i<group.count; i++) {
        model = [[ComPeopleModel alloc]initWithBydic:group[i]];
        if ([model.showBranch integerValue]==1) {
            [_showGroupArray addObject:model];
        }
    }
    for (int i = 0; i<grouombr.count; i++) {
        model = [[ComPeopleModel alloc]initWithBydic:grouombr[i]];
        [_showUserArray addObject:model];
    }
    [self.tab_PeopleTable reloadData];
}



-(void)searchData
{
    NSArray *group = _resultDict[@"result"];
    if (_showUserArray==nil) {
        _showUserArray = [[NSMutableArray alloc]init];
    }
    if (_showGroupArray==nil) {
        _showGroupArray = [[NSMutableArray alloc]init];
    }
    [_showGroupArray removeAllObjects];
    [_showUserArray removeAllObjects];
    ComPeopleModel *model ;
    if (![group isEqual:[NSNull null]]) {
        for (int i = 0 ; i<group.count; i++) {
            model = [[ComPeopleModel alloc]initWithBydic:group[i]];
            [_showUserArray addObject:model];
        }
    }
    [self.tab_PeopleTable reloadData];
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
