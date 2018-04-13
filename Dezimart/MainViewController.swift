//
//  MainViewController.swift
//  Dezimart
//
//  Created by 平岩郁人 on 2017/10/24.
//  Copyright © 2017年 ikuto. All rights reserved.
//

import UIKit
import Kanna
import SDWebImage

let queue = OperationQueue()

var Load_Flag = 0
var string_i = 0
var string_i_in = 0
var title_i = 0

class MainViewController: UIViewController ,UIScrollViewDelegate{
    
    @IBOutlet var Main_Scroll_View: UIScrollView!       //スクロールビュー
    @IBOutlet weak var Img_Scroll: UIScrollView!        //トピックスクロール用ビュー
    @IBOutlet weak var View_Scroll: UIView!             //Page貼り付け用ビュー
    
    @IBOutlet weak var New_ItemPage: UIPageControl!     //PageControll
    
    @IBOutlet weak var New_Item_Scroll: UIScrollView!       //新着商品の貼り付け用スクロールビュー
    var refreshControl:UIRefreshControl!
    
    var new_img_url : [String] = []       //新着商品imgのurl
    var new_item_url : [String] = []      //新着商品のurl
    var new_item_title : [String] = []    //新着商品のタイトル
    var new_item_price : [String] = []    //新着商品の値段
    var new_item_use : [String] = []      //新着商品の状態
//    var new_item_shop : String = ""   //新着商品の店
    
    var topic_url : [String] = []
    var topic_img : [String] = []
    
    var Topic_Image_View : [UIImageView] = []
    var New_Item_Img : [UIImageView] = []
    var New_Item_Title : [UILabel] = []
    var New_Item_Price : [UILabel] = []
    var New_Item_Use : [UILabel] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
        let ScreenSize : CGSize = UIScreen.main.bounds.size         //スクリーンのサイズを元に取
            self.Main_Scroll_View.tag = 3            //ルート画面のビューのタグを3に設定
            self.Main_Scroll_View.contentSize = CGSize(width:ScreenSize.width,height:ScreenSize.height*2)
    
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
            self.Main_Scroll_View.addSubview(self.refreshControl)

        
        let doc : HTMLDocument
        let url = NSURL(string: "https://www.digimart.net")
        let data = NSData(contentsOf: url! as URL)
        do{
            doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
            for node in (doc.body?.css("li"))! {
                if ((node.className ?? String()).contains("ProductBox")){   //li属性のclass名を元に抽出
                   
                    self.NewItem_get(node: node)                         //新着商品の情報抽出
                    
                  //  NewItem_get(node: node)                         //新着商品の情報抽出
                   
                    print("***************************************************************")
                }
            }
            var li_i_href = 0
            var li_i_img = 0
    
        
            for node in (doc.body?.css("ul"))!{
                if((node.className ?? String()) == "slides"){       //ul属性のclass名を元に抽出
                    for li_node in node.css("li") {                 //li要素ごとに画像が2枚ずつ配置されている
                        for li_node_a in li_node.css("a"){          //画像のLinkURLを取り出す
                            let tpoic_inner_url = li_node_a["href"]
                            if Load_Flag == 0{
                                self.topic_url.append(tpoic_inner_url ?? String())       //配列に格納
                                //print( tpoic_inner_url ?? String())
                            }else{
                                self.topic_url[li_i_href] = tpoic_inner_url ?? String()
                                li_i_href = li_i_href + 1
                            }
                        }
                        
                        //print("++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                        
                        for li_node_img in li_node.css("img"){          //画像のURLを取り出す
                            let topic_inner_img = li_node_img["src"]
                            if Load_Flag == 0{
                                self.topic_img.append(topic_inner_img ?? String())       //配列に格納
                                    //print(topic_inner_img ?? String())
                            }else{
                                self.topic_img[li_i_img] = topic_inner_img ?? String()
                                li_i_img = li_i_img + 1
                            }
                        }
                    }
                }
            }

        }catch{
            print("Error.")
        }
        
/*------------------------------------Topic画像の配置----------------------------------*/

        
            var x_point = 6                                 //フレーム端からの距離
            var y_point = 9                                 //フレーム上部からの距離
            let frame_width = ScreenSize.width/2                        //スクリーンの横半分の大きさ
            let frame_height = (3*(frame_width - 9))/7                //スクリーンの横半分を元に画像の縦サイズを決定
        
