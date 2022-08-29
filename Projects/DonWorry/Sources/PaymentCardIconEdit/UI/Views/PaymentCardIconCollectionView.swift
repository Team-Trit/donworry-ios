////
////  PaymentCardIconCollectionView.swift
////  DonWorry
////
////  Created by Chanhee Jeong on 2022/08/18.
////  Copyright © 2022 Tr-iT. All rights reserved.
////
//
//import UIKit
//
//class PaymentCardIconCollectionView: UICollectionView {
//
//        // MARK: - Constructors
//        override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//            super.init(frame: .zero , collectionViewLayout: collectionViewLayout)
//            attributes()
//        }
//        
//        required init?(coder: NSCoder) {
//            super.init(coder: coder)
//            print("init(coder:) has not been implemented")
//        }
//        
//}
//
//extension PaymentCardIconCollectionView {
//    
//    func attributes() {
//        self.delegate = self
//        self.dataSource = self
//    }
//
//}
//
//extension PaymentCardIconCollectionView :  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
//    }
//    
//    
//}
