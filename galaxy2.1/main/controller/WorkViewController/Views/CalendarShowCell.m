//
//  CalendarShowCell.m
//  galaxy
//
//  Created by hfk on 2018/1/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CalendarShowCell.h"

@implementation CalendarShowCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellAccessoryNone;
        [self createView];
    }
    return self;
}

-(void)createView{

    if (!_lab_Date) {
        _lab_Date=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        _lab_Date.backgroundColor=Color_White_Same_20;
        [self.contentView addSubview:_lab_Date];
    }
    [_lab_Date makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(@0);
    }];
    
    if (!_lab_timeType) {
        _lab_timeType=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_timeType];
    }
    [_lab_timeType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@12);
        make.left.equalTo(self.contentView.left).offset(@20);
        make.size.equalTo(CGSizeMake(50, 20));
    }];
    
    if (!_lab_startTime) {
        _lab_startTime=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_startTime];
    }
    [_lab_startTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@12);
        make.left.equalTo(self.contentView.left).offset(@20);
        make.size.equalTo(CGSizeMake(50, 20));
    }];
    
    
    if (!_lab_endTime) {
        _lab_endTime=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_endTime];
    }
    [_lab_endTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@32);
        make.left.equalTo(self.contentView.left).offset(@20);
        make.size.equalTo(CGSizeMake(50, 20));
    }];
    
    
    if (!_view_line) {
        _view_line=[[Dashline alloc]initWithFrame:CGRectZero withLineLength:2 withLineSpacing:2 withLineColor:Color_GrayLight_Same_20];
        [self.contentView addSubview:_view_line];
    }
    [_view_line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom);
        make.left.equalTo(self.contentView.left).offset(@74.5);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    if (!_imv_circle) {
        _imv_circle=[GPUtils createImageViewFrame:CGRectZero imageName:@"Work_Calendar_Circleb"];
        [self.contentView addSubview:_imv_circle];
    }
    [_imv_circle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@19);
        make.left.equalTo(self.contentView.left).offset(@71);
        make.size.equalTo(CGSizeMake(8, 8));
    }];
    
    if (!_imv_people) {
        _imv_people=[GPUtils createImageViewFrame:CGRectZero imageName:@"Work_Calendar_People"];
        [self.contentView addSubview:_imv_people];
    }
    
    [_imv_people makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(@-16);
        make.left.equalTo(self.left).offset(@110);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
    
    if (!_lab_Name) {
        _lab_Name=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Name];
    }
    [_lab_Name makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(@-16);
        make.left.equalTo(self.left).offset(@125);
        make.height.equalTo(@12);
        make.width.equalTo(@(Main_Screen_Width-12-130));
    }];
    
    if (!_lab_Title) {
        _lab_Title=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_Title.numberOfLines=0;
        [self.contentView addSubview:_lab_Title];
    }
    [_lab_Title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@14);
        make.left.equalTo(self.contentView.left).offset(@110);
        make.width.equalTo(@(Main_Screen_Width-110-12));
        make.bottom.equalTo(self.lab_Name.top).offset(@-3);
    }];
    
    
    if (!_btn_Busy) {
        _btn_Busy= [GPUtils createButton:CGRectZero action:nil delegate:self title:nil font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
        [_btn_Busy.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:_btn_Busy];
    }
    
    _btn_Busy.hidden=YES;
    CGSize size1 = [Custing(@"忙碌", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 100) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat titleWidth=size1.width;
    CGFloat imageWidth = 17;
    NSInteger btnWidth = titleWidth +imageWidth;
    _btn_Busy.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -imageWidth+8);
    _btn_Busy.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -imageWidth+14);
    [_btn_Busy setImage:[UIImage imageNamed:@"Work_Calendar_Busy"] forState:UIControlStateNormal];
    [_btn_Busy setTitle:Custing(@"忙碌", nil) forState:UIControlStateNormal];
    [_btn_Busy makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.bottom).offset(@14);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.width.equalTo(btnWidth);
        make.height.equalTo(@19);
    }];

}