            self.Img_Scroll.frame = CGRect(x:0,y:0,width:Int(frame_width*2),height:Int(frame_height*2 + 27))         //スクリーンの大きさから画像配置のスクロールビューの大きさを決定
            
           // Img_Scroll.isPagingEnabled = true         //ページング表示にする場合に使用
            let img_count = self.topic_img.count/2           //コンテンツサイズ決定に用いる
            self.Img_Scroll.showsVerticalScrollIndicator = false;        //スクロールバーの横を非表示
            self.Img_Scroll.indicatorStyle = UIScrollViewIndicatorStyle.black
            self.Img_Scroll.contentSize = CGSize(width:Int(Int(frame_width)*img_count),height:Int(frame_height*2 + 27))      //スクロールビュー内のサイズを決定
        
    
        if Load_Flag == 0{
            for i in 0 ..< self.topic_img.count {        //画像の数だけ生成
                if(i%2 != 0){                       //偶数個目の画像を上に配置
                    y_point = y_point + Int(frame_height) + 9       //画像を配置する位置をずらす
                }else{                              //奇数個目は下に配置
                    y_point = 9
                    if(i != 0){
                        x_point = x_point + Int(frame_width)        //画像を配置する位置をずらす
                    }
                }
                self.Topic_Image_View.append(UIImageView(frame:CGRect(x:x_point,y:y_point,width:Int(frame_width - 9),height:Int(frame_height))))             //画像のサイズ、配置位置を設定
                let Topic_img_url = URL(string:self.topic_img[i])
                self.Topic_Image_View[i].sd_setImage(with:Topic_img_url)        //画像をURLからセット
                
                self.Img_Scroll.addSubview(self.Topic_Image_View[i])                 //画像をトピックスクロールビューに追加
                // print(i, "/")            //Debug
            }
        }else{
            for i in 0 ..< self.topic_img.count {
                let Topic_img_url = URL(string:self.topic_img[i])
                self.Topic_Image_View[i].sd_setImage(with:Topic_img_url)        //画像をURLからセット
                self.Img_Scroll.addSubview(self.Topic_Image_View[i])                  //画像をトピックスクロールビューに追加
            }
        }
    
/*--------------------------------------------------------------------------------*/
/*------------------------------------新着商品の配置----------------------------------*/
        //    let frame_width = ScreenSize.width/2
            let new_item_y = Img_Scroll.bounds.height
            let new_item_frame_width = ScreenSize.width/3
            View_Scroll.frame = CGRect(x:0,y:Int(new_item_y + 10),width:Int(frame_width*2),height:Int(new_item_frame_width * 1.9))  //Viewの大きさを設定
            New_Item_Scroll.frame = CGRect(x:0,y:0,width:Int(frame_width*2),height:Int(new_item_frame_width * 1.9))             //Viewの中のScrollViewの大きさを設定
            New_Item_Scroll.showsVerticalScrollIndicator = false;        //スクロールバーの横を非表示
            New_Item_Scroll.showsHorizontalScrollIndicator = false;        //スクロールバーの下のバーを非表示
            New_Item_Scroll.contentSize = CGSize(width:Int(Int(new_item_frame_width)*new_item_url.count),height:Int(new_item_frame_width * 1.9))                //ScrollViewのView領域を設定
            var new_item_x_point = 6            //横の余白
            let new_item_y_point = 6            //縦の余白
        
        
        if Load_Flag == 0{
            for i in 0 ..< self.new_item_url.count{              //新着商品の数だけ実行
                self.New_Item_Img.append(UIImageView(frame:CGRect(x:new_item_x_point,y:new_item_y_point,width:Int(new_item_frame_width - 6),height:Int(new_item_frame_width - 6))))      //画像配置用のimageView設定
                let New_img = URL(string:self.new_img_url[i])
                self.New_Item_Img[i].sd_setImage(with: New_img)                 //画像URLから画像を設定
                self.New_Item_Scroll.addSubview(self.New_Item_Img[i])                //ScrollViewに追加
                
                self.New_Item_Title.append(UILabel(frame:CGRect(x:Int(new_item_x_point + 3),y:Int(new_item_frame_width),width:Int(new_item_frame_width - 12),height:Int(new_item_frame_width - 6)/3)))          //商品タイトル配置用のラベル設定
                self.New_Item_Title[i].text = self.new_item_title[i]
                self.New_Item_Title[i].font = UIFont(name:"Cochin",size:new_item_frame_width/10)
                self.New_Item_Title[i].textAlignment = NSTextAlignment.center      //中央揃い
                self.New_Item_Title[i].numberOfLines = 3                            //行数
               // New_Item_Title.textColor = UIColor(red:0,green:75,blue:255,alpha:1.0)
                self.New_Item_Scroll.addSubview(self.New_Item_Title[i])          //ScrollViewに追加
                
                self.New_Item_Price.append(UILabel(frame:CGRect(x:Int(new_item_x_point-3),y:Int(new_item_frame_width + self.New_Item_Title[i].bounds.height),width:Int(new_item_frame_width - 12),height:Int(new_item_frame_width - 6)/4)))        //価格配置用のラベル設定
                self.New_Item_Price[i].text = self.new_item_price[i]
                self.self.New_Item_Price[i].font = UIFont(name:"Cochin",size:new_item_frame_width/8)
                self.New_Item_Price[i].textAlignment = NSTextAlignment.center
                self.New_Item_Price[i].textColor = UIColor.red
                self.New_Item_Price[i].numberOfLines = 1
                self.New_Item_Scroll.addSubview(self.New_Item_Price[i])
                
                self.New_Item_Use.append(UILabel(frame:CGRect(x:Int(new_item_x_point),y:Int(new_item_frame_width + self.New_Item_Title[i].bounds.height + self.New_Item_Price[i].bounds.height),width:Int(new_item_frame_width - 15),height:Int(new_item_frame_width-6)/6)))         //状態配置用のラベル
                self.New_Item_Use[i].text = self.new_item_use[i]
                self.New_Item_Use[i].font = UIFont(name:"Cochin",size:new_item_frame_width/9)
                self.New_Item_Use[i].textAlignment = NSTextAlignment.center
                self.New_Item_Use[i].textColor = UIColor.blue
                self.New_Item_Use[i].numberOfLines = 1
                self.New_Item_Scroll.addSubview(self.New_Item_Use[i])
                
                new_item_x_point = new_item_x_point + Int(new_item_frame_width) - 1         //配置した分ずらして次のx座標を設定
            }
        
        }else{
            for i in 0 ..< self.new_img_url.count{
                let New_img = URL(string:self.new_img_url[i])
                self.New_Item_Img[i].sd_setImage(with: New_img)                 //画像URLから画像を設定
                self.New_Item_Scroll.addSubview(self.New_Item_Img[i])                //ScrollViewに追加
                
                self.New_Item_Title[i].text = self.new_item_title[i]
                self.New_Item_Scroll.addSubview(self.New_Item_Title[i])          //ScrollViewに追加
                self.New_Item_Price[i].text = self.new_item_price[i]
                self.New_Item_Scroll.addSubview(self.New_Item_Price[i])
                self.New_Item_Use[i].text = self.new_item_use[i]
                self.New_Item_Scroll.addSubview(self.New_Item_Use[i])
            }
        }
        
        
            //View_Scroll.addSubview(New_Item_Scroll)
        
            
            self.New_ItemPage.frame = CGRect(x:0,y:Int(new_item_frame_width * 1.75),width:Int(ScreenSize.width),height:Int(new_item_frame_width/7))      //ドット表示のページ番号を設定

