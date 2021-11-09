//
//  LockViewOrientatioon.swift
//  ImageViever
//
//  Created by Denis Medvedev on 09/11/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

// MARK: Insert this code in VC, where you want to lock orientation
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //AppUtility.lockOrientation(.portrait)
//        // Or to rotate and lock
//        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Don't forget to reset when view is being removed
//        AppUtility.lockOrientation(.all)
//    }
