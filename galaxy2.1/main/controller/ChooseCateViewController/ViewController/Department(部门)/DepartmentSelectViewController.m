//
//  DepartmentSelectViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/2/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "DepartmentSelectViewController.h"
#import "ComPeopleModel.h"

@interface DepartmentSelectViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

@property (nonatomic, strong) UIView *View_SelectDepartment;
@property (nonatomic, strong) UIScrollView *scr_deparScroll;

@property (nonatomic, strong) UIView *View_Content;
@property (nonatomic, strong) UITableView *tbv_Content;
@property (nonatomic, strong) UIButton *btn_Company;

@property (nonatomic, strong) NSString *str_GroupId;

@property (nonatomic, strong) NSMutableArray *arr_showGroup;//显示组数据
@property (nonatomic, strong) NSMutableArray *arr_showUser;//显示用户数据
@property (nonatomic, strong) NSDictionary *dic_Request;
@property (nonatomic, strong) NSMutableArray *arr_GroupTitle;

@end

@implementation DepartmentSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_Type == 2) {
        [self setTitle:Custing(@"选择部门和成员", nil) backButton:YES];
    }else{
        [self setTitle:Custing(@"选择发送范围", nil) backButton:YES];
    }
    self.view.backgroundColor = Color_White_Same_20;
    _str_GroupId = @"0";
    _arr_GroupTitle = [NSMutableArray array];
    [self initializeData];
    [self createMainView];
    [self requestGroupmbr];
}

#pragma mark - function
#pragma mark data
//初始化数据
-(void)initializeData {
    if (_arr_SelectData == nil) {
        _arr_SelectData = [NSMutableArray array];
    }
    _arr_showUser = [NSMutableArray array];
    _arr_showGroup = [NSMutableArray array];
    _dic_Request = [NSDictionary dictionary];
}

//解析数据
-(void)analysisRequestData
{
    NSMutableDictionary *oneDic = _dic_Request[@"result"];
    NSArray *group = oneDic[@"groups"];
    NSArray *grouombr = oneDic[@"groupMbrs"];
    
    _arr_showUser = [[NSMutableArray alloc]init];
    _arr_showGroup = [[NSMutableArray alloc]init];
    
    ComPeopleModel *model ;
    for (int i = 0 ; i<group.count; i++) {
        model = [[ComPeopleModel alloc]initWithBydic:group[i]];
        if ([model.showBranch integerValue]==1) {
            [_arr_showGroup addObject:model];
        }
    }
    for (int i = 0; i<grouombr.count; i++) {
        model = [[ComPeopleModel alloc]initWithBydic:grouombr[i]];
        [_arr_showUser addObject:model];
    }
    [_tbv_Content reloadData];
}

#pragma mark view
-(void)createMainView{
    _View_SelectDepartment = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    _scr_deparScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-24, 49)];
    [_View_SelectDepartment addSubview:_scr_deparScroll];
    _View_SelectDepartment.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:_View_SelectDepartment];
    
    [NSString stringWithId:self];
    _btn_Company = [GPUtils createButton:CGRectMake(0, 0, [NSString returnStringWidth:Custing(@"当前公司", nil) font:Font_Important_15_20], 49) action:nil delegate:self title:Custing(@"当前公司", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
    [_scr_deparScroll addSubview:_btn_Company];
    __weak typeof(self) weakSelf = self;
    [_btn_Company bk_whenTapped:^{
        for (UIView *view in [weakSelf.view subviews]) {
            [view removeFromSuperview];
        }
        [weakSelf.arr_GroupTitle removeAllObjects];
        weakSelf.str_GroupId = @"0";
        [weakSelf initializeData];
        [weakSelf createMainView];
        [weakSelf requestGroupmbr];
    }];
    
    _View_Content = [[UIView alloc]initWithFrame:CGRectMake(0, 49, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49)];
    _tbv_Content = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-59) style:UITableViewStylePlain];
    _tbv_Content.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbv_Content.delegate = self;
    _tbv_Content.dataSource = self;
    _tbv_Content.backgroundColor = Color_White_Same_20;
    [_View_Content addSubview:_tbv_Content];
    [self.view addSubview:_View_Content];
    
    UIButton *rigbtn = [UIButton new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:rigbtn title:Custing(@"确定", nil) titleColor:Color_Blue_Important_20 titleIndex:0 imageName:nil target:nil action:nil];
    [rigbtn bk_whenTapped:^{
        if (weakSelf.block) {
            weakSelf.block(weakSelf.arr_SelectData);
        }
        [weakSelf returnBack];
    }];
}

