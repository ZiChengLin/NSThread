//
//  ViewController.m
//  Lesson-UI0611
//
//  Created by 林梓成 on 15/6/11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"

#define BaseUrl @"http://news.mydrivers.com/img/20130507/ccd0f064c47f48248465e4fdc6819266.jpg"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doButton:(id)sender {
    
    // 查看当前是否在主线程
    NSLog(@"%d", [[NSThread currentThread]isMainThread]);
    
    /*
    // 线程阻塞 （UI冻结）
    for (NSInteger i = 0; i < INTMAX_MAX; i++) {   // INTMAX_MAX是系统支持的最大整形数字
        
        // 单一线程内很容易造成UI冻结
        NSLog(@"卡死了");
    }
    */
    
    
/*
    // ********开辟子线程的第一种方式（object对象通常使用其来完成从主线程向子线程传值）
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(doThread1:) object:@"123"];
    
    // 设置线程的优先级
    thread.threadPriority = 0.8;
    
    // 用这种方式创建的多线程需要手动的开启
    [thread start];
    
    // 第二个子线程
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(doThread2:) object:nil];
    thread2.threadPriority = 0.3;
    thread2.name = @"窗口2";
    [thread2 start];
*/
    
    
    // *******第二种开辟子线程的方式（该方法不需要手动开启）
    //[NSThread detachNewThreadSelector:@selector(doThread3:) toTarget:self withObject:nil];
    
    // *******线程间的互斥
    
    // 线程锁
    NSLock *lock = [[NSLock alloc] init];
    
    NSThread *thred4 = [[NSThread alloc]initWithTarget:self selector:@selector(doThread4:) object:lock];
    [thred4 start];
    
    NSThread *thred5 = [[NSThread alloc]initWithTarget:self selector:@selector(doThread4:) object:lock];
    [thred5 start];
    
    NSThread *thred6 = [[NSThread alloc]initWithTarget:self selector:@selector(doThread4:) object:lock];
    [thred6 start];
    
    
    
    
/*
    // 在当前主线程里面开始的for循环任务
    for (int i = 0; i < 100; i++) {
        
        NSLog(@"主线程中。。。。。");
    }
*/
}

#pragma mark 开辟线程第一种方式的方法
- (void)doThread1:(id)object {
    
    // 因为在子线程中也需要做内存管理 而在MRC中用autorelease修饰的对象需要自动释放池来释放资源。在子线程当中，系统没有为我们创建自动释放池，所以需要我们自己手动创建。
    
    @autoreleasepool {
        
        // 该方法内部就是子线程
        NSLog(@"doThread1 = %d", [[NSThread currentThread]isMainThread]);
        NSLog(@"object = %@", object);   // 主线程到子线程的传值
        
        
        // 当前子线程里面执行的for循环任务 （主线程和子线程快速交替执行）
        for (int i = 0; i < 100; i++) {
            
            NSLog(@"。。。。。子线程1中");
        }
        
    }
}

- (void)doThread2:(NSThread *)thread {
    
    NSLog(@"name = %@", [[NSThread currentThread] name]);   // 获取线程名字
    
    for (int i = 0; i < 100; i++) {
        
        NSLog(@"。。。子线程2.。。。");
    }
}

#pragma mark 开辟线程第二种方式的方法
- (void)doThread3:(NSThread *)thread {

    // 通常在子线程中都会做一些数据请求的操作
    NSURL *url = [NSURL URLWithString:BaseUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    // 发送一个同步的请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    UIImage *image = [UIImage imageWithData:data];
    
    // 不建议UI的更新在子线程里写，因为子线程更新UI会存在潜在问题它有自己的生命周期，并且耗时费性能
    //self.imageView.image = image;
    
    // 从子线程回到主线程的方法（主要用于线程间的通信）waitUntilDone如果为YES就立刻跳转到主线程执行 NO的话就延迟执行
    [self performSelectorOnMainThread:@selector(doMainThread:) withObject:image waitUntilDone:YES];
    NSLog(@"123");
    
    for (int i = 0; i < 100; i++) {
        
        NSLog(@"这是子线程3！！！");
    }
    
}

#pragma mark 该方法是从子线程中回到主线程的方法
- (void)doMainThread:(id)object {
    
    NSLog(@"doMainThread = %d", [[NSThread currentThread]isMainThread]);
    self.imageView.image = object;
    
}


#pragma mark 线程互斥
- (void)doThread4:(id)object {
    
    NSLock *lock = (NSLock *)object;
    [lock lock];  // 添加线程锁
    
    while (true) {
        
        // 有100张票 每循环一次相当于买出去一张
        static int num = 100;
        num--;
        NSLog(@"%d", num);
        sleep(1);
        if (num == 0) {
            
            break;
        }
    }
    [lock unlock];    // 解开线程锁
}

@end
