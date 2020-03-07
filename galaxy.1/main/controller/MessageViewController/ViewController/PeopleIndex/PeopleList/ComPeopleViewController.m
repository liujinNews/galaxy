//
//  ComPeopleViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ComPeopleViewController.h"
#import "ComPeopleModel.h"
#import "ComPeopleTableViewCell.h"
#import "ComGroupTableViewCell.h"
#import "PeopleInfoViewController.h"


@interface ComPeopleViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong)NSDictionary *resultDict;//网络请求数据

@property (nonatomic, strong)NSMutableArray *showArray;//显示数据

@property (nonatomic, strong)NSMutableArray *showGroupArray;//显示组数据

@property (nonatomic, strong)NSMutableArray *showUserArray;//显示用户数据

@property (nonatomic, copy)NSString *searchtext;//搜索框文字

@property (nonatomic, assign) int groupcound;

@end

@implementation ComPeopleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.nowGroup) {
        [self getGroupId];
    }else{
        [self createView];
    }
 
}

-(void)getGroupId{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcosummary] Parameters:nil Delegate:self SerialNum:5 IfUserCache:NO];
}

-(void)createView{
    [self setTitle:[NSString isEqualToNull:_nowGroupname]?_nowGroupname:@"" backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self.btn_rootBtn setTitle:[NSString isEqualToNull:self.userdatas.company]?self.userdatas.company:@"" forState:UIControlStateNormal];
    _sea_Search.placeholder = Custing(@"搜索姓名", nil);
    //    [self viewloading];
    if (self.arrGroup){
        _groupcound = (int)self.arrGroup.count ;
    }else{
        _groupcound = 0;
    }
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]]&&![[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]isEqualToString:@"0"])
    {
        [self setTitle:Custing(@"选择部门", nil) backButton:YES ];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(rightBtn_Click:)];
        
    }
    
    self.tab_PeopleTable.tableFooterView = [[UIView alloc]init];
    self.tab_PeopleTable.delegate = self;
    self.tab_PeopleTable.dataSource = self;
    self.tab_PeopleTable.rowHeight = 49;
    self.tab_PeopleTable.backgroundColor = Color_White_Same_20;
    self.sea_Search.delegate = self;
    self.imgView.backgroundColor = [XBColorSupport supportimgLine];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setNavigationController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_groupcound<_arrGroup.count) {
        for (int i = (int)_arrGroup.count; i>=0; i--) {
            if (_groupcound<_arrGroup.count) {
                [_arrGroup removeLastObject];
            }
        }
    }
    if ([NSString isEqualToNull:_parentId]) {
        [self getParentGroup];
    }
    [self viewloading];
    //请求数据
    [self getPeopleData];
    //创建滚动视图
    [self parsingGroup];
    
}

-(void)back:(UIButton *)btn
{
    if (self.userdatas.PeoplePage!=0) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.userdatas.PeoplePage-1] animated:YES];
    }else{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark - 方法
-(void)viewloading
{
    if (![NSString isEqualToNull:_nowGroup]) {
        _nowGroup = self.userdatas.groupid;
        _nowGroupname = self.userdatas.groupname;
    }
    if (!self.arrGroup) {
        _arrGroup = [[NSMutableArray alloc]init];
    }
}

-(void)parsingGroup
{
    if (_arrGroup.count>0) {
        _btn_rootBtn.userInteractionEnabled = YES;
//        _btn_rootBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _btn_rootBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        float width = Main_Screen_Width;
        UIButton *btns = _btn_rootBtn;
        for (int i = 0; i<_arrGroup.count; i++) {
            NSDictionary *dic = _arrGroup[i];
            CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"  >  %@",[dic objectForKey:@"name"] ] font:Font_cellTitle_14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UIButton *btn = [GPUtils createButton:CGRectMake(X(btns)+WIDTH(btns),Y(btns),size.width,HEIGHT(btns)) action:@selector(GroupClick:) delegate:self title:[NSString stringWithFormat:@"  >  %@",[dic objectForKey:@"name"]] font:Font_cellTitle_14 titleColor:Color_Blue_Important_20];
            [btn setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateHighlighted];
//            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            btn.tag = i;
            if (i == _arrGroup.count-1) {
                btn.userInteractionEnabled = NO;
                [btn setTitleColor:Color_cellPlace forState:UIControlStateNormal];
            }
            [_scr_deparScroll addSubview:btn];
            width = X(btn)+WIDTH(btn);
            btns = btn;
        }
        _scr_deparScroll.contentSize = CGSizeMake(width<Main_Screen_Width?Main_Screen_Width:width, 44);
        _scr_deparScroll.backgroundColor = Color_form_TextFieldBackgroundColor;
        CGPoint offset = _scr_deparScroll.contentOffset;
        offset.x =width<Main_Screen_Width?0:width-Main_Screen_Width;
        [_scr_deparScroll setContentOffset:offset animated:YES];
    }
    else
    {
        _btn_rootBtn.userInteractionEnabled = NO;
    }
}



