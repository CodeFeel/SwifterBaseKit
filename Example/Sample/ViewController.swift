//
//  ViewController.swift
//  Sample
//
//  Created by ios on 2021/11/3.
//

import UIKit
import SwifterBaseKit

class ViewController: UIViewController {

    var name = "luowc"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = UIColor.yellow
        
        print(name.isDigits)
        print(name.md5)
        
        
        var sex = "luowc\n123"
        
        var val = "luo\nwc44\n55\n66\naaa"
//        var ss = val.filter {
//            $0 != "\n"
//        }
//        print(ss)
        print(val.filterNoDigits())
        
        print(sex.localized)
        
        Asyncs.async {
            print("111")
        }
        
        print(Fitsize.fit(13))
    }


}


extension String {
    
    func filterLines() -> Int {
        var count = 0
        return self.reduce(0, {
            if $1 == "\n" {
                count = $0 + 1
            }
            return count
        })
    }
    
    func filterNoDigits() -> String {
        let predicateStr: String = "^[0-9.]{1}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return self.filter({ predicate.evaluate(with: String($0)) })
    }
}

extension Storage {
    
    enum Search : UD {
        
        typealias Element = [String]
        case historyKey
        
        func save(_ value: [String]) {
            UserDefaults.standard.setValue(value, forKey: namespace)
            UserDefaults.standard.synchronize()
        }
        
        var value : [String]? {
            guard let arrs = UserDefaults.standard.value(forKey: namespace) as? [String] else { return nil }
            return arrs
        }
    }
}
