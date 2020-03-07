//
//  newbieGuideViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "newbieWebViewController.h"
#import "newbieGuideViewController.h"

@interface newbieGuideViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString * statusStr;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * managementArray;
@end

@implementation newbieGuideViewController

-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.statusStr = type;
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
    
    if ([self.statusStr isEqualToString:@"newbie"]) {
        [self setTitle:Custing(@"新手入门", nil) backButton:YES];
        [self createNewbieView];
    }else if ([self.statusStr isEqualToString:@"managementManual"]) {
        [self setTitle:Custing(@"管理手册", nil) backButton:YES];
        [self createManagementManual];
    }
    

    // Do any additional setup after loading the view.
}

//管理手册
-(void)createManagementManual{
    
    self.managementArray = @[
                             @{@"managementUrl":[UrlKeyManager getHelpURL:XB_GuideMemberAdd],
                               @"managementType":Custing(@"如何添加成员？", nil)},
                             @{@"managementUrl":[UrlKeyManager getHelpURL:XB_GuidePowerSet],
                               @"managementType":Custing(@"如何设置员工权限？", nil)},
                             @{@"managementUrl":[UrlKeyManager getHelpURL:XB_GuideProcessSet],
                               @"managementType":Custing(@"如何设置审批流程？", nil)},
                             @{@"managementUrl":[UrlKeyManager getHelpURL:XB_GuideFormSet],
                               @"managementType":Custing(@"如何设置自定义表单？",nil)},
                             @{@"managementUrl":[UrlKeyManager getHelpURL:XB_GuideBudgetSet],
                               @"managementType":Custing(@"如何设置预算？", nil)},
                             @{@"managementUrl":[UrlKeyManager getHelpURL:XB_GuideStandardSet],
                               @"managementType":Custing(@"如何设置住宿标准？", nil)}];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.managementArray count];
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
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45.5, Main_Screen_Width - 30, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lineView];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-50, 46) text:[self.managementArray[indexPath.row] objectForKey:@"managementType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.managementArray[indexPath.row];
    newbieWebViewController * management = [[newbieWebViewController alloc]initWithType:@"management" management:dict];    
    [self.navigationController pushViewController:management animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


//新手入门
-(void)createNewbieView{
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    backImage.image=[UIImage imageNamed:@"newbieBackground"];
    backImage.userInteractionEnabled=YES;
    [self.view addSubview:backImage];
    
    UIImageView *guide=[[UIImageView alloc]init];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width;
    if (scale<=320) {
        guide.frame = CGRectMake(Main_Screen_Width/2 - 113.5,Main_Screen_Height/2 - 230, 227, 325);
    }else{
        guide.frame = CGRectMake(Main_Screen_Width/2 - 145.5,Main_Screen_Height/2 - 280, 291, 415.5);
    }
    guide.image=[UIImage imageNamed:@"RoleGuideImg"];
    guide.userInteractionEnabled=YES;
    [backImage addSubview:guide];
    
    
    self.managementArray = @[
                             @{@"newbieUrl":[UrlKeyManager getHelpURL:XB_GuideBoss],
                               @"newbieName":@"我是老板",
                               @"newbieType":@"12321"},
                             @{@"newbieUrl":[UrlKeyManager getHelpURL:XB_GuideFinancial],
                               @"newbieName":@"我是财务",
                               @"newbieType":@"12322"},
                             @{@"newbieUrl":[UrlKeyManager getHelpURL:XB_GuideEmployee],
                               @"newbieName":@"我是员工",
                               @"newbieType":@"12323"}];
    
    for (int j = 0 ; j < [self.managementArray count] ; j ++ ) {
        
        UIButton * chooseBtn = [GPUtils createButton:CGRectZero action:nil delegate:self title:nil font:nil titleColor:nil];
;
        if (scale<=320) {
            chooseBtn.frame=CGRectMake(0, 45 + j*90, WIDTH(guide), 80);
        }else{
            chooseBtn.frame=CGRectMake(0, 55 + j*115, WIDTH(guide), 100);
        }
        [chooseBtn addTarget:self action:@selector(chooseNewbieBtn:) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn.tag = [[[self.managementArray objectAtIndex:j] objectForKey:@"newbieType"] integerValue];
        [chooseBtn setBackgroundColor:[UIColor clearColor]];
        [guide addSubview:chooseBtn];
        
    }
    
    
}

-(void)chooseNewbieBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 12321://进入老板
            for (NSDictionary * dict in self.managementArray) {
                if ([dict[@"newbieType"] isEqualToString:@"12321"]) {
                    newbieWebViewController *commonVC=[[newbieWebViewController alloc]initWithType:@"newbie" management:dict];
                    [self.navigationController pushViewController:commonVC animated:YES];
                }
            }
            break;
        case 12322://进入财务
            for (NSDictionary * dict in self.managementArray) {
                if ([dict[@"newbieType"] isEqualToString:@"12322"]) {
                    newbieWebViewController *commonVC=[[newbieWebViewController alloc]initWithType:@"newbie" management:dict];
                    [self.navigationController pushViewController:commonVC animated:YES];
                }
            }
            break;
        case 12323://进入员工
            for (NSDictionary * dict in self.managementArray) {
                if ([dict[@"newbieType"] isEqualToString:@"12323"]) {
                    newbieWebViewController *commonVC=[[newbieWebViewController alloc]initWithType:@"newbie" management:dict];
                    [self.navigationController pushViewController:commonVC animated:YES];
                }
            }
            break;
            
        default:
            break;
    }
    
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
