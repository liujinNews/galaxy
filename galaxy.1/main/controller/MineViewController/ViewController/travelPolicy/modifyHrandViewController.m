//
//  modifyHrandViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/9/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
#import "HRStandardTableViewCell.h"

#import "modifyHrandViewController.h"

@interface modifyHrandViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,chooseTravelDateViewDelegate,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * hrstArray;
@property (nonatomic,strong)NSMutableArray * nyrDate;

@property (nonatomic,strong)UILabel * isNoBal;
@property (nonatomic,strong)NSString * returnStr;
@property (nonatomic,strong)NSMutableArray * saveAmount;

@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框
@property(nonatomic,strong)UIPickerView * pickerView;//弹出的时间图

@property (nonatomic,strong)UITextField * hrandTF;

@end

@implementation modifyHrandViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"补贴标准setting", nil) backButton:YES];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.hrstArray = [NSMutableArray arrayWithArray:@[]];
    self.nyrDate = [NSMutableArray arrayWithArray:@[Custing(@"1天", nil),Custing(@"1月", nil),Custing(@"1年", nil)]];
    [self requestParameter];
    
//    self.hrstArray = [NSMutableArray array];
//    NSArray * items = self.data.StdAllowances;
//    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
//        self.saveAmount = [NSMutableArray arrayWithArray:items];
//        [HRStandardData GetUserGetStdAllowancesDictionary:items Array:self.hrstArray];
//    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

