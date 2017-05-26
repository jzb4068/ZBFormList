# ZBFormList
![image](https://raw.githubusercontent.com/jzb4068/ZBFormList/master/ZBFormList/GIF/formList.gif)
## **示例代码**：
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initViews {
    NSArray * topMenus  = @[@"10:10 - 10:30",
                            @"10:30 - 10:50",
                            @"10:50 - 11:20",
                            @"11:20 - 11:50",
                            @"11:50 - 12:20",
                            @"12:20 - 12:50",
                            @"12:50 - 13:20"];
    NSArray * sideMenus = @[@"起床跑步",
                            @"吃早饭",
                            @"上班",
                            @"中午吃饭",
                            @"午休",
                            @"上班",
                            @"回家做饭"];
    NSMutableArray * cellColors = [NSMutableArray arrayWithCapacity:sideMenus.count];
    for (int i = 0; i < sideMenus.count; i ++) {
        NSMutableArray * colors = [NSMutableArray arrayWithCapacity:topMenus.count];
        for (int j = 0; j < topMenus.count; j ++) {
            [colors addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
        }
        [cellColors addObject:colors];
    }
    NSLog(@"cell 的颜色数据是：%@",cellColors);
    
    self.formListView = [[ZBFormListView alloc]initWithFrame:CGRectMake(20, 100, 300, 200)];
    [self.view addSubview:_formListView];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _indicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    _indicator.layer.cornerRadius = 8;
    _indicator.layer.masksToBounds = YES;
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _formListView.topMenus = topMenus;
        _formListView.sideMenus = sideMenus;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _formListView.dataSource = cellColors;
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _indicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}
```
