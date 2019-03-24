//
//  ViewController.swift
//  LiveStreamFails
//
//  Created by Arnaldo on 3/24/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit
import MMPlayerView
import AVKit
import Kingfisher
import SVProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var offsetObservation: NSKeyValueObservation?
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 10)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspectFill
        l.thumbImageView.contentMode = .scaleAspectFill
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    var videos = [Video]()
    let viewModel = Binder.resolve(StreamViewModelProtocol.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    deinit {
        offsetObservation?.invalidate()
        offsetObservation = nil
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    fileprivate func loadData() {
        SVProgressHUD.show()
        viewModel?.loadStreams { [weak self] (videos) in
            SVProgressHUD.dismiss()
            self?.videos = videos
            self?.tableView.delegate = self
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
        }
    }
    
    fileprivate func setupViews() {
        tableView.isHidden = true
        tableView.separatorColor = .clear
        tableView.separatorInset = .zero
        offsetObservation = tableView.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.3)
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateByContentOffset()
            self?.startLoading()
        }
    }

    @objc fileprivate func startLoading() {
        if self.presentedViewController != nil {
            return
        }
        mmPlayerLayer.resume()
    }
    
    fileprivate func updateByContentOffset() {
        let p = CGPoint(x: tableView.frame.width/2, y: tableView.contentOffset.y + tableView.frame.width/2)
        
        if let path = tableView.indexPathForRow(at: p),
            self.presentedViewController == nil {
            self.updateCell(at: path)
        }
    }
    
    fileprivate func updateCell(at indexPath: IndexPath) {
        let video = videos[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? VideoCell {
            mmPlayerLayer.thumbImageView.kf.setImage(with: video.thumbnailURL)
            if !MMLandscapeWindow.shared.isKeyWindow {
                mmPlayerLayer.playView = cell.previewImage
            }
            mmPlayerLayer.set(url: video.url)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.typeName) as! VideoCell
        cell.data = videos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}
