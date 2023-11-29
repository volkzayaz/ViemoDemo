//  SearchVideoViewController.swift
//  Created by Vladislav Soroka on 29.11.2023.

import UIKit
import RxSwift
import RxCocoa
import Toolbox
import RxDataSources
import AVKit

class SearchVideoViewController: UIViewController {

    ///Zero dependency representaton of the screen
    ///On each change viewController rerenders itself
    struct Props {
        
        let videos: [VideoCell.Props]
        
        let queryChange: CommandWith<String>
        
        static var initial: Props { .init(videos: [], queryChange: .nop) }
        
    }; var props: Props = .initial {
        didSet {
            guard isViewLoaded else { return }
            render()
        }
    }
    
    func render() {
        proxy.accept(props.videos)
    }
    
    lazy var proxy = BehaviorRelay(value: props.videos)
    lazy var rxDataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, VideoCell.Props>>(configureCell: { (_, tv, ip, x) in
        
        let cell = tv.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: ip) as! VideoCell
        
        cell.props = x
        
        return cell
        
    })
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        proxy.asDriver()
            .map { [AnimatableSectionModel(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: rxDataSource))
            .disposed(by: rx.disposeBag)
        
        searchField.rx.text
            .notNil()
            .bind { [weak self] x in
                self?.props.queryChange.perform(with: x)
            }
            .disposed(by: rx.disposeBag)
        
        connect()
        
        collectionView.rx.modelSelected(VideoCell.Props.self)
            .subscribe(onNext: { x in
                x.tap.perform()
            })
            .disposed(by: rx.disposeBag)
        
    }
    
}

extension SearchVideoViewController {
    
    ///entry point for ViewController logic
    func connect(  ) {
        
        struct ViewModel {
            var query: String? = "doggy"
            var vimeos: [VimeoVideo] = []
        }
        let viewModel = BehaviorRelay(value: ViewModel( ))
        
        ///perform network query on each query change
        viewModel.map(\.query)
            .notNil()
            .distinctUntilChanged()
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .filter { $0.count > 2 }
            .flatMapLatest { [weak self] x in
                VimeoRequest.list(query: x).rxResponse()
                    .trackOnViewController(self)
                    .silentCatch(handler: self)
            }
            .subscribe(onNext: { x in
                viewModel.mutate { $0.vimeos = x }
            })
            .disposed(by: rx.disposeBag)
            
        ///perform update UI on each video list change
        viewModel.asDriver()
            .distinctUntilChanged(\.vimeos)
            .drive(onNext: { [unowned self] vm in
                
                self.props = .init(
                    videos: vm.vimeos.map { v in
                        VideoCell.Props(
                            url: v.thumbnail.url, name: v.name,
                            tap: Command { [weak self] in
                                
                                _ =
                                VimeoRequest.playURL(uri: v.uri)
                                    .rxResponse()
                                    .trackOnViewController(self)
                                    .silentCatch(handler: self)
                                    .subscribe(onNext: { [weak self] x in
                                    
                                        let vc = AVPlayerViewController()
                                        vc.player = .init(url: x)
                                        vc.player?.play()
                                        self?.present.perform(with: vc)
                                        
                                    })
                                
                            }
                        )
                    },
                    queryChange: viewModel.mutate(\.query)
                )
            })
            .disposed(by: rx.disposeBag)
        
    }
 
}
