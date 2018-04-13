//
//  GuitarViewController.swift
//  Dezimart
//
//  Created by 平岩郁人 on 2017/10/24.
//  Copyright © 2017年 ikuto. All rights reserved.
//

import UIKit
import Kanna
import SDWebImage

var guitar_title : [String] = []
var guitar_url : [String] = []
var guitar_inner : [String] = []
var guitar_date : [String] = []
var guitar_shop_name : [String] = []
var guitar_shop_url : [String] = []
var guitar_use : [[String]] = [[]]
var guitar_pic_url : [String] = []
var guitar_price : [String] = []
var guitar_ship_price : [String] = []
var guitar_state : [String] = []
var guitar_soldout : [String] = []

var guitar_model : [GuitarCellModel] = [GuitarCellModel]()

var guitar_use_count = 0

var Guitar_Flag = 0
var Guitar_Refresh = 0

let ScreenSize : CGSize = UIScreen.main.bounds.size         //スクリーンのサイズを元に取

class GuitarViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var Table_View_Guitar: UITableView!
    
    var refreshControl_guitar:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.refreshControl_guitar = UIRefreshControl()
        self.refreshControl_guitar.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl_guitar.addTarget(self, action: #selector(GuitarViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        Table_View_Guitar.addSubview(refreshControl_guitar)
        
        let nib = UINib(nibName:"GuitarCustomCell",bundle:nil)
        Table_View_Guitar.register(nib, forCellReuseIdentifier: "GuitarCell")
        
        let url = NSURL(string: "https://www.digimart.net/search?fretOption=&nosalep=false&keywordOr=&dispMode=ALL&soldoutDisp=false&specOption=&weightOptionTo=&brandnames=&brandnames=&brandnames=&conditionFrom=&brandId=&keywordNot=&keywordPhrase=&movieurlp=&freeshippingp=&salep=&bodyOption=&neckOption=&topMaterialOption=&parallelimportp=&manufactureYearTo=&productNameNot=&sideMaterialOption=&categoryId=&canTradeP=&neckScaleOption=&fingerboardOption=&pickupComponentOption=&manufactureYearFrom=&weightOptionFrom=&otherOption=&soldoutDispCheck=false&ecpurchasep=&category12Id=101&shopsalep=&shopNoNot=&priceFrom=&tremolantOption=&backMaterialOption=&readCount=50&areaId=&neckjointOption=&materialOption=&categoryIdNot=&priceTo=&pickupOption=&tagWordsNot=&maxCount=20&keywordAnd=&tagWords=&brandIdNot=&keyword=&conditionTo=&sortKey=INITIAL_PUBLIC_DATE_DESC&shopNo=&category3Id=&noparallelimportp=&areaPrefInfoId=&stringsoption=&noshopsalep=false&term=&bodysizeOption=&bodyShapeOption=&currentPage=1&nosoldoutp=&productName=&campaign1p=&officialCouponShopP=false")
        let data = NSData(contentsOf: url! as URL)
        
        if Guitar_Flag == 1{
            guitar_model.removeAll()
            guitar_title.removeAll()
            guitar_url.removeAll()
            guitar_inner.removeAll()
            guitar_date.removeAll()
            guitar_shop_name.removeAll()
            guitar_shop_url.removeAll()
            for i in 0 ..< guitar_use.count{
                guitar_use[i].removeAll()
            }
            guitar_use_count = 0
           // guitar_use.removeAll()
            guitar_pic_url.removeAll()
            guitar_price.removeAll()
            guitar_ship_price.removeAll()
            guitar_state.removeAll()
            guitar_soldout.removeAll()
            
            print("Yes!")
           // print(guitar_pic_url.count)
        }
        
        let doc : HTMLDocument
        do{
            doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
            for node in (doc.body?.css("div"))!{
                if (node.className ?? String()).contains("itemSearchBlock clearfix"){
                    GetTitle(node: node)
                    GetPic(node: node)
                }
            }
        }catch{
            print("Error.")
        }
        
        for i in 0 ..< guitar_title.count{
           /* print(guitar_title[i])
            print(guitar_price[i])
            print(guitar_ship_price[i])
            print(guitar_soldout[i])
            print(guitar_pic_url[i])
            print(guitar_url[i])
            print(guitar_use[i])
            print(guitar_state[i])
            print(guitar_date[i])
            print(guitar_shop_url[i])
            print(guitar_shop_name[i])
            print(guitar_inner[i])
            print(i)
            print("///////////////////////////////////////////////////////////////")*/
            
            guitar_model.append(GuitarCellModel(M_guitar_title:guitar_title[i],M_guitar_url:guitar_url[i],M_guitar_inner:guitar_inner[i],M_guitar_date:guitar_date[i],M_guitar_shop_name:guitar_shop_name[i],M_guitar_shop_url:guitar_shop_url[i],M_guitar_use:guitar_use[i],M_guitar_pic_url:guitar_pic_url[i],M_guitar_price:guitar_price[i],M_guitar_ship_price:guitar_ship_price[i],M_guitar_state:guitar_state[i],M_guitar_soldout:guitar_soldout[i]))
            
        }
        
        Table_View_Guitar.estimatedRowHeight = 600
        Table_View_Guitar.rowHeight = UITableViewAutomaticDimension
        Table_View_Guitar.delegate = self
        Table_View_Guitar.dataSource = self
        
    }
