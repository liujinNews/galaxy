//
//  JoinGroupViewController.m
//  MyDemo
//
//  Created by tomzhu on 15/6/15.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "JoinGroupViewController.h"
#import "MySearchResultCell.h"
#import "GlobalData.h"
#import "UIResponder+addtion.h"
#import "MyCommOperation.h"
#import "UIViewAdditions.h"
#import "NSStringEx.h"
#import "MyGroupSearchResultCell.h"
#import "MJRefresh.h"
#import "Macro.h"

@interface JoinGroupViewController (){
    int _curPageIndex;
}

@property (nonatomic, strong)NSMutableArray* resultList;
@property (nonatomic, strong)NSString* myTitle;
@property (nonatomic, strong)NSString* placeholder;

@end

@implementation JoinGroupViewController

- (void)initConfig:(NSString*)title placeholder:(NSString *)placeholder{
    _myTitle = title;
    _placeholder = placeholder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_myTitle];
    _curPageIndex = 0;
    
    [self initSerachButton];
    [self initTableView];
    [self initSearchTextView];
    [self setupRefresh];
    
    self.resultList = [[NSMutableArray alloc] init];
}

- (void)initSerachButton{
    self.searchBtn.enabled = NO;
    self.searchBtn.clipsToBounds = YES;
    self.searchBtn.layer.borderWidth = 1.0f;
    self.searchBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.searchBtn.layer.cornerRadius = self.searchBtn.frame.size.height/2;
    [self.searchBtn.layer setMasksToBounds:YES];
    [self.searchBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)initSearchTextView{
    [self.searchTextView addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchTextView.delegate = self;
    self.searchTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placeholder];
}

- (void)initTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

//添加刷新控件
-(void)setupRefresh
{
    __weak UITableView *tableView = self.tableView;
    __weak JoinGroupViewController *weakSelf = self;
    
    // 上拉加载更多
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[TIMFriendshipManager sharedInstance] SearchUser:weakSelf.searchTextView.text pageIndex:_curPageIndex pageSize:kSearchPageSize succ:^(uint64_t totalNum, NSArray *data){
            _curPageIndex++;
            [weakSelf dealWithResult:weakSelf resultList:data];
        } fail:^(int code, NSString *err){
            NSLog(@"refresh fail:code = %d,err = %@",code,err);
        }];
        // 结束刷新
        [tableView.footer endRefreshing];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate<UITextField, UIAlertView>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (self.searchBtn.enabled) {
//        [self search:nil];
//    }
    [self.searchTextView resignFirstResponder];
    return NO;
}

static TIMGroupInfo *applyGroupInfo = nil;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView resignFirstResponder];
    if (buttonIndex == 1) {
        [[MyCommOperation shareInstance]
         joinGroup:applyGroupInfo.group msg:[alertView textFieldAtIndex:0].text
         succ:nil
         fail:nil];
    }
    applyGroupInfo = nil;
    return;
}


#pragma mark - delegate<UITableViewDataSource, UITableView>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* kResultCellId = @"SearchGroupResultCellId";
    TIMGroupInfo* model = [self.resultList objectAtIndex:indexPath.row];
    MyGroupSearchResultCell* resultCell = [self.tableView dequeueReusableCellWithIdentifier:kResultCellId];
    if (resultCell == nil) {
        resultCell = [[MyGroupSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultCellId];
        [resultCell updateModel:model];
        
        __weak JoinGroupViewController *weakSelf = self;
        resultCell.addBtnAction = ^(TIMGroupInfo* groupInfo){
            if (!groupInfo || !groupInfo.group) {
                return;
            }
            [weakSelf.searchTextView resignFirstResponder];
            applyGroupInfo = groupInfo;
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入验证信息"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确认", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert becomeFirstResponder];
            [alert show];
        };
    }
    [resultCell updateModel:model];
    return resultCell;
}

#pragma mark - private methods
- (void)search:(id)sender{
    [self becomeFirstResponder];
    [_resultList removeAllObjects];
    _curPageIndex = 0;
    [self.tableView reloadData];

    for (NSString *groupId in [GlobalData shareInstance].groupList) {
        if (!self.searchTextView.text || [self.searchTextView.text isEqualToString:groupId]) {
            TDDLogEvent(@"Error: can't join group twice");
            [self showPrompt:@"已加入该群"];
            return;
        }
    }
    __weak JoinGroupViewController *weakSelf = self;
    [[MyCommOperation shareInstance]
     getGroupPublicInfo:self.searchTextView.text
     succ:^(NSArray *data) {
         [weakSelf dealWithResult:weakSelf resultList:data];
     }
     fail:^(int code, NSString *err) {
         NSLog(@"search group fail:code ＝ %d,err ＝ %@",code,err);
         [weakSelf searchGroupWithName:weakSelf];
     }];
}

- (void)searchGroupWithName:(JoinGroupViewController *)weakSelf{
    [[TIMGroupManager sharedInstance] SearchGroup:weakSelf.searchTextView.text flags:TIM_GET_GROUP_BASE_INFO_FLAG_NAME custom:nil pageIndex:_curPageIndex pageSize:kSearchPageSize succ:^(uint64_t totalNum, NSArray *data){
        _curPageIndex++;
        [weakSelf dealWithResult:weakSelf resultList:data];
    } fail:^(int code, NSString *err){
        [self showAlert:@"搜索失败" andMsg:ERRORCODE_TO_ERRORDEC(code)];
    }];
}

- (void)dealWithResult:(JoinGroupViewController *)weakSelf resultList:(NSArray *)data{
    if (!data || !data.count) {
        return;
    }
    for (id obj in data) {
        TIMGroupInfo *groupInfo = (TIMGroupInfo*)obj;
        [_resultList addObject:groupInfo];
    }
    [weakSelf.tableView reloadData];
}

- (void)onValueChange:(id)sender{
    if (self.searchTextView.text.length>0) {
        self.searchBtn.enabled = YES;
        [self.searchBtn.layer setBackgroundColor:[UIColor blueColor].CGColor];
    }
    else{
        self.searchBtn.enabled = NO;
        [self.searchBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
    }
}

@end