-(void)createGroupTitleView{
    float width = Main_Screen_Width-24;
    UIButton *btns = _btn_Company;
    for (int i = 0; i<_arr_GroupTitle.count; i++) {
        __block ComPeopleModel *model = _arr_GroupTitle[i];
        CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"  >  %@",model.groupName] font:Font_cellTitle_14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UIButton *btn = [GPUtils createButton:CGRectMake(X(btns)+WIDTH(btns),Y(btns),size.width,HEIGHT(btns)) action:nil delegate:self title:[NSString stringWithFormat:@"  >  %@",model.groupName] font:Font_cellTitle_14 titleColor:Color_Blue_Important_20];
        [btn setTitleColor:Color_GrayDark_Same_20 forState:UIControlStateHighlighted];
        btn.tag = i;
        if (i == _arr_GroupTitle.count-1) {
            btn.userInteractionEnabled = NO;
            [btn setTitleColor:Color_cellPlace forState:UIControlStateNormal];
        }
        [_scr_deparScroll addSubview:btn];
        width = X(btn)+WIDTH(btn);
        btns = btn;
        __weak typeof(self) weakSelf = self;
        [btn bk_whenTapped:^{
            for (UIView *view in [self.view subviews]) {
                [view removeFromSuperview];
            }
            [weakSelf.arr_GroupTitle addObject:model];
            weakSelf.str_GroupId = model.groupId;
            for (int i = 0; i<weakSelf.arr_GroupTitle.count; i++) {
                ComPeopleModel *new = weakSelf.arr_GroupTitle[i];
                if ([model.groupId isEqual:new.groupId]) {
                    [weakSelf.arr_GroupTitle removeObjectsInRange:NSMakeRange(i, weakSelf.arr_GroupTitle.count-i-1)];
                    break;
                }
            }
            [weakSelf initializeData];
            [weakSelf createMainView];
            [weakSelf requestGroupmbr];
            [weakSelf createGroupTitleView];
        }];
    }
    _scr_deparScroll.contentSize = CGSizeMake(width<Main_Screen_Width?Main_Screen_Width:width, 44);
    CGPoint offset = _scr_deparScroll.contentOffset;
    offset.x =width<Main_Screen_Width?0:width-Main_Screen_Width;
    [_scr_deparScroll setContentOffset:offset animated:YES];
}


#pragma mark network
-(void)requestGroupmbr
{
    NSString *url=[NSString stringWithFormat:@"%@",getgroupmbr];
    NSDictionary *parameters = @{@"GroupId":_str_GroupId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}








#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:error]?error:Custing(@"网络请求失败", nil) duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_Request = responceDic;
        [self analysisRequestData];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arr_showGroup.count>0) {
        if (section == 0) {
            return _arr_showGroup.count;
        }else{
            return _arr_showUser.count;
        }
    }
    return _arr_showUser.count;
}

