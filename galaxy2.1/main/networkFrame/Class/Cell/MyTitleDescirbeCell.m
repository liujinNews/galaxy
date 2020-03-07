//
//  MyTitleDescirbeCell.m
//  MyDemo
//
//  Created by wilderliao on 15/10/27.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyTitleDescirbeCell.h"

@implementation MyTitleDescirbeCell

//nameLable = [[UILabel alloc] init];
//            nameLable.text = [GlobalData shareInstance].me;
//            [nameLable setFont:[UIFont systemFontOfSize:15]];
//            nameLable.bounds = CGRectMake(0, 0, 200, 30);
//            nameLable.textAlignment = NSTextAlignmentRight;
//            cell.accessoryView = nameLable;
//            cell.textLabel.text = @"ID";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
       // UITapGestureRecognizer* action = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick)];
        //[self addGestureRecognizer:action];
    }
    return self;
}

//- (void)cellClick
//{
//    [_item ConfigCellAction];
//}

- (void)config:(ConfigItem *)item
{
    self.item = item;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.describe;
}

@end
