//
//  AppDelegate.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // google
        FIRApp.configure()
        
        // umeng统计观
        let obj = UMAnalyticsConfig()
        obj.appKey = "5852fa613eae254d7d00268d"
        obj.channelId = "App Store"
        MobClick.start(withConfigure: obj)
        // umeng统计观看次数
        MobClick.event("UMLOGIN")
        
        
        // 导航按钮文字颜色 字体大小
        let attributes =  [NSForegroundColorAttributeName: UIColor.gray,NSFontAttributeName: UIFont(name: "Heiti SC", size: 10.0)!]
        let attributesPressed =  [NSForegroundColorAttributeName: UIColor.darkGray,NSFontAttributeName: UIFont(name: "Heiti SC", size: 10.0)!]
        
        // 首页
        // 第一步 获取ViewController 控制器，并且创建一个 导航控制器用来承载ViewController
        let mHomeViewController = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as! HomePageViewController
        let mHomeNavController = UINavigationController(rootViewController: mHomeViewController)
        // 第二步 创建一个导航item 并且设置导航按钮的点击icon切换 设置字体颜色 和大小
        let mHomeNormalImage = UIImage(named: "main_nor")?.withRenderingMode(.alwaysOriginal)
        let mHomeSelectedImage = UIImage(named: "main_sel")?.withRenderingMode(.alwaysOriginal)
        let mHomeTabBarItem = UITabBarItem(title: "精选", image: mHomeNormalImage, selectedImage: mHomeSelectedImage)
        mHomeTabBarItem.setTitleTextAttributes(attributes, for: .normal)
        if #available(iOS 9.0, *) {
            mHomeTabBarItem.setTitleTextAttributes(attributesPressed, for: .focused)
        } else {
            // Fallback on earlier versions
        }
        // 第三步:将导航item 对象 赋值给导航控制器
        mHomeNavController.tabBarItem = mHomeTabBarItem
        
        
        // 班级列表
        let mClassNameVeiwController = UIStoryboard(name: "ClassName", bundle: nil).instantiateViewController(withIdentifier: "ClassName") as! ClassNameViewController
        let mClassNameNavCtontroller = UINavigationController(rootViewController: mClassNameVeiwController)
        let mClassNameNormalImage = UIImage(named: "list_nor")?.withRenderingMode(.alwaysOriginal)
        let mClassNameSelectedImage = UIImage(named: "list_sel")?.withRenderingMode(.alwaysOriginal)
        let mClassNameTabBarItem = UITabBarItem(title: "班级列表", image: mClassNameNormalImage, selectedImage: mClassNameSelectedImage)
        mClassNameNavCtontroller.tabBarItem = mClassNameTabBarItem

        
        
        
        // 分类页
        /*
        let mCategoryViewController = UIStoryboard(name: "CategoryPage", bundle: nil).instantiateViewController(withIdentifier: "CategoryPage") as! CategoryPageViewController
        let mCategoryNavController = UINavigationController(rootViewController: mCategoryViewController)
        let mCategoryNormalImage = UIImage(named: "main_bottom_feedback_n")?.withRenderingMode(.alwaysOriginal)
        let mCategorySelectedImage = UIImage(named: "main_bottom_feedback_p")?.withRenderingMode(.alwaysOriginal)
        let mCategoryTabBarItem = UITabBarItem(title: "课程", image: mCategoryNormalImage, selectedImage: mCategorySelectedImage)
        mCategoryTabBarItem.setTitleTextAttributes(attributes, for: .normal)
        if #available(iOS 9.0, *) {
            mCategoryTabBarItem.setTitleTextAttributes(attributesPressed, for: .focused)
        } else {
            // Fallback on earlier versions
        }
        mCategoryNavController.tabBarItem = mCategoryTabBarItem
        */
        
        let mCourseViewController = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "CoursePage") as! CourseViewController
        let mCourseNavCtontroller = UINavigationController(rootViewController: mCourseViewController)
        let mCourseNormalImage = UIImage(named: "main_bottom_feedback_n")?.withRenderingMode(.alwaysOriginal)
        let mCourseSelectedImage = UIImage(named: "main_bottom_feedback_p")?.withRenderingMode(.alwaysOriginal)
        let mCourseTabBarItem = UITabBarItem(title: "课程", image: mCourseNormalImage, selectedImage: mCourseSelectedImage)
        mCourseTabBarItem.setTitleTextAttributes(attributes, for: .normal)
        mCourseNavCtontroller.tabBarItem = mCourseTabBarItem
        
        // 成员页面
        let mMemberViewController = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "Member") as! MemberViewController
        let mMemberNavController = UINavigationController(rootViewController: mMemberViewController)
        let mMemberNormalImage = UIImage(named: "user_nor")?.withRenderingMode(.alwaysOriginal)
        let mMemberSelectedImage = UIImage(named: "user_sel")?.withRenderingMode(.alwaysOriginal)
        let mShopCarTabBar = UITabBarItem(title: "成员", image: mMemberNormalImage, selectedImage: mMemberSelectedImage)
        mShopCarTabBar.setTitleTextAttributes(attributes, for: .normal)
        if #available(iOS 9.0, *) {
            mShopCarTabBar.setTitleTextAttributes(attributesPressed, for: .focused)
        } else {
            // Fallback on earlier versions
        }
        mMemberNavController.tabBarItem = mShopCarTabBar
        
        // 用户主页
        let mUserMineViewController = UIStoryboard(name: "UserMine", bundle: nil).instantiateViewController(withIdentifier: "UserMine") as! UserMineViewController
        let mUserMineNavController = UINavigationController(rootViewController: mUserMineViewController)
        let mUserMineNormalImage = UIImage(named: "Conduc_nor")?.withRenderingMode(.alwaysOriginal)
        let mUserMineSelectedImage = UIImage(named: "Conduc_sel")?.withRenderingMode(.alwaysOriginal)
        let mUserMineTabBar = UITabBarItem(title: "统计", image: mUserMineNormalImage, selectedImage: mUserMineSelectedImage)
        mUserMineTabBar.setTitleTextAttributes(attributes, for: .normal)
        if #available(iOS 9.0, *) {
            mUserMineTabBar.setTitleTextAttributes(attributesPressed, for: .focused)
        } else {
            // Fallback on earlier versions
        }
        mUserMineNavController.tabBarItem = mUserMineTabBar
        
        
        // 导航控制器
        let mTabArray = [mHomeNavController,mClassNameNavCtontroller,mCourseNavCtontroller,mMemberNavController,mUserMineNavController]
        let mTabBarController = UITabBarController()
        mTabBarController.viewControllers = mTabArray
        
        self.window!.rootViewController = mTabBarController
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: INSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = INSPersistentContainer(name: "RollCall")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}

