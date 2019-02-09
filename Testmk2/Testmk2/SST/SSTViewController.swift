//
//  ViewController.swift
//  SST
//
//  Created by 123 on 2018/9/5.
//  Copyright © 2018年 123. All rights reserved.
//

import UIKit

// 预定义响应标识
// 常用于代码中代替 数值型 错误指示标识，提高代码可读性

// 错误响应标识
let INCORRECT:Int64 = -1;

// 错过响应标识
let MISS:Int64 = -2;

// 错误停止标识
let WRONGSTOP:Int64 = -3;

// 正确停止标识
let CORRECTSTOP:Int64 = 0;

// Extend date to get millis
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

class SSTViewController: UIViewController {
    var vip_id_str:String?  // 准备接收传过来的值

    // current page
    // 当前页码
    var page = 0;
    
    // current timer
    // 当前运行中的 定时器， 用于用户按键后强制停止 定时器
    var timer:Timer?;
    
    // current block index
    // 当前响应块序号
    var current = 0;
    
    // current experiment
    // 当前体验序号
    var experiment = 0;
    
    // current block
    // 当前响应块内容
    var currentBlock:String?;
    
    // determine current block has stop signal
    // 停止标识，确定当前是否有停止信号
    var stop = false;
    
    // wrong respond times
    // 错误次数，用于练习模式中展示不同提示
    var wrong = 0;
    
    // is practice mode
    // 练习标识，确定当前是否为练习模式
    var isPractice = false;
    
    // blocks
    // 响应块数组，储存本次体验的所有响应块
    var blocks:Array<String>?;
    
    // default stop respond time
    // 停止响应时间
    var stopRespondTime = 1.0;
    
    // start respond time
    // 响应计时开始时间
    var startTime:Int64?;
    
    // respond stack
    // 响应记录
    // 2维数组， 第一维为体验体验数组，第二维为响应记录
    // 用户正确响应时记录反应时间，响应错误时记录错误值，可参照预定义错误表示
    var respondStack = Array<Array<Int64>>();
    
    // X/O blocks option
    // 响应块布局设置
    let block = [
            "align":NSTextAlignment.center,
            "fontSize": 100,
            "frame":CGRect(x:UIScreen.main.bounds.width / 2 - 50, y:UIScreen.main.bounds.height/2 - 60, width: 100, height: 100)
        ] as [String : Any];
    
