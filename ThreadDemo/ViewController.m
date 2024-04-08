//
//  ViewController.m
//  NestScrollView
//
//  Created by ZB on 2022/7/18.
//

#import "ViewController.h"
#import "ZBPermenantThread.h"
#import "ZBCFThread.h"


@interface ViewController ()

@property (nonatomic, strong) ZBCFThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[ZBCFThread alloc]init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.thread executeTask:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
}

- (IBAction)stopAction:(id)sender {
    [self.thread stop];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