/*--------------------------------------商品のタイトル等を抽出------------------------------------------*/
    func GetTitle(node:XMLElement){
        for date_node in node.css("ul"){
            if date_node.className == "itemDateInfo"{
                let date = date_node.css("li").first
                guitar_date.append((date?.nextSibling)?.content ?? String())
            }
        }
        for inner_node in node.css("p"){
            if (inner_node.className ?? String()) == "ttl"{
                for inner_node_a in inner_node.css("a"){
                    guitar_title.append(inner_node_a.content ?? String())
                    guitar_url.append("https://www.digimart.net" + inner_node_a["href"]! )
                    guitar_inner.append((inner_node.nextSibling)?.content ?? String())
                }
            }
            if (inner_node.className ?? String()) == "itemShopInfo"{
                guitar_shop_name.append(inner_node.content ?? String())
                let shop_inner = inner_node.css("a").first
                guitar_shop_url.append("https://www.digimart.net" + shop_inner!["href"]!)
            }
        }
    }
 
/*-----------------------------------商品の写真等を抽出---------------------------------------------*/
    func GetPic(node:XMLElement){
        var flag = 0
        var order_flag = 0
        for inner_node in node.css("ul"){
            if inner_node.className == "itemCategoryIconList"{
                if guitar_use_count != 0 && Guitar_Flag != 1{
                    guitar_use.append([])
                }
                for li_node in inner_node.css("img"){
                    guitar_use[guitar_use_count].append(li_node["alt"] ?? String())
                }
                guitar_use_count = guitar_use_count + 1
            }
        }
        for div_node in node.css("div"){
            if div_node.className == "pic"{
                guitar_pic_url.append("https:" + div_node.css("img").first!["src"]!)
                
            }
            if div_node.className == "itemState " || div_node.className == "itemStateIn"{
                for p_node in div_node.css("p"){
                    if p_node.className == "price"{
                        if flag == 0{
                            guitar_price.append(p_node.content ?? String())
                            guitar_ship_price.append((p_node.nextSibling)?.content ?? String())
                            
                            flag = 1
                        }
                    }
                    if p_node.className == "state"{
                        guitar_state.append(p_node.content ?? String())
                    }
                    if p_node.className == "order"{
                        guitar_soldout.append(p_node.css("img").first!["alt"]!)
                        order_flag = 1
                    }
                }
                if order_flag == 0{
                    guitar_soldout.append("")
                }
                flag = 0
                order_flag = 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guitar_model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuitarCell", for: indexPath) as! GuitarCustomCell
        cell.SetCell(Model: guitar_model[indexPath.row])
       // print(cell.Guitar_Title.text ?? String())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.height/3
    }
    
     @objc func refresh(sender:UIRefreshControl){
        Guitar_Flag = 1
        sender.beginRefreshing()
        if Guitar_Refresh == 0{
           // loadView()
            viewDidLoad()
            Table_View_Guitar.reloadData()
            Guitar_Refresh = 1
        }
        
        sender.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