//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_arr_showUser.count>0&&_arr_showGroup.count>0) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor = Color_White_Same_20;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComPeopleModel *model;
    if (indexPath.section == 0&&_arr_showGroup.count>0) {
        model = _arr_showGroup[indexPath.row];
    }else{
        model = _arr_showUser[indexPath.row];
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __block UIButton *btn_img = [GPUtils createButton:CGRectMake(12, 15.5, 18, 18) action:nil delegate:self normalImage:[UIImage imageNamed:@"MyApprove_UnSelect"] highlightedImage:[UIImage imageNamed:@"MyApprove_Select"]];
    [cell addSubview:btn_img];
    
    UILabel *_TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _TypeLabel.text = [NSString isEqualToNull:model.groupId]?[NSString stringWithFormat:@"%@%@",model.groupName,[NSString isEqualToNull:model.mbrs]?[NSString stringWithFormat:@"(%@)",model.mbrs]:@"(0)"]:model.userDspName;
    [cell addSubview:_TypeLabel];
    
    for (ComPeopleModel *models in _arr_SelectData) {
        if ([models.groupId isEqual:model.groupId]||[models.userDspName isEqual:model.userDspName]) {
            [btn_img setImage:[UIImage imageNamed:@"MyApprove_Select"] forState:UIControlStateNormal];
        }
    }
    __weak typeof(self) weakSelf = self;
    [btn_img bk_whenTapped:^{
        NSLog(@"%@", btn_img);
        if ([btn_img.imageView.image isEqual:[UIImage imageNamed:@"MyApprove_UnSelect"]]) {
            [btn_img setImage:[UIImage imageNamed:@"MyApprove_Select"] forState:UIControlStateNormal];
            BOOL IS = YES;
            for (ComPeopleModel *models in weakSelf.arr_SelectData) {
                if ([models.groupId isEqual:model.groupId]||[models.userDspName isEqual:model.userDspName]) {
                    IS = NO;
                }
            }
            if (IS) {
                [weakSelf.arr_SelectData addObject:model];
            }
        }else{
            [btn_img setImage:[UIImage imageNamed:@"MyApprove_UnSelect"] forState:UIControlStateNormal];
            NSMutableArray *discardedItems = [NSMutableArray array];
            for (ComPeopleModel *models in weakSelf.arr_SelectData) {
                if ([models.groupId isEqual:model.groupId]||[models.userDspName isEqual:model.userDspName]) {
                    [discardedItems addObject:models];
                }
            }
            [weakSelf.arr_SelectData removeObjectsInArray:discardedItems];
        }
        [weakSelf.tbv_Content reloadData];
    }];
    
    UIImageView *imgLine = [GPUtils createImageViewFrame:CGRectMake(12, 48.5, Main_Screen_Width-12, 0.5) imageName:@""];
    imgLine.backgroundColor = Color_LineGray_Same_20;
    [cell addSubview:imgLine];
    
    if (indexPath.section == 0&&_arr_showGroup.count>0) {
        if (_arr_showGroup.count-1==indexPath.row) {
            imgLine.frame = CGRectMake(0, 48.5, Main_Screen_Width, 0.5);
        }
    }else{
        if (_arr_showUser.count-1==indexPath.row) {
            imgLine.frame = CGRectMake(0, 48.5, Main_Screen_Width, 0.5);
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ComPeopleModel *model;
    if (indexPath.section == 0&&_arr_showGroup.count>0) {
        model = _arr_showGroup[indexPath.row];
    }
    else
    {
        model = _arr_showUser[indexPath.row];
    }
    if ([NSString isEqualToNull:model.groupId]) {
        for (UIView *view in [cell subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn_img = (UIButton *)view;
                if ([btn_img.imageView.image isEqual:[UIImage imageNamed:@"MyApprove_UnSelect"]]) {
                    for (UIView *view in [self.view subviews]) {
                        [view removeFromSuperview];
                    }
                    [_arr_GroupTitle addObject:model];
                    _str_GroupId = model.groupId;
                    [self initializeData];
                    [self createMainView];
                    [self requestGroupmbr];
                    [self createGroupTitleView];
                    break;
                }
            }
        }
    }else{
        for (UIView *view in [cell subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn_img = (UIButton *)view;
                if ([btn_img.imageView.image isEqual:[UIImage imageNamed:@"MyApprove_UnSelect"]]) {
                    [btn_img setImage:[UIImage imageNamed:@"MyApprove_Select"] forState:UIControlStateNormal];
                    BOOL IS = YES;
                    for (ComPeopleModel *models in _arr_SelectData) {
                        if ([models.groupId isEqual:model.groupId]||[models.userDspName isEqual:model.userDspName]) {
                            IS = NO;
                        }
                    }
                    if (IS) {
                        [_arr_SelectData addObject:model];
                    }
                }else if ([btn_img.imageView.image isEqual:[UIImage imageNamed:@"MyApprove_Select"]]) {
                    [btn_img setImage:[UIImage imageNamed:@"MyApprove_UnSelect"] forState:UIControlStateNormal];
                    NSMutableArray *discardedItems = [NSMutableArray array];
                    for (ComPeopleModel *models in _arr_SelectData) {
                        if ([models.groupId isEqual:model.groupId]||[models.userDspName isEqual:model.userDspName]) {
                            [discardedItems addObject:models];
                        }
                    }
                    [_arr_SelectData removeObjectsInArray:discardedItems];
                }
                [_tbv_Content reloadData];
            }
        }
    }
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