#pragma mark  获取数据
-(void)getPeopleData
{
    NSString *url=[NSString stringWithFormat:@"%@",getgroupmbr];
//    NSString *url=[NSString stringWithFormat:@"%@",getusers];
    
    NSDictionary *parameters = @{@"GroupId":_nowGroup};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)getsearchdata
{
    NSString *url=[NSString stringWithFormat:@"%@",getmbrs];
    NSDictionary *parameters = @{@"UserDspName":_searchtext};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

//获取当前部门的父部门
-(void)getParentGroup 
{
    NSString *url=[NSString stringWithFormat:@"%@",GetParentGroup];
    NSDictionary *parameters = @{@"ParentId":_nowGroup};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}

//获取新加入员工
-(void)getNewPeople
{
    NSString *url=[NSString stringWithFormat:@"%@",getnotactivatedusers];
    NSDictionary *parameters = @{};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
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
    NSArray *array =_resultDict[@"result"];
    _showUserArray = [[NSMutableArray alloc]init];
    ComPeopleModel *model ;
    for (int i = 0; i<array.count; i++) {
        model = [[ComPeopleModel alloc]initWithBydic:array[i]];
        [_showUserArray addObject:model];
    }
    [_tab_PeopleTable reloadData];
}

-(void)newPeopleData
{
    NSArray *array =_resultDict[@"result"];
    if (!_showArray) {
        _showArray = [[NSMutableArray alloc]init];
    }
    ComPeopleModel *model ;
    for (int i = 0; i<array.count; i++) {
        model = [[ComPeopleModel alloc]initWithBydic:array[i]];
        model.isNow = @"1";
        [_showArray addObject:model];
    }
    [self.tab_PeopleTable reloadData];
}

-(void)setgroupInfo
{
    NSArray *arr = _resultDict[@"result"];
    if (arr.count>1) {
        [_arrGroup removeAllObjects];
        NSDictionary *dic;
        for (int i = (unsigned)arr.count-2 ; i>=0; i--) {
            dic = arr[i];
            [_arrGroup addObject:@{@"id":dic[@"groupId"],@"name":dic[@"groupName"]}];
        }
        [self parsingGroup];
    }
}

#pragma mark - action //
//首页点击
- (IBAction)root_Click:(UIButton *)sender
{
    ComPeopleViewController *cpview = [[ComPeopleViewController alloc]init];
    cpview.arrGroup = [[NSMutableArray alloc]init];
    cpview.nowGroupname = self.userdatas.company;
    cpview.nowGroup = self.userdatas.companyId;
    cpview.ComPeopleViewControllerBlock = self.ComPeopleViewControllerBlock;
    [self.navigationController pushViewController:cpview animated:YES];
}


-(void)rightBtn_Click:(UIButton *)btn
{
    //编辑数据
    NSDictionary *dic = @{@"id":_nowGroup,@"name":_nowGroupname};
    if (self.delegate) {
        [self.delegate ComPeopleViewController_BtnClick:dic];
    }
    if (self.ComPeopleViewControllerBlock) {
        self.ComPeopleViewControllerBlock(dic);
    }
    NSLog(@"%@",dic);
    //声明通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //发送通知
    [center postNotificationName:@"edit_group"
                          object:self
                        userInfo:dic];
    [self performBlock:^{
        UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
        UINavigationController *nav = (UINavigationController *)window.rootViewController;
        UINavigationController *navi =  nav.childViewControllers[0];
        [self.navigationController popToViewController:navi.viewControllers[self.userdatas.PeoplePage-1] animated:YES];
    } afterDelay:0.5f];
    
}

//组头Button点击
-(void)GroupClick:(UIButton *)btn
{
    NSDictionary *dic;
    NSMutableArray *newarr = [[NSMutableArray alloc]init];
//    int a ;
    for (int i = 0; i<_arrGroup.count; i++) {
        dic = _arrGroup[i];
        [newarr addObject:dic];
        if (i==btn.tag) {
//            a = i+3;
            break;
        }
    }
    
    ComPeopleViewController *cpview = [[ComPeopleViewController alloc]init];
    cpview.arrGroup = newarr;
    cpview.nowGroup = dic[@"id"];
    cpview.nowGroupname = dic[@"name"];
    __weak typeof(self) weakSelf = self;
    cpview.ComPeopleViewControllerBlock = self.ComPeopleViewControllerBlock;
    [self.navigationController pushViewController:cpview animated:YES];
}

#pragma mark - 代理
#pragma mark  tableview 创建
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]]||![[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]isEqualToString:@"0"])
    {
        return _showGroupArray.count;
    }
    if (_showGroupArray.count>0) {
        
        if (section == 0) {
            return _showGroupArray.count;
        }
        else
        {
            return _showUserArray.count;
        }
    }
    return _showUserArray.count;
}

