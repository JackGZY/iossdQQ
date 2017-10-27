//
//  ViewController.m
//  QQ
//
//  Created by JACK-GU on 2017/10/26.
//  Copyright © 2017年 JACK-GU. All rights reserved.
//

#import "ViewController.h"
#import "ItemOtherAdd.h"


@interface ViewController () <UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherPopConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlConstraintHeight;

@property (weak, nonatomic) IBOutlet UITextField *editText;
@property (weak, nonatomic) IBOutlet UIView *otherPopView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *otherScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *otherPop;

//继续点击的是表情还是add，表情为0，add为1,只有当为-1的时候才可以进行操作更改
@property(nonatomic,assign) int index;
//表情的大小和间隔
@property(nonatomic,assign) float EMOJI_ITEM_SIZE;
@property(nonatomic,assign) float EMOJI_ITEM_PADDING;
//总共多少行表情
@property(nonatomic,assign) int numerOfEmoji;
//每一行多少个
@property(nonatomic,assign) int numberofLineEmoji;

//存放表情的view
@property(nonatomic,strong) NSMutableArray *emojiViews;



//记录表情名字的数组
@property(nonatomic,strong) NSMutableArray *emojiData;

-(IBAction)showOther;
-(IBAction)showEmoji;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = -1;
    self.EMOJI_ITEM_SIZE = 30.0f;
    self.EMOJI_ITEM_PADDING = 5.0f;
    self.numerOfEmoji = 3;
    [self initView];
}

-(void)initView{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //关闭scrollview的弹簧效果
    [[self otherScrollView] setBounces:NO];
    //关闭scrollview的滚动条
    [[self otherScrollView] setShowsHorizontalScrollIndicator:NO];
    //设置分页
    self.otherScrollView.pagingEnabled=YES;
    //设置代理
    [self.otherScrollView setDelegate:self];
    
    //拿到表情的数组
    self.emojiData = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emojiPlist" ofType:@"plist"]];
    
    //先算一下，我们设置每个表情的大小为EMOJI_ITEM_SIZE,算一下一行多少个,间隔为EMOJI_ITEM_PADDING
     self.numberofLineEmoji =  (self.view.frame.size.width - self.EMOJI_ITEM_PADDING) / (self.EMOJI_ITEM_SIZE +self.EMOJI_ITEM_PADDING );
    //这个时候每个的padding要计算过
     self.EMOJI_ITEM_PADDING = (self.view.frame.size.width -self.EMOJI_ITEM_SIZE * self.numberofLineEmoji) / (self.numberofLineEmoji + 1);
    [[self pageControl] setHidden:YES];

    [self loadEmojiView];
    
    //监听变化
    [self.editText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[self editText] setDelegate:self];
}

#pragma mark 监听键盘的确定键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"发送消息：%@",[textField text]);
    [textField setText:@""];
    return YES;
}

#pragma mark 监听输入框的变化
- (void)textFieldDidChange:(UITextField *)textField {
}

#pragma mark 开始初始化emojiView
/**
 防止第一次打开的时候要卡一下，也防止后面多次点击创建的问题
 */
-(void)loadEmojiView{
    self.emojiViews = [NSMutableArray new];
    //先计算有多少页
    int page =(int)[self.emojiData count] / (self.numberofLineEmoji * self.numerOfEmoji);
    if ([self.emojiData count] % (self.numberofLineEmoji * self.numerOfEmoji) !=0){
        page++;
    }
    
    //开始添加表情
    for (int i = 0 ; i < page ;i++){
        //创建一个view
        UIView *pageView = [UIView new];
        [pageView setFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.numerOfEmoji * (self.EMOJI_ITEM_PADDING + self.EMOJI_ITEM_SIZE))];
        
        //添加view
        int max = (i + 1) *  (self.numberofLineEmoji * self.numerOfEmoji);
        if (max > [[self emojiData] count]){
            //            for (int i = (int)[[self emojiData] count] ;i < max;i++){
            //                [[self emojiData] addObject:@""];
            //            }
            max = (int)[[self emojiData] count];
        }
        
        for (int k = i *  (self.numberofLineEmoji * self.numerOfEmoji) ; k < max; k++){
            //开始加每个emoji
            UIButton *b = [UIButton new];
            //设置大小
            [b setFrame:CGRectMake(self.EMOJI_ITEM_PADDING * (k % self.numberofLineEmoji + 1) + self.EMOJI_ITEM_SIZE * (k % self.numberofLineEmoji), self.EMOJI_ITEM_PADDING * ((k / self.numberofLineEmoji % self.numerOfEmoji) + 1) + self.EMOJI_ITEM_SIZE * (k / self.numberofLineEmoji % self.numerOfEmoji) , self.EMOJI_ITEM_SIZE,  self.EMOJI_ITEM_SIZE)];
            //设置表情
            [b setBackgroundImage:[UIImage imageNamed:[self.emojiData objectAtIndex:k]] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:[self.emojiData objectAtIndex:k]] forState:UIControlStateHighlighted];
            
            [pageView addSubview:b];
        }
        
        [self.emojiViews addObject:pageView];
    }
}