    // static page
    // 静态页布局
    let pages:[Dictionary<String, Any>] = [[
            "labels": [[
                "text": "On every trial, you will see an X or an O on the screen.",
                "line": 2,
                "frame": CGRect(x:20, y:20, width:UIScreen.main.bounds.width - 25, height: 80),
                "fontSize": 24
            ],
            [
                "text": "Your task is to respond as FAST and ACCURATELY as possible to these (go) stimuli:",
                "line": 3,
                "frame": CGRect(x:20, y:100, width:UIScreen.main.bounds.width - 25, height: 120),
                "fontSize": 24
            ],
            [
                "text": "Press X using your left hand when you see an X",
                "line": 2,
                "frame": CGRect(x:20, y:300, width:UIScreen.main.bounds.width - 30, height: 80),
                "range": [
                    "text": " X ",
                    "color": UIColor.green
                ]
            ],
            [
                "text": "Press O using your left hand when you see an O",
                "line": 2,
                "frame": CGRect(x:20, y:380, width:UIScreen.main.bounds.width - 30, height: 80),
                "range": [
                    "text": " O ",
                    "color": UIColor.green
                ]
            ]],
            "next": "page"
        ],
        [
            "labels": [
                [
                    "text": "Occasionally, a box will appear around the stimuli.",
                     "line": 2,
                    "frame": CGRect(x:20, y:20, width:UIScreen.main.bounds.width - 30, height: 100),
                    "fontSize": 24
                ],
                [
                    "text": "This indicates a stop trial.",
                    "frame": CGRect(x:20, y:95, width:UIScreen.main.bounds.width - 30, height: 48),
                    "fontSize": 24
                ],
                [
                    "text": "You have to STOP your response on stop trials:",
                    "line": 2,
                    "frame": CGRect(x:20, y:124, width:UIScreen.main.bounds.width - 30, height: 100),
                    "fontSize": 24
                ],
                [
                    "text": "DO NOT press any key when a box appears around the X or O",
                    "frame": CGRect(x:20, y:164, width:UIScreen.main.bounds.width - 30, height: 140),
                    "line": 2,
                    "fontSize": 24
                ],
                [
                    "text": "For example, like this: ",
                    "frame": CGRect(x:20, y:260, width:UIScreen.main.bounds.width - 30, height: 40),
                    "fontSize": 24
                ],
                [
                    "text": "X",
                    "frame": CGRect(x:UIScreen.main.bounds.width / 2 - 30, y:350, width:30, height: 60),
                    "fontSize": 40,
                    "border": UIColor.white,
                    "align": NSTextAlignment.center
                ]
            ],
            "next": "page",
        ],
        [
            "labels": [
                [
                    "text": "Respond as FAST as possible to go stimuli.",
                    "frame": CGRect(x:20, y:40, width:UIScreen.main.bounds.width - 30, height: 100),
                    "line": 2,
                    "fontSize": 24
                ],
                [
                    "text": "DO NOT WAIT for a stop signal to occur.",
                    "frame": CGRect(x:20, y:84, width:UIScreen.main.bounds.width - 30, height: 100),
                    "fontSize": 24
                ],
                [
                    "text": "Let’s do a practice block.",
                    "frame": CGRect(x:20, y:144, width:UIScreen.main.bounds.width - 40, height: 24),
                    "fontSize": 24
                ],
                [
                    "text": "Press <next page> to proceed.",
                    "frame": CGRect(x:20, y:168, width:UIScreen.main.bounds.width - 40, height: 24),
                    "fontSize": 24
                ],
                [
                    "text": "Press <skip> to go straight to the actual task.",
                     "line": 2,
                    "frame": CGRect(x:20, y:192, width:UIScreen.main.bounds.width - 30, height: 100),
                    "fontSize": 24
                ]
            ],
            "next": "practice",
            "showSkip": true
        ],
        [
            "labels": [
                [
                    "text": "Now you are done with practice.",
                    "frame": CGRect(x:20, y:40, width:UIScreen.main.bounds.width - 40, height: 40),
                ],
                [
                    "text": "Let’s begin the actual task.",
                    "frame": CGRect(x:20, y:100, width:UIScreen.main.bounds.width - 40, height: 40),
                ]
            ],
            "next": "experiment"
        ]];
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width;
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        renderLabels(labels: [[
            "text": "Welcome to Stop Signal Task",
            "align": NSTextAlignment.center,
            "frame": CGRect(x:0, y:100, width:screenWidth, height:40)
        ]]);
        