//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_showUserArray.count>0&&_showGroupArray.count>0) {
        if (![NSString isEqualToNull:[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]]||[[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]isEqualToString:@"0"])
        {
            return 2;
        }
        else
        {
            return 1;
        }
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
            image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 48.5, Main_Screen_Width, 0.5)];
        }
        else
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 48.5, Main_Screen_Width, 0.5)];
        }
        image.backgroundColor = Color_GrayLight_Same_20;
        [Cell addSubview:image];        return Cell;
    }
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]]||[[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]isEqualToString:@"0"])
    {
        ComPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:check];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ComPeopleTableViewCell" owner:self options:nil];
            cell = [nib lastObject];
        }
        cell.model = model;
        //添加一个线
        UIImageView *image;
        if (indexPath.row == _showUserArray.count-1) {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 48.5, Main_Screen_Width, 0.5)];
        }
        else
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(60, 48.5, Main_Screen_Width, 0.5)];
        }
        if (indexPath.row == 0 ) {
//            image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            
            UIImageView *ling = [[UIImageView alloc]initWithFrame:CGRectMake(60, 48.5, Main_Screen_Width, 0.5)];
            ling.backgroundColor = Color_GrayLight_Same_20;
            [cell addSubview:ling];
        }
        image.backgroundColor = Color_GrayLight_Same_20;
        [cell addSubview:image];
        
        if ([cell.model.isNow isEqualToString:@"1"]) {
            cell.img_rightImage.hidden = YES;
            UIButton *btn = [GPUtils createButton:CGRectMake(Main_Screen_Width-70, 10 ,40, 25) action:nil delegate:self title:@"同意" font:Font_cellTitle_14 titleColor:Color_form_TextFieldBackgroundColor];
            btn.tag = indexPath.row;
            btn.userInteractionEnabled = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"people_btn"] forState:UIControlStateNormal];
            [cell addSubview:btn];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
        return cell;
    }
    return [[UITableViewCell alloc]init];
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
        ComPeopleViewController *cpview = [[ComPeopleViewController alloc]init];
        cpview.nowGroup = model.groupId;
        cpview.nowGroupname = model.groupName;
        NSDictionary *dic = @{@"id":model.groupId,@"name":model.groupName?model.groupName:@""};
        [_arrGroup addObject:dic];
        cpview.arrGroup = _arrGroup;
        cpview.ComPeopleViewControllerBlock = self.ComPeopleViewControllerBlock;
        [self.navigationController pushViewController:cpview animated:YES];
    }
    else if([[NSString stringWithFormat:@"%ld",(long)self.userdatas.PeoplePage]isEqualToString:@"0"])
    {
        [self.view endEditing:YES];
        
        if (![NSString isEqualToNull:model.groupName]) {
            model.groupName = self.nowGroupname;
            PeopleInfoViewController *peopleinfo = [[PeopleInfoViewController alloc]init];
            peopleinfo.model = model;
            [self.navigationController pushViewController:peopleinfo animated:YES];
        }
        
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


#pragma mark 请求后响应请求  13 27 28 29
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
        switch (serialNum) {
            case 0:
                [self parsingData];
                break;
            case 1:
                [self searchData];
                break;
            case 3:
                [self newPeopleData];
                break;
            case 4:
                [self setgroupInfo];
                break;
            case 5:
            {
                NSDictionary * result = [responceDic objectForKey:@"result"];
                self.userdatas.groupid = [result objectForKey:@"groupId"];
                [self.userdatas storeUserInfo];
                self.nowGroup = [NSString isEqualToNull:self.userdatas.groupid]?self.userdatas.groupid:self.userdatas.companyId;
                [self createView];
            }
                break;
            default:
                break;
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
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
