//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyAddFriendViewController.h"
#import "MySearchResultCell.h"
#import "MyFriendModel.h"
#import "GlobalData.h"
#import "UIResponder+addtion.h"
#import "MyCommOperation.h"
#import "UIViewAdditions.h"
#import "NSStringEx.h"
#import "MyInfoItemEditViewController.h"
#import "AccountHelper.h"
#import "Macro.h"
#import "MJRefresh.h"
#import "MyChatCell.h"

@interface MyAddFriendViewController ()
{
    int _curPageIndex;
}

@property (nonatomic, strong)NSMutableArray* resultList;
@property (nonatomic, strong)MyInfoItemEditViewController* applyWordEditViewController;
@property (nonatomic, strong)id reqFriendListRspObserver;
@property (nonatomic, strong)id reqBlackListRspObserver;

@end

@implementation MyAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"查找好友"];
    
    _curPageIndex = 0;
    
    self.resultList = [[NSMutableArray alloc] init];
    
    [self initSerachButton];
    [self initSearchTextView];
    [self initTableView];
    [self initObserver];
    [self setupRefresh];
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
    self.searchTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入电话号码/昵称/ID" attributes:@{NSForegroundColorAttributeName: RGB16(Color_Font_Lightgray)}];
    [self.searchTextView addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchTextView.delegate = self;
}

- (void)initTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)initObserver{
    self.reqFriendListRspObserver = [[NSNotificationCenter defaultCenter]
                                     addObserverForName:kMyNotificationReqFriendListResp
                                     object:nil
                                     queue:[NSOperationQueue mainQueue]
                                     usingBlock:^(NSNotification *note) {
                                         [self.tableView reloadData];
                                     }];
    self.reqBlackListRspObserver = [[NSNotificationCenter defaultCenter]
                                    addObserverForName:kMyNotificationReqBlackListResp
                                    object:nil
                                    queue:[NSOperationQueue mainQueue]
                                    usingBlock:^(NSNotification *note) {
                                        [self.tableView reloadData];
                                    }];
}

//添加刷新控件
-(void)setupRefresh
{
    __weak UITableView *tableView = self.tableView;
    __weak MyAddFriendViewController *weakSelf = self;
    
    // 上拉加载更多
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[TIMFriendshipManager sharedInstance] SearchUser:weakSelf.searchTextView.text pageIndex:_curPageIndex pageSize:kSearchPageSize succ:^(uint64_t totalNum, NSArray *data){
            TDDLogEvent(@"SearchFriend Succ");
            _curPageIndex++;
            if (data.count < 1) {
                return ;
            }
            [weakSelf updateSearchList:data];
        } fail:^(int code, NSString *err){
            NSLog(@"refresh fail:code = %d,err = %@",code,err);
        }];
        // 结束刷新
        [tableView.footer endRefreshing];
    }];
}

- (void)search:(id)sender{
    [self becomeFirstResponder];
    [_resultList removeAllObjects];
    [self.tableView reloadData];
    _curPageIndex = 0;
    
    NSString *accountID = self.searchTextView.text;
    NSString *phoneID = [self getPhoneUser:accountID];
    
    if ([accountID isEqualToString:[GlobalData shareInstance].me] ||
        [phoneID isEqualToString:[GlobalData shareInstance].me]) {
        TDDLogEvent(@"Error: can't add yourself");
        [self showPrompt:@"不能添加自己为好友"];
        return;
    }
    
    __weak MyAddFriendViewController *weakSelf = self;

    NSArray *accountIDs = @[accountID];
    NSArray *phoneIDs = @[phoneID];
    
    [[TIMFriendshipManager sharedInstance] GetFriendsProfile:accountIDs succ:^(NSArray *data){
        if (data.count < 1) {
            [weakSelf showPrompt:@"没有搜索到该用户"];
            return ;
        }
        [weakSelf updateSearchList:data];
    } fail:^(int code, NSString *err){
        [[TIMFriendshipManager sharedInstance] GetFriendsProfile:phoneIDs succ:^(NSArray *data){
            if (data.count < 1) {
                [weakSelf showPrompt:@"没有搜索到该用户"];
                return ;
            }
            [weakSelf updateSearchList:data];
        } fail:^(int code, NSString *err){
            [[TIMFriendshipManager sharedInstance] SearchUser:weakSelf.searchTextView.text pageIndex:_curPageIndex pageSize:kSearchPageSize succ:^(uint64_t totalNum, NSArray *data){
                TDDLogEvent(@"SearchFriend Succ");
                _curPageIndex++;
                if (data.count < 1) {
                    [weakSelf showPrompt:@"没有搜索到该用户"];
                    return ;
                }
                [weakSelf updateSearchList:data];
            } fail:^(int code, NSString *err){
                [weakSelf showPrompt:@"没有搜索到该用户"];
            }];
        }];
    }];
}

