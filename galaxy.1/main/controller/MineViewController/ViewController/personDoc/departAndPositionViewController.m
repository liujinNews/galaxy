//
//  departAndPositionViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/9/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "departAndPositionViewController.h"

@interface departAndPositionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *resultArray;//下载数据
@property(nonatomic,strong)NSString *statusStr;

@end

@implementation departAndPositionViewController

-(id)initWithType:(NSString *)type result:(NSArray *)array {
    self = [super init];
    if (self) {
        self.statusStr = type;
        self.resultArray = [NSMutableArray arrayWithArray:array];
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
      
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.statusStr isEqualToString:@"depart"]) {
        [self setTitle:Custing(@"部门", nil) backButton:YES ];
    }else {
        [self setTitle:Custing(@"职位", nil) backButton:YES ];
    }
    
     _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStylePlain];
    _tableView .delegate = self;
    _tableView .dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
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
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45.5, Main_Screen_Width - 30, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lineView];
        
        NSString * name;
        if ([self.statusStr isEqualToString:@"depart"]) {
            name = [NSString stringWithFormat:@"%@",[self.resultArray[indexPath.row] objectForKey:@"groupName"]];
        }else {
            name = [NSString stringWithFormat:@"%@",[self.resultArray[indexPath.row] objectForKey:@"jobTitle"]];
        }
        if (![NSString isEqualToNull:name]) {
            name = @"";
        }
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width-30, 43) text:name font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