        _ = createTimer(interval: 1, repeats: false) { (timer) in
            self.clearViews();
            
            self.renderLabels(labels: [
                [
                    "text": "If this is your first time doing the Stop Signal, or you require instructions, Press <next page>",
                    "line": 3,
                    "frame": CGRect(x:20, y:20, width:self.screenWidth - 30, height: 160)
                ],
                [
                    "text": "If you have done the Stop Signal before, and don't require instructions or practice, Please press <Skip>.",
                    "line": 4,
                    "frame": CGRect(x:20, y:120, width:self.screenWidth - 30, height: 160)
                ]
            ]);
            
            self.renderFunctionalBtns();
        }
    }
    
    /**
     Clear all subviews in View
     清空视图内容
     
     - Returns: void
    */
    func clearViews() {
        view.subviews.forEach({$0.removeFromSuperview();});
    }
    
    /**
     Create Timer
     创建定时器
     
     - Parameters:
         - interval: The number of seconds between firings of the timer. If interval is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
         - repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
         - execute: A block to be executed when the timer fires.The block takes a single NSTimer parameter and has no return value.
     - Returns: Timer
    */
    func createTimer(interval: Float, repeats:Bool, execute: @escaping (Timer) -> Void) -> Timer{
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: repeats) { (Timer) in
            execute(Timer);
        }
        
        return timer;
    }
    
    /// Render labels to view
    /// 将标签渲染进视图
    /// UI 渲染核心方法
    /// UI 的渲染我已经与实际控制代码进行分离，该方法内只进行控件的生成，并添加进视图里
    ///
    /// - Parameter labels: an Array with Label options
    ///
    /// - Returns: void
    func renderLabels(labels: Array<Dictionary<String, Any>>) {
        for item in labels {
            
            // create label instance
            let label:UILabel = UILabel(frame:item["frame"] as! CGRect);
            
            // determine label has color with special word
            if let range = item["range"] as? Dictionary<String, Any> {
                
                let string = item["text"] as? String;
                
                // get special range
                let stringRange = (string! as NSString).range(of: range["text"] as! String);
                
                // generate attribute string
                let at = NSMutableAttributedString.init(string: string!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]);
                
                // set color to special word
                at.addAttribute(.foregroundColor, value: range["color"] as! UIColor, range: stringRange);
                label.attributedText = at;
            } else {
                label.text = item["text"] as? String;
                
                if let color = item["color"] as? UIColor {
                    label.textColor = color;
                } else {
                    label.textColor = UIColor.white;
                }
            }
            
            // set label's line number
            if let line = item["line"] as? Int {
                label.numberOfLines = line;
            } else {
                label.numberOfLines = 1;
            }
            
            // set label's font size
            if let fontsize = item["fontSize"] as? Int {
                label.font = UIFont.systemFont(ofSize: CGFloat(fontsize));
            } else {
                label.font = UIFont.systemFont(ofSize: 24);
            }
            
            // set label's text alignment
            if let align = item["align"] as? NSTextAlignment {
                label.textAlignment = align;
            } else {
                label.textAlignment = .justified;
            }
            
            // set label's border
            if let border = item["border"] as? UIColor {
                label.layer.borderColor = border.cgColor;
                label.layer.borderWidth = 1;
            }
            
            self.view.addSubview(label);
        }
    }
    
    /// Render buttons to view
    ///
    /// - Parameter btns: an Array with buttons options
    ///
    /// - Returns: void
    func renderBtns(btns: Array<Dictionary<String,Any>>) {
        for item in btns {
            // create button instance
            let btn:UIButton = UIButton(frame: item["frame"] as! CGRect);
            
            // set button title
            btn.setTitle(item["text"] as? String, for:UIControlState.normal);
            
            // set button title font size
            if let fontsize = item["fontSize"] as? Int {
                btn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize));
            } else {
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 32);
            }
            
            // set handler when button clicked
            if let target = item["target"] as? Selector {
                btn.addTarget(self, action: target, for: .touchUpInside);
            }
            
            if let vertical = item["verticalAlign"] as? UIControlContentVerticalAlignment {
                btn.contentVerticalAlignment = vertical;
            }
            
            if let horizon = item["horizonAlign"] as? UIControlContentHorizontalAlignment {
                btn.contentHorizontalAlignment = horizon;
            }
            
            if let color = item["color"] as? UIColor {
                btn.setTitleColor(color, for:.normal);
            }
            
            self.view.addSubview(btn);
        }
    }
    
    /// Render functional buttons
    func renderFunctionalBtns(showSkip: Bool = true, nextSelector: Selector = #selector(nextBtnClicked)) {
        var btns = [[
            "text": "<Next Page>",
            "frame": CGRect(x:screenWidth - 240, y:screenHeight - 60, width: 220, height: 40),
            "target": nextSelector
            ]];
        
        if showSkip {
            btns.append([
                "text": "<Skip>",
                "frame": CGRect(x:20, y:screenHeight - 60, width: 120, height: 40),
                "target": #selector(skipBtnClicked)
                ]);
        }
        
        renderBtns(btns: btns);
    }
    
    /// Render respond buttons
    func renderRespondBtns() {
        renderBtns(btns: [[
            "text": "X",
            "frame": CGRect(x:20, y:20, width: screenWidth/2 - 20, height: screenHeight - 40),
            "target": #selector(xBtnClicked),
            "verticalAlign": UIControlContentVerticalAlignment.bottom,
            "horizonAlign": UIControlContentHorizontalAlignment.left,
            "color": UIColor.green
            ],[
                "text": "O",
                "frame": CGRect(x:screenWidth/2, y:20, width: screenWidth/2 - 20, height: screenHeight - 40),
                "target": #selector(oBtnClicked),
                "verticalAlign": UIControlContentVerticalAlignment.bottom,
                "horizonAlign": UIControlContentHorizontalAlignment.right,
                "color": UIColor.green
            ]]);
    }
    
    // handle X button clicked
    @objc func xBtnClicked() {
        clearViews();
        
        // stop timer
        timer?.invalidate();
        
        if stop {
            return wrongStopRespond();
        }
        
        // calc respond time
        let endTime = Date().toMillis() - startTime!;

        if currentBlock! == "X" {
            correctRespond(endTime: endTime);
        } else {
            wrongRespond();
        }
    }
    
    // Handle O button clicked
    @objc func oBtnClicked() {
        clearViews();
        
        timer?.invalidate();
        
        if stop {
            return wrongStopRespond();
        }
        
        // calc respond time
        let endTime = Date().toMillis() - startTime!;

        if currentBlock! == "O" {
            correctRespond(endTime:endTime);
        } else {
            wrongRespond();
        }
    }
    
    /// Handle correct respond
    /// - Parameter endTime: respond time
    ///
    func correctRespond(endTime: Int64) {
        clearViews();
        if isPractice {
            var label = [
                "text": "Hit",
                "align":NSTextAlignment.center,
                "frame":CGRect(x:0, y:screenHeight/2 - 20, width: screenWidth, height: 40)
                ] as [String : Any];
            
            if endTime < 500 {
                label["color"] = UIColor.green;
            } else if endTime < 750 {
                label["color"] = UIColor.yellow;
            } else {
                label["color"] = UIColor.red;
            }
            
            renderLabels(labels: [label]);
        }
        
        respondStack[experiment].append(endTime);
        
        _ = createTimer(interval: isPractice ? 2 : 1, repeats: false, execute: { (timer) in
            self.renderSST();
        });
    }
    
    /// Handle wrong respond
    /// - Parameter string: wrong message
    ///
    func wrongRespond(string:String = "incorrect button") {
        clearViews();
        
        if isPractice {
            wrong += 1;
            
            var label = [
                "text": String(format:"Miss (%@)", string),
                "align":NSTextAlignment.center,
                "frame":CGRect(x:0, y:screenHeight/2 - 20, width: screenWidth, height: 40),
                "color": UIColor.red
                ] as [String : Any];
            
            if wrong >= 3 {
                label["text"] = "You MUST stimuli faster";
                wrong = 0;
            }
            
            renderLabels(labels: [label]);
        }
        
        respondStack[experiment].append(string == "incorrect button" ? INCORRECT : MISS);
        
        _ = createTimer(interval: isPractice ? 2 : 1, repeats: false, execute: { (timer) in
            self.renderSST();
        });
    }
    
    /// Handle correct stop respond
    func correctStopRespond() {
        clearViews();
        
        if isPractice {
            renderLabels(labels:[[
                "text": "Successful stop - Well done!",
                "align":NSTextAlignment.center,
                "frame":CGRect(x:0, y:screenHeight/2 - 20, width: screenWidth, height: 40),
                "color": UIColor.green
                ]]);
        }
        
        respondStack[experiment].append(CORRECTSTOP);
        
        stopRespondTime -= 0.05;
        
        _ = createTimer(interval: isPractice ? 2 : 1, repeats: false, execute: { (timer) in
            self.renderSST();
        });
    }
    
    /// handle wrong stop respond
    func wrongStopRespond() {
        clearViews();
        
        if isPractice {
            renderLabels(labels:[[
                "text": "Unsuccessful stop",
                "align":NSTextAlignment.center,
                "frame":CGRect(x:0, y:self.screenHeight/2 - 20, width: self.screenWidth, height: 40),
                "color": UIColor.red
                ],[
                    "text": "You shouldn't pressed any button",
                    "align":NSTextAlignment.center,
                    "frame":CGRect(x:0, y:self.screenHeight/2 + 20, width: self.screenWidth, height: 40),
                    "color": UIColor.red
                ]]);
        }
        
        respondStack[experiment].append(WRONGSTOP);
        
        stopRespondTime += 0.05;
        
        _ = createTimer(interval: isPractice ? 2 : 1, repeats: false, execute: { (timer) in
            self.renderSST();
        });
    }
    
    /// render next pages when next button clicked
    @objc func nextBtnClicked() {
        let pageLabels = pages[page]["labels"] as? Array<Dictionary<String,Any>>;
        let next = pages[page]["next"] as? String;
        let showSkip = pages[page]["showSkip"] as? Bool;
        
        renderPage(labels: pageLabels!);
        
        if next == "page" {
            if showSkip != nil {
                renderFunctionalBtns(showSkip: showSkip!);
            } else {
                renderFunctionalBtns(showSkip: false);
            }
            
            page += 1;
        } else if next  == "practice" {
            if showSkip != nil {
                renderFunctionalBtns(showSkip: showSkip!, nextSelector: #selector(renderPractice));
            } else {
                renderFunctionalBtns(showSkip: false, nextSelector: #selector(renderPractice));
            }
        } else {
            if showSkip != nil {
                renderFunctionalBtns(showSkip: showSkip!, nextSelector: #selector(renderExperiment));
            } else {
                renderFunctionalBtns(showSkip: false, nextSelector: #selector(renderExperiment));
            }
        }
    }
    
    @objc func skipBtnClicked() {
        renderExperiment();
    }
    
    /// render page label
    func renderPage(labels: Array<Dictionary<String,Any>>) {
        clearViews();
        renderLabels(labels: labels);
    }
    
    // Render practice
    @objc func renderPractice() {
        clearViews();
        
        isPractice = true;
        reset();
        respondStack.append(Array<Int64>());
        
        renderLabels(labels: [[
            "text": "Practice Block",
            "align":NSTextAlignment.center,
            "frame":CGRect(x:0, y:screenHeight/2 - 20, width: screenWidth, height: 40)
        ]]);
        
        _ = createTimer(interval: 0.75, repeats: false) { (timer) in
            self.clearViews();
            self.renderLabels(labels:[[
                "text": "(wait)",
                "align":NSTextAlignment.center,
                "frame":CGRect(x:0, y:self.screenHeight/2 - 20, width: self.screenWidth, height: 40)
                ]]);
        };
        
        _ = createTimer(interval: 1.75, repeats: false) { (timer) in
            self.clearViews();
            self.renderLabels(labels:[[
                "text": "+",
                "align":NSTextAlignment.center,
                "fontSize": 120,
                "frame":CGRect(x:0, y:self.screenHeight/2 - 60, width: self.screenWidth, height: 80)
                ],[
                "text": "(get ready)",
                "align":NSTextAlignment.center,
                "frame":CGRect(x:0, y:self.screenHeight/2 + 40, width: self.screenWidth, height: 40)
                ]]);
        };
        
        _ = createTimer(interval: 2, repeats: false) { (timer) in
            
            self.clearViews();
            self.renderSST();
        };
    }
    
    /// Render Experiment
    /// 渲染体验流程
    @objc func renderExperiment() {
        // 确定体验次数是否小于4次， 如果大于4次 则返回初始界面
        if(experiment < 4) {
            clearViews();
            
            // 初始化当前体验数据缓存数组
            respondStack.append(Array<Int64>());
            
            // 重置部分记录序号
            reset();
            
            self.renderLabels(labels:[[
                "text": "+",
                "align":NSTextAlignment.center,
                "fontSize": 120,
                "frame":CGRect(x:0, y:self.screenHeight/2 - 60, width: self.screenWidth, height: 80)
                ]]);
            
            // 创建响应定时器
            _ = createTimer(interval: 2, repeats: false) { (timer) in
                self.renderSST();
            };
        } else {
            self.performSegue(withIdentifier: "SSTtoSelection", sender: vip_id_str)
            // 重置记录
//            reset();
//            // 重置体验序号
//            experiment = 0;
//            // 清除响应数据缓存
//            respondStack.removeAll();
//            
//            // 返回初始页面
//            page = 0;
//            
//            self.clearViews();
//            
//            self.renderLabels(labels: [
//                [
//                    "text": "If this is your first time doing the Stop Signal, or you require instructions, Press <next page>",
//                    "line": 2,
//                    "frame": CGRect(x:20, y:20, width:self.screenWidth - 40, height: 80)
//                ],
//                [
//                    "text": "If you have done the Stop Signal before, and do not require instructions or practice, Press <skip>.",
//                    "line": 2,
//                    "frame": CGRect(x:20, y:120, width:self.screenWidth - 40, height: 80)
//                ]
//                ]);
//            
//            self.renderFunctionalBtns();
        }
    }
    
    /// Render Stop Signal Task
    func renderSST() {
        // 需要渲染的 标签数组
        var labels = Array<Dictionary<String, Any>>();
        // 获取 响应块 的默认设置
        var block = self.block;
        
        clearViews();
        
        // 确定当前体验是否完结
        if current < (blocks?.count)! {
            // 获取当前响应块内容
            currentBlock = blocks?[current];
            
            // 确定是否有停止信号 几率为 25%
            stop = stopSignal();
            
            // 当前块序号自增
            current += 1;
            
            // 记录响应开始时间
            startTime = Date().toMillis();
            
            // 确定是否为练习模式， 如果是 给响应反馈添加提示
            if isPractice {
                var tipsLabel = [
                    "text": String(format:"(press %@ as fast as possible)", currentBlock!),
                    "align":NSTextAlignment.center,
                    "frame":CGRect(x:0, y:self.screenHeight/2 + 40, width: self.screenWidth, height: 40),
                    "range": [
                        "color": UIColor.green,
                        "text": String(format:" %@ ", currentBlock!)
                    ]
                    ] as [String : Any];
                
                if stop {
                    tipsLabel["text"] = "Do not press any key";
                }
                
                labels.append(tipsLabel);
            }
            
            block["text"] = currentBlock as AnyObject?;
            
            if stop {
                block["border"] = UIColor.white;
            }
            
            labels.append(block);
            
            renderLabels(labels: labels);
            renderRespondBtns();
            
            // 确定是否为停止响应块创建不同的定时器
            if stop {
                timer = createTimer(interval: Float(stopRespondTime), repeats: false, execute: { (timer) in
                    self.correctStopRespond();
                });
            } else {
                timer = createTimer(interval: 1, repeats: false, execute: { (timer) in
                    self.wrongRespond(string: "you must go faster");
                });
            }
        } else {
            // 体验完结后，渲染结果统计
            renderResult();
        }
    }
    
    /// Render result
    func renderResult() {
        clearViews();
        
        var title = [
            "text": String(format: "Results of Block %li:", experiment + 1),
            "frame":CGRect(x:20, y:30, width: self.screenWidth, height: 24),
            "fontSize": 24
            ] as [String: Any];
        
        // get current stack
        // 获取当前体验的响应数据
        let stack = respondStack[experiment];
        print(stack[0])
    
        // filter miss
        // 过滤出 miss
        let miss = stack.filter { $0 == MISS };
//        print(miss)
        // filter incorrect
        // 过滤出 错误反应 不包含停止响应
        let incorrect = stack.filter { $0 == INCORRECT };
//        print(incorrect)
        // filter stop
        // 过滤出 所以停止响应
        let stop = stack.filter { $0 == CORRECTSTOP || $0 == WRONGSTOP };
//        print(stop)
        // filter success stop
        // 过滤出正确停止的响应
        let success = stop.filter { $0 == CORRECTSTOP };
//        print(success)
        // calc success top percent
        // 计算停止成功的几率
        let successPercent = Float(success.count) / Float(stop.count) * 100;
        
        // filter fast respond
        // 过滤出 小于 500ms 的响应
        let fast = stack.filter { $0 <= 500 && $0 > 0 };
        
        // filter fast respond
        let slow = stack.filter { $0 > 500 };
        
        // init count down
        // 创建倒计时
        var count = 0;
        
        // 确认是否为练习模式，如果是则修改标题并清除缓存的数据
        if isPractice {
            title["text"] = "Results of Practice Block";
            
            experiment = 0;
            respondStack.removeAll();
        } else {
            // 体验序号自增
            experiment += 1;
        }
        
        // 创建结果页倒计时
        _ = createTimer(interval: 1, repeats: true) { (timer) in
            
            self.clearViews();
            
            // increase count down
            count += 1;
            
            // 渲染标签
            self.renderLabels(labels:[title,
                                 [
                                    "text": String(format: "Incorrect respondses: %li", incorrect.count),
                                    "frame":CGRect(x:20, y:60, width: self.screenWidth, height: 24),
                                    "fontSize": 24
                ],[
                    "text": String(format: "Miss respondses: %li", miss.count),
                    "frame":CGRect(x:20, y:90, width: self.screenWidth, height: 24),
                    "fontSize": 24
                ],[
                    "text": fast.count > slow.count ? "" : "Too slow! Respond faster",
                    "frame":CGRect(x:20, y:120, width: self.screenWidth, height: 24),
                    "fontSize": 24
                ],[
                    "text": String(format: "Success Stop: %.02f%%", successPercent),
                    "frame":CGRect(x:20, y:150, width: self.screenWidth, height: 24),
                    "fontSize": 24
                ],[
                    "text": String(format: "Second left to wait: %li", 10 - count),
                    "frame":CGRect(x:20, y:180, width: self.screenWidth, height: 24),
                    "fontSize": 24
                ]]);
          
            
            // stop timer and render next page
            // 倒计时结束时 停止定时器 并开始 下一个体验流程 或者 回到初始页面
            if (count == 9) {
                timer.invalidate();
                let loginUrl = "http://10.0.0.2:8888/SSTrecording.php"
                let loginUrl1 = "http://10.0.0.2:8888/SSTreaction.php"
                let params = ["username":self.vip_id_str,"experimentNumber": String(self.experiment),"correct": String(10 - incorrect.count -  miss.count),"incorrect": String(incorrect.count),"miss":String(miss.count),"successStopPercent":String(successPercent)]
//                print(String(10 - incorrect.count -  miss.count))
                var result = [String]()
                for num in stack{
                    if num == 0 {
                        result.append("Successful Stop")
                    }
                    else if num == -2{
                        result.append("Miss")
                    }
                    else if num == -1{
                        result.append("Wrong Click")
                    }
                    else if num == -3{
                        result.append("Unsuccessful stop")
                    }
                    else{
                        result.append(String(num)+"ms")
                    }
                }
                let params1 = ["username":self.vip_id_str,"experimentNumber": String(self.experiment),"reaction1":result[0],"reaction2":result[1],"reaction3":result[2],"reaction4":result[3],"reaction5":result[4],"reaction6":result[5],"reaction7":result[6],"reaction8":result[7],"reaction9":result[8],"reaction10":result[9]]
                NetworkTools.shareInstance.request(methodType: .POST, urlString: loginUrl, parameters: params as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
                    
                    if error != nil  {
                        print(error!)
                        return
                    }
                }
                NetworkTools.shareInstance.request(methodType: .POST, urlString: loginUrl1, parameters: params1 as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
                    
                    if error != nil  {
                        print(error!)
                        return
                    }
                }
                if self.isPractice {
                    self.isPractice = false;
                    self.page += 1;
                    self.nextBtnClicked();
                } else {
                    self.renderExperiment();
                }
            }
        };
    }
    
    // reset default options
    func reset() {
        stopRespondTime = 1;
        blocks = generateBlocks();
        current = 0;
    }
    
    /// Determine stop signal
    func stopSignal() -> Bool {
        
        // generate random number
        let rand = Int(arc4random_uniform(100));
        
        // determine random number in stop range
        if rand > 25 && rand < 50 {
            return true;
        }
        
        return false
    }
    
    /// Generate blocks
    /// 生成 X/O
    /// 先生成一个 X/O 数组，根据给定的总数 对半分配 X/O的数量
    /// 生成了数组之后，调用 洗牌方法 shuffleBlocks() 将数组打乱 形成一个随机的包含 X/O 内容的数组
    /// - Parameter number: generate number
    /// - Returns: Blocks array
    func generateBlocks(_ number: Int = 10) -> Array<String> {
        var result = [String]();
        
        for i in 0..<number {
            if i < number/2 {
                result.append("X");
            } else {
                result.append("O");
            }
        }
        
        return shuffleBlocks(blocks: result);
    }
    
    /// Random shuffle blocks
    /// 打乱给定的数组
    ///
    /// - Parameter blocks: an array with Blocks
    /// - Returns: shuffled Blocks array
    func shuffleBlocks(blocks:Array<String>) -> Array<String> {
        var temp = blocks;
        var shuffled = [String]();
        
        repeat{
            let rand = Int(arc4random_uniform(UInt32(temp.count)));
            
            shuffled.append(temp[rand]);
            temp.remove(at:rand);
        } while temp.count > 0
        
        return shuffled;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SSTtoSelection"{ // 如果 标识符 是 toSST
            // 获取要跳转的视图的控制器
            let controller = segue.destination as! SelectionViewController // HomeViewController 被传递的视图的控制器
            // 设置要跳转的视图的控制器 哪个变量（vip_id_str） 接收 传递过去的值（vip_id）
            controller.vip_id_str = sender as? String                 // vip_id_str         被传递的视图的控制器 的 对应变量
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