-(void)configCellWithObj:(id)obj WithType:(NSInteger)type{
    _lab_timeType.text=nil;
    _lab_startTime.text=nil;
    _lab_endTime.text=nil;
    _lab_Title.textColor=Color_Black_Important_20;
    
    if (type==1) {
        CalendarShowModel *model = (CalendarShowModel *)obj;
        NSString *title=[NSString isEqualToNull:model.subject]?[NSString stringWithFormat:@"%@",model.subject]:@"";
        _lab_Title.text=title;
        _lab_Name.text=[NSString isEqualToNull:model.userDspName]?[NSString stringWithFormat:@"%@",model.userDspName]:@"";
        float Timetype=[[NSString stringWithFormat:@"%@",model.type]floatValue];
        if (Timetype==0) {
            if ([NSString isEqualToNull:model.scheduleTime]) {
                NSArray *arr=[[NSString stringWithFormat:@"%@",model.scheduleTime]componentsSeparatedByString:@","];
                if (arr.count>1) {
                    _lab_startTime.text=arr[0];
                    _lab_endTime.text=arr[1];
                }
            }
        }else if (Timetype==1){
            _lab_timeType.text=Custing(@"开始", nil);
            _lab_endTime.text=[NSString isEqualToNull:model.scheduleTime]?[NSString stringWithFormat:@"%@",model.scheduleTime]:@"";
        }else if (Timetype==2){
            _lab_timeType.text=Custing(@"结束", nil);
            _lab_endTime.text=[NSString isEqualToNull:model.scheduleTime]?[NSString stringWithFormat:@"%@",model.scheduleTime]:@"";
        }else if (Timetype==3){
            _lab_timeType.text=Custing(@"全天", nil);
        }
    }else if (type==2){
        
        CalendarShowModel *model = (CalendarShowModel *)obj;
        userData *userdatas=[userData shareUserData];

        if ([[NSString stringWithFormat:@"%@",model.isPrivate]floatValue]==1&&![[NSString stringWithFormat:@"%@",userdatas.userId] isEqualToString:[NSString stringWithFormat:@"%@",model.userId]]) {
            _lab_Title.text=@"******";
            _lab_Title.textColor=Color_GrayDark_Same_20;
            _btn_Busy.hidden=NO;
        }else{
            NSString *title=[NSString isEqualToNull:model.subject]?[NSString stringWithFormat:@"%@",model.subject]:@"";
            _lab_Title.text=title;
            _btn_Busy.hidden=YES;
        }
        _lab_Name.text=[NSString isEqualToNull:model.userDspName]?[NSString stringWithFormat:@"%@",model.userDspName]:@"";
        float Timetype=[[NSString stringWithFormat:@"%@",model.type]floatValue];
        if (Timetype==0) {
            if ([NSString isEqualToNull:model.scheduleTime]) {
                NSArray *arr=[[NSString stringWithFormat:@"%@",model.scheduleTime]componentsSeparatedByString:@","];
                if (arr.count>1) {
                    _lab_startTime.text=arr[0];
                    _lab_endTime.text=arr[1];
                }
            }
        }else if (Timetype==1){
            _lab_timeType.text=Custing(@"开始", nil);
            _lab_endTime.text=[NSString isEqualToNull:model.scheduleTime]?[NSString stringWithFormat:@"%@",model.scheduleTime]:@"";
        }else if (Timetype==2){
            _lab_timeType.text=Custing(@"结束", nil);
            _lab_endTime.text=[NSString isEqualToNull:model.scheduleTime]?[NSString stringWithFormat:@"%@",model.scheduleTime]:@"";
        }else if (Timetype==3){
            _lab_timeType.text=Custing(@"全天", nil);
        }
    }
}


+ (CGFloat)cellHeightWithObj:(id)obj WithType:(NSInteger)type{
    CGFloat cellHeight = 0;
    NSString *title=@"";
    if ([obj isKindOfClass:[CalendarShowModel class]]) {
        CalendarShowModel *task = (CalendarShowModel *)obj;
        if (type==2&&[[NSString stringWithFormat:@"%@",task.isPrivate]floatValue]==1) {
            cellHeight += 20+25+20;
        }else{
            title=[NSString isEqualToNull:task.subject]?task.subject:@"";
            CGSize size1 = [title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-110-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            if (size1.height>20) {
                cellHeight += size1.height+25+20;
            }else{
                cellHeight += 20+25+20;
            }
        }
    }
    return cellHeight;
}

-(void)configNotifyMeCellWithModel:(NotifyMeCalendarModel *)model WithBeforeModel:(NotifyMeCalendarModel *)beforeModel{
    
    if ([[NSString stringWithFormat:@"%@",beforeModel.startTime] isEqualToString:[NSString stringWithFormat:@"%@",model.startTime]]) {
        [_lab_Date updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _lab_Date.text=nil;
    }else{
        [_lab_Date updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
        }];
        _lab_Date.text=[NSString isEqualToNull:model.startTime]?[NSString stringWithFormat:@"%@",model.startTime]:@"";
    }
    _lab_Title.text=[NSString isEqualToNull:model.subject]?[NSString stringWithFormat:@"%@",model.subject]:@"";
    _lab_Name.text=[NSString isEqualToNull:model.userDspName]?[NSString stringWithFormat:@"%@",model.userDspName]:@"";
    _lab_startTime.text=[NSString isEqualToNull:model.startTimeTimeStr]?[NSString stringWithFormat:@"%@",model.startTimeTimeStr]:@"";
}

+ (CGFloat)cellNotifyMeHeightWithModel:(NotifyMeCalendarModel *)model WithBeforeModel:(NotifyMeCalendarModel *)beforeModel{
    CGFloat cellHeight = 25;
    if ([[NSString stringWithFormat:@"%@",beforeModel.startTime] isEqualToString:[NSString stringWithFormat:@"%@",model.startTime]]) {
        cellHeight=0;
    }
    NSString *title=[NSString isEqualToNull:model.subject]?model.subject:@"";
   
    CGSize size1 = [title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-115-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size1.height>20) {
        cellHeight += size1.height+25+20;
    }else{
        cellHeight += 20+25+20;
    }
    return cellHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
