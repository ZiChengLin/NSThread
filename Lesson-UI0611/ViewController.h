//
//  ViewController.h
//  Lesson-UI0611
//
//  Created by 林梓成 on 15/6/11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)doButton:(id)sender;

@end


/*
 
 面试题:
 
 什么是进程？什么是线程？有什么区别
 进程是系统分配资源的最小单位（就是一个app运行时在内存中所需要的所有资源）
 线程是CPU运行的最小基本单位、（一个线程就是一个任务）
 联系：1.进程包含线程、系统至少会为app开辟一个进程。一个进程至少会有一个线程（主线程）
      2.每个进程都有自己独立的堆栈空间。一个进程崩溃，不会影响其他进程的工作
      3.线程没有自己独立的堆栈空间。统一使用进程的内存空间，所有一个线程崩溃，整个进程都会崩溃
 
 多线程的实质：CPU快速的在各个线程之间切换，由于CPU的执行速度很快，我们根本感觉不到，就相当于多个任务在同时执行一样。这也就是为什么我们的电脑，开的程序越多，就会感觉性能下降的原因。
 
 线程互斥：因为线程没有自己独立的堆栈空间，都是使用进程的空间，所以有可能多个线程访问进程的同一块资源，这就会出现线程访问问题。多个线程访问进程的同一资源就叫做线程互斥，解决办法是加线程锁。
 线程锁：类似于买票系统，当多个线程访问进程多同一块资源时，哪一个线程先访问的，就进行访问并设置线程锁让其他线程无法访问。只当自己不再使用时才打开线程锁。其他线程才能够使用
 
 */