            self.New_Item_Scroll.isPagingEnabled = true              //ScrollViewのページングを許可
          //  New_ItemPage.backgroundColor = UIColor.gray
            self.New_ItemPage.numberOfPages = self.new_item_url.count/3   //PageDotsの数を新着商品の数から決める
            self.New_ItemPage.currentPage = 0                    //初期ページ番号
            self.New_ItemPage.isUserInteractionEnabled = false       //なんか
            self.New_ItemPage.pageIndicatorTintColor = UIColor.gray      //非表示部分のドットの色
            self.New_ItemPage.currentPageIndicatorTintColor = UIColor.white      //表示部のドットの色
        
            self.Img_Scroll.tag = 0              //TopicのScrollViewのタグを0に
            self.New_Item_Scroll.tag = 1         //新着商品のScrollViewのタグを1に
        
            self.Img_Scroll.delegate = self
            self.New_Item_Scroll.delegate = self
        

/*--------------------------------------------------------------------------------*/
    }
    
/*-------------------------------新着商品の情報抽出--------------------------------*/
    func NewItem_get(node:XMLElement){
        for div in node.css("div") {                            //div属性を抽出
            //print(div.innerHTML ?? String())                  //デバッグ用
            if (div.className ?? String()).contains("pic"){     //写真、urlのある要素を抽出
                let img_inner = div.css("img").first            //imgURLを抽出
                if Load_Flag == 0{
                    new_img_url.append("https:" + (img_inner!["src"])!)
                    let item_inner = div.css("a").first             //itemURLを抽出
                    new_item_url.append("https://www.digimart.net" + (item_inner!["href"])!)
                }else{
                    new_img_url[string_i_in] = "https:" + (img_inner!["src"])!
                    let item_inner = div.css("a").first             //itemURLを抽出
                    new_item_url[string_i_in] = "https://www.digimart.net" + (item_inner!["href"])!
                    string_i_in = string_i_in + 1
                }
            }
            if (div.className ?? String()).contains("itemState"){       //価格、状態のある要素を抽出
                for item_state in div.css("p"){
                    if (item_state.className?.contains("price"))!{      //値段のある要素のコンテンツを抽出
                        if Load_Flag == 0{
                            new_item_price.append(item_state.content!)
                        }else{
                            new_item_price[string_i] = item_state.content!
                        }
                    }
                    if (item_state.className?.contains("state"))!{      //状態のある要素のコンテンツを抽出
                        if Load_Flag == 0{
                            new_item_use.append(item_state.content!)
                        }else{
                            new_item_use[string_i] = item_state.content!
                        }
                    }
                }
                if Load_Flag == 1 {
                    string_i = string_i + 1
                }
            }
        }
        //title_i = 0
        for p in node.css("p"){
            if (p.className ?? String()).contains("ttl appEllipsis"){
                if Load_Flag == 0{
                    new_item_title.append(p.content ?? String())
                }else{
                    new_item_title[title_i] = p.content ?? String()
                    print(title_i)
                    title_i = title_i + 1
                }
            }
        }
    }
/*--------------------------------------------------------------------------------*/
/*-----------------------------------y軸固定関数------------------------------------*/
    var startPoint : CGPoint!;
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView ) {
        self.startPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = self.startPoint.y
    }
/*-----------------------------現在ページのドット表示変更関数--------------------------------*/
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 1{
            if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
                // ページの場所を切り替える.
                New_ItemPage.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            }
        }
    }
/*--------------------------------------------------------------------------------*/
    @objc func refresh(sender:UIRefreshControl){
        Load_Flag = 1
        string_i_in = 0
        string_i=0
        title_i = 0
        loadView()
        viewDidLoad()
        print("Yeah!!!!")
        sender.endRefreshing()
        print("End.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



