//
//  ViewController.m
//  ChatMessage
//
//  Created by QAING CHEN on 17/2/4.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "ViewController.h"
#import "chatInputView.h"
#import "ChatModel.h"
#import "ChatTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView            *CharTableView;
@property (nonatomic ,strong)NSMutableArray         *dataArray;
@property (nonatomic ,strong)chatInputView          *inputView;


@end
static  NSString *identinfy = @"chatCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.CharTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 30) style:UITableViewStylePlain];
    self.CharTableView.delegate = self;
    self.CharTableView.dataSource = self;
    self.CharTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.CharTableView];
    
    
    [self.CharTableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:identinfy];
   
    // 小技巧，用了之后不会出现多余的Cell
    UIView *view = [[UIView alloc] init];
    self.CharTableView.tableFooterView = view;

    self.inputView = [[chatInputView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
    self.inputView.backgroundColor = [UIColor whiteColor];
    self.inputView.textField.delegate = self;
    [self.inputView.button addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    
    //注册键盘的通知 hiden or show
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 增加手势，点击弹回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:tap];
}
- (void)click:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

// 监听键盘弹出
- (void)keyBoardShow:(NSNotification *)noti
{
    CGRect rec = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(rec));
    // 小于，说明覆盖了输入框
    if ([UIScreen mainScreen].bounds.size.height - rec.size.height < self.inputView.frame.origin.y + self.inputView.frame.size.height)
    {
        // 把我们整体的View往上移动
        CGRect tempRec = self.view.frame;
        tempRec.origin.y = - (rec.size.height);
        self.view.frame = tempRec;
    }
    // 由于可见的界面缩小了，TableView也要跟着变化Frame
    self.CharTableView.frame = CGRectMake(0, rec.size.height+64, 375, 667 - 64 - rec.size.height - 30);
    if (self.dataArray.count != 0)
    {
        [self.CharTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    
}

// 监听键盘隐藏
- (void)keyboardHide:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, 375, 667);
    self.CharTableView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, ScreenHeight - 64 - 30);
}



- (void)inputAction:(UIButton *)ubtton
{
    if (![self.inputView.textField.text isEqualToString:@""]) {
        ChatModel *model = [[ChatModel alloc]init];
        model.MsgString = self.inputView.textField.text;
        model.isRight = arc4random() % 2;
        [self.dataArray addObject:model];
    }
    
    [self.CharTableView reloadData];
    
    // 滚到底部  scroll so row of interest is completely visible at top/center/bottom of view
    if (self.dataArray.count != 0) {
        [self.CharTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identinfy forIndexPath:indexPath];
    [cell refreshCell:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel *model = self.dataArray[indexPath.row];
    CGRect rect = [model.MsgString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rect.size.height + 45;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