- (NSString*)getPhoneUser:(NSString*)user{
    NSString *phoneUser = [[NSString alloc] init];
    phoneUser = [phoneUser stringByAppendingString:@"86-"];
    phoneUser = [phoneUser stringByAppendingString:user];
    return phoneUser;
}

- (void)updateSearchList:(NSArray *)data{
    for (id obj in data) {
        TIMUserProfile *userPro = (TIMUserProfile *)obj;
        MyFriendModel* model = [[MyFriendModel alloc] init];
        MySearchResultModel* resultModel = [[MySearchResultModel alloc] init];
        if (![userPro.nickname isEqual:@""]) {
            resultModel.userName = userPro.nickname;
        }
        else {
            resultModel.userName = userPro.identifier;
        }
        model.user = userPro.identifier;
        model.nickName = resultModel.userName;
        resultModel.sourceModel = model;
        
        [_resultList addObject:resultModel];
        
        TDDLogEvent(@"userinfo:identifier:%@ birthday:%@ sig:%@", userPro.identifier, nil, nil);
    }
    [self.tableView reloadData];
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

#pragma mark - UITextFieldDelegate, UIAlertView
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (self.searchBtn.enabled) {
//        [self search:nil];
//    }
    [self.searchTextView resignFirstResponder];
    return NO;
}

static NSString *friendName = nil;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView resignFirstResponder];
    if (buttonIndex == 1) {
        __weak MyAddFriendViewController *weakSelf = self;
        [[MyCommOperation shareInstance]
         addFriend:friendName
         applyWord:[alertView textFieldAtIndex:0].text succ:^{
            [weakSelf showAlert:@"提示" andMsg:@"成功发送好友申请"];
        } fail:^(NSString *err) {
            [weakSelf showPrompt:err];
        }];
        friendName = nil;
    }
    return;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* kResultCellId = @"SearchResultCellId";
    MySearchResultModel* model = [self.resultList objectAtIndex:indexPath.row];
    MySearchResultCell* resultCell = [self.tableView dequeueReusableCellWithIdentifier:kResultCellId];
    if (resultCell == nil) {
        resultCell = [[MySearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultCellId];
        [resultCell updateModel:model];
        
        __weak MyAddFriendViewController *weakSelf = self;
        resultCell.addBtnAction = ^(MyUserModel* user){
            if (!user || !user.user) {
                return;
            }
            if ([[GlobalData shareInstance] getBlackInfo:user.user]) {
                [self showAlert:@"提示" andMsg:@"用户已在黑名单中，请移除黑名单后再添加好友"];
                return;
            }
            [weakSelf.searchTextView resignFirstResponder];
            friendName = user.user;
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入验证信息"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.delegate = self;
            [tf addTarget:weakSelf action:@selector(onVerifyValueChange:) forControlEvents:UIControlEventEditingChanged];
            [alert becomeFirstResponder];
            [alert show];
        };
        resultCell.blackBtnAction = ^(MyUserModel *user) {
            if (!user || !user.user) {
                return;
            }
            [[MyCommOperation shareInstance] addBlackList:@[user.user] succ:nil fail:nil];
        };
    }
    [resultCell updateModel:model];
    return resultCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.reqFriendListRspObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.reqFriendListRspObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self.reqBlackListRspObserver];
        self.reqFriendListRspObserver = nil;
        self.reqBlackListRspObserver = nil;
    }
}

- (void)onVerifyValueChange:(id)sender{
    UITextField *textField = (UITextField*)sender;
    //记录待选文字记录
    UITextRange *markedTextRange = textField.markedTextRange;
    //如果存在待选文字记录，则暂不处理
    if (markedTextRange) {
        return;
    }

    //将超出最大限制字节的文本删除
    size_t length = strlen([textField.text UTF8String]);
    if ( length > kVerifyMessageMaxBytesLength) {
        textField.text = [self cutBeyondText:textField.text];
    }
}

//递归计算符合规定的文本长度
- (NSString *)cutBeyondText:(NSString *)fieldText{
    size_t length = strlen([fieldText UTF8String]);
    if (length > kVerifyMessageMaxBytesLength) {
        fieldText = [fieldText substringToIndex:fieldText.length-1];
        return [self cutBeyondText:fieldText];
    }
    else{
        return fieldText;
    }
}

//确保没有表情输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length > 1 && [MyChatCell stringContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

@end