//表单加载
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hrstArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 80)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *head1View=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    head1View.backgroundColor = Color_form_TextFieldBackgroundColor;
    [headView addSubview:head1View];
    
    UILabel * curreryA = [GPUtils createLable:CGRectMake(15, 0, WIDTH(headView)-137, 60) text:[NSString stringWithFormat:@"%@%@",Custing(@"员工级别：", nil),self.data.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [head1View  addSubview:curreryA];
    
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
    
    UIButton * submitBtn = [GPUtils createButton:CGRectMake(15,20, WIDTH(headView)-30,49) action:@selector(saveModifyForStandData:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"保存", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [submitBtn setBackgroundColor:Color_Blue_Important_20];
    submitBtn.layer.cornerRadius = 11.0f;
    [headView addSubview: submitBtn];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRStandardTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HRStandardTableViewCell"];
    if (cell==nil) {
        cell=[[HRStandardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRStandardTableViewCell"];
    }
    
    HRStandardData * cellInfo = self.hrstArray[indexPath.row];
    [cell configForStandardCellInfo:cellInfo];
    
    self.hrandTF =[[UITextField alloc]initWithFrame:CGRectMake(90, 1, MainScreenWidth() - 205, 55)];
    self.hrandTF.placeholder = Custing(@"请输入补贴金额", nil);
    self.hrandTF.font = Font_Important_15_20;
    self.hrandTF.textColor = Color_form_TextField_20;
    self.hrandTF.delegate=self;
    self.hrandTF.tag = indexPath.row;
    self.hrandTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.hrandTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.hrandTF.adjustsFontSizeToFitWidth = YES;
    self.hrandTF.keyboardType = UIKeyboardTypeDecimalPad;
    [cell.mainView addSubview:self.hrandTF];
    if ([NSString isEqualToNull:cellInfo.amount]) {
        self.hrandTF.text = cellInfo.amount;
    }
    
//    cell.hrandTF.delegate=self;
//    cell.hrandTF.tag = indexPath.row;
    
    cell.tongBtn.userInteractionEnabled = YES;
    cell.tongBtn.tag = indexPath.row;
    
    [cell.tongBtn addTarget:self action:@selector(tongXunPush:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//MARK:员工级别对应的补贴标准列表
-(void)requestParameter{
    
    NSDictionary *parameters = @{@"UserLevelId":[NSString stringWithFormat:@"%@",self.data.userLevelId]};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StdAllowance/GetStdAllowance"] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}
//MARK:请求保存员工级别对应的补贴标准

-(void)saveData{

    for (int i=0; i<self.saveAmount.count; i++) {
        NSString * amountStr = [NSString stringWithFormat:@"%@",[[self.saveAmount objectAtIndex:i] objectForKey:@"amount"]];
        NSString * nameStr = [NSString stringWithFormat:@"%@",[[self.saveAmount objectAtIndex:i] objectForKey:@"expenseType"]];
        if ([amountStr isEqualToString:@""]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",nameStr,Custing(@"限制金额不能为空", nil)] duration:2.0];
            return;
        }
        
    }
   
    NSDictionary *parameters = @{@"UserLevelId":[NSString stringWithFormat:@"%@",self.data.userLevelId],@"StdAllowances":self.saveAmount};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:stri forKey:@"Stds"];

    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StdAllowance/Save"] Parameters:dict Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}



- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum == 1) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self backBorrowRecord];
        });
    }
    
    
    switch (serialNum) {
        case 0:
        {
            self.hrstArray = [NSMutableArray array];
            NSArray * items = [[responceDic objectForKey:@"result"] objectForKey:@"stdAllowances"];
            if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
                self.saveAmount = [NSMutableArray arrayWithArray:items];
            }
            [HRStandardData GetUserGetStdAllowancesDictionary:items Array:self.hrstArray];
            [self.tableView reloadData];
        }
            break;
        case 1://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"条件设置成功", nil) duration:2.0];
            break;
        default:
            break;
    }
   
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
    
}
-(void)backBorrowRecord{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqual:@" "]) {
        return NO;
    }
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0!= range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        //只能输入数字和小数点"
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {//小数点后面2位
        return NO;
    }
    
    if (toBeString.length>=2) {
        if ([[toBeString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"]&&![[toBeString substringWithRange:NSMakeRange(1, 1)]isEqualToString:@"."]) {
            return NO;
        }
    }
    NSRange range1 = [toBeString rangeOfString:@"."];
    if (range1.location == NSNotFound) {
        if ([toBeString length] >9) { //如果输入框内容大于9
            textField.text = [toBeString substringToIndex:9];
            return NO;
        }
    }else{
        if ([toBeString length] >12) { //如果输入框内容大于12
            textField.text = [toBeString substringToIndex:12];
            return NO;
        }
        
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length!=0) {
        NSString *subStr = [textField.text substringFromIndex:textField.text.length-1];
        if ([subStr isEqualToString:@"."]) {
            textField.text=[textField.text substringToIndex:textField.text.length-1];
        }
    }
    
    NSString * textIndexPath = [NSString stringWithFormat:@"%ld",(long)textField.tag];
    NSDictionary * dic;
    for (int i=0; i<self.saveAmount.count; i++) {
        if (i == [textIndexPath integerValue]) {
            dic = @{@"amount":textField.text,@"expenseCode":[[self.saveAmount objectAtIndex:i] objectForKey:@"expenseCode"],@"expenseType":[[self.saveAmount objectAtIndex:i] objectForKey:@"expenseType"],@"id":[[self.saveAmount objectAtIndex:i] objectForKey:@"id"],@"unit":[[self.saveAmount objectAtIndex:i] objectForKey:@"unit"]};
        }
        
    }
    
//    [self.saveAmount replaceObjectAtIndex:[textIndexPath integerValue] withObject:dic];
//    self.hrstArray = [NSMutableArray arrayWithArray:self.saveAmount];
    [self.saveAmount replaceObjectAtIndex:[textIndexPath integerValue] withObject:dic?dic:@""];
    [self.hrstArray removeAllObjects];
    [HRStandardData GetUserGetStdAllowancesDictionary:self.saveAmount Array:self.hrstArray];
    
    [self.tableView reloadData];
    
}

//MARK:选择年月日
-(void)tongXunPush:(UIButton *)btn {
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 122)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.tag = btn.tag;
    
    NSLog(@"%ld-----%ld",(long)btn.tag,(long)self.pickerView.tag);
    NSInteger  ste = 0;
    for (int i=0; i<self.saveAmount.count; i++) {
        if (i == self.pickerView.tag) {
            ste = [[NSString stringWithFormat:@"%@",[[self.saveAmount objectAtIndex:i] objectForKey:@"unit"]] integerValue];
            if (ste == 0) {
                ste = 1;
            }
        }
    }
    [self.pickerView selectRow:ste-1 inComponent:0 animated:NO];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel * xuanzhe = [GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40) text:Custing(@"选择", nil) font:Font_cellContent_16 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    xuanzhe.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:xuanzhe];
    
    if (!_datelView) {
        _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pickerView.frame.size.height+40) pickerView:self.pickerView titleView:view];
        _datelView.delegate = self;
    }
    [_datelView showUpView:self.pickerView];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.nyrDate.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.nyrDate objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//弹窗代理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString * date = [NSString stringWithFormat:@"%@",[self.nyrDate objectAtIndex:row]];
    NSDictionary * dic;
    if ([date isEqualToString:Custing(@"1天", nil)]) {
        date = @"1";
    }else if ([date isEqualToString:Custing(@"1月", nil)]) {
        date = @"2";
    }else if ([date isEqualToString:Custing(@"1年", nil)]) {
        date = @"3";
    }
    
    for (int i=0; i<self.saveAmount.count; i++) {
        if (i == self.pickerView.tag) {
            dic = @{@"amount":[[self.saveAmount objectAtIndex:i] objectForKey:@"amount"],@"expenseCode":[[self.saveAmount objectAtIndex:i] objectForKey:@"expenseCode"],@"expenseType":[[self.saveAmount objectAtIndex:i] objectForKey:@"expenseType"],@"id":[[self.saveAmount objectAtIndex:i] objectForKey:@"id"],@"unit":date};
        }
        
    }
    
    [self.saveAmount replaceObjectAtIndex:self.pickerView.tag withObject:dic?dic:@""];
    [self.hrstArray removeAllObjects];
    [HRStandardData GetUserGetStdAllowancesDictionary:self.saveAmount Array:self.hrstArray];
    [self.tableView reloadData];
    
}

//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}


//MARK:保存限制
-(void)saveModifyForStandData:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    [self.hrandTF resignFirstResponder];
    [self textFieldDidEndEditing:self.hrandTF];
    [self saveData];
 
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