#pragma mark scroll的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / self.view.frame.size.width;
    [self.pageControl setCurrentPage:page];
}


-(IBAction)showOther{
    [[self pageControl] setHidden:YES];
    if (self.otherPopConstraintHeight.constant == 0){
        self.index = 1;
        [self setFromIndex:_index];
    }else{
        //只有当index = 0 的时候才有作用
        if (_index == 1 ){
            [UIView animateWithDuration:0.5 animations:^{
                self.otherPopConstraintHeight.constant = 0;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.index = -1;
                [self setFromIndex:_index];
            }];
        }else if (_index == 0){
            //当高度不为0，并且index = 1的时候，说明是表情切换过来的
            _index = 1;
            //清除所有view
            [self setFromIndex:-1];
            [self setFromIndex:_index];
        }
    }
}

-(IBAction)showEmoji{
    [[self pageControl] setHidden:YES];
    if (self.otherPopConstraintHeight.constant == 0){
        self.index = 0;
        [self setFromIndex:_index];
    }else{
        if (_index == 0){
            [UIView animateWithDuration:0.5 animations:^{
                self.otherPopConstraintHeight.constant = 0;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.index = -1;
                [self setFromIndex:_index];
            }];
        }else if (_index == 1){
            _index = 0;
            //清除所有view
            [self setFromIndex:-1];
            [self setFromIndex:_index];
        }
    }
}

#pragma mark 根据index的值，来进行操作


/**
 index = -1 : 清除view
 index = 0 : 添加表情
 index = 1 : add操作
 @param index 当前的index
 */
-(void)setFromIndex:(int)index{
    NSLog(@"index = %d",index);
    switch (index) {
        case -1:{
            //清除所有view
            [[self pageControl] setHidden:YES];
            self.pageControlConstraintHeight.constant = 0;
            [self.otherScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            break;
        }
        case 0:{
            //添加表情
            [self addEmoji];
            break;
        }
        case 1:{
             [self addMore];
            break;
        }
        default:
            break;
    }
}


/**
 添加表情
 */
-(void)addEmoji{
    //先计算有多少页
    int page =(int)[self.emojiData count] / (self.numberofLineEmoji * self.numerOfEmoji);
    if ([self.emojiData count] % (self.numberofLineEmoji * self.numerOfEmoji) !=0){
        page++;
    }
    
    //开始添加表情
    for (int i = 0 ; i < self.emojiViews.count ;i++){
        [self.otherScrollView addSubview:[self.emojiViews objectAtIndex:i]];
    }
    
    //设置scroll的宽度
    [self.otherScrollView setContentSize:CGSizeMake(page * self.view.frame.size.width,self.numerOfEmoji * (self.EMOJI_ITEM_PADDING + self.EMOJI_ITEM_SIZE))];
    
    //设置个数
    [self.pageControl setNumberOfPages:page];
    [self.pageControl setEnabled:NO];
    [self.pageControl setCurrentPage:0];
    [[self pageControl] setHidden:NO];
    self.pageControlConstraintHeight.constant = 37;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.otherPopConstraintHeight.constant =self.numerOfEmoji * (self.EMOJI_ITEM_PADDING + self.EMOJI_ITEM_SIZE) + self.EMOJI_ITEM_PADDING + 37;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark 添加
-(void)addMore{
    [[self pageControl] setHidden:YES];
    self.pageControlConstraintHeight.constant = 0;
    ItemOtherAdd *other = [[NSBundle mainBundle] loadNibNamed:@"ItemOtherAdd" owner:nil options:nil][0];
    
    [self.otherScrollView addSubview:other];
    //计算padding
    float padding = (self.view.frame.size.width - 4 * 80 ) / 5;
    [other setHeight:80 * 2 + padding *3];
    [other set:padding];
    
    //设置scroll的宽度
    [self.otherScrollView setContentSize:CGSizeMake(self.view.frame.size.width,80 * 2 + padding *3)];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.otherPopConstraintHeight.constant = 80 * 2 + padding *3;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end
