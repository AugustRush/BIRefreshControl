//
//  ViewController.m
//  BIRefreshHeaderDemo
//
//  Created by AugustRush on 11/24/15.
//  Copyright © 2015 AugustRush. All rights reserved.
//

#import "ViewController.h"
#import "BIRefresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger cellCount;
@end

@implementation ViewController

static NSString *const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cellCount = 20;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    __weak typeof(self) wself = self;
    [self.tableView bi_addInputMethodRefreshHeaderWithHandler:^{
        [wself handleRefresh];
    }];
    
    [self.tableView bi_addInputMethodLoadingFooterWithHandler:^{
        [wself handleLoading];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView bi_startRefreshing];
}

- (void)dealloc {
//    [self.tableView removeObserver:self.tableView.refreshControl forKeyPath:@"contentOffset"];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)handleRefresh {
    NSLog(@"refresh header %s",__PRETTY_FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cellCount = self.cellCount - 5;
        [self.tableView reloadData];
        [self.tableView bi_stopRefreshing];
    });
}

- (void)handleLoading {
    NSLog(@"loading footer %s",__PRETTY_FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cellCount += 5;
        [self.tableView reloadData];
        [self.tableView bi_stopLoading];
    });
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"section %ld row %ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select indexPath is %@",indexPath);
}

@end